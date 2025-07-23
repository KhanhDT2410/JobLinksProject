package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.TaskDAO;
import dao.CategoryDAO;
import dao.NotificationDAO;
import model.Task;
import model.Category;
import model.TaskApplication;
import model.Notification;
import java.time.format.DateTimeFormatter;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.stream.Collectors;

public class LoadJobPosterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoadJobPosterServlet.class.getName());
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            categoryDAO = new CategoryDAO();
            notificationDAO = new NotificationDAO();
            LOGGER.info("LoadJobPosterServlet - DAOs khởi tạo thành công");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DAOs", e);
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null || notificationDAO == null) {
            LOGGER.severe("LoadJobPosterServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            setEmptyAttributes(request);
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String view = request.getParameter("view");

try {
    List<Task> tasks = taskDAO.getTasksByUserId(userId);
    // Lọc các task không phải COMPLETED
    tasks = tasks.stream()
                 .filter(task -> !"COMPLETED".equalsIgnoreCase(task.getStatus()))
                 .collect(Collectors.toList());
    Map<Integer, List<TaskApplication>> applications = new HashMap<>();
    List<Category> categories = categoryDAO.getAllCategories();
    List<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
    
    List<Task> tasksWaitingForPayment = taskDAO.getTasksWaitingForPayment(userId);
    if (tasksWaitingForPayment == null) {
        tasksWaitingForPayment = new ArrayList<>();
        LOGGER.warning("tasksWaitingForPayment returned null for user " + userId);
    }

    if (tasks != null) {
        for (Task task : tasks) {
            List<TaskApplication> taskApps = taskDAO.getApplicationsByTaskId(task.getTaskId());
            if (taskApps != null && !taskApps.isEmpty()) {
                applications.put(task.getTaskId(), taskApps);
            }
        }
    }

    if (categories == null) categories = new ArrayList<>();
    if (notifications == null) notifications = new ArrayList<>();

    request.setAttribute("tasks", tasks);
    request.setAttribute("categories", categories);
    request.setAttribute("applications", applications);
    request.setAttribute("notifications", notifications);
    request.setAttribute("tasksWaitingForPayment", tasksWaitingForPayment);

    if ("post".equals(view)) {
        request.getRequestDispatcher("/postTask.jsp").forward(request, response);
    } else if ("edit".equals(view)) {
        handleEditView(request, response, userId, categories);
    } else if ("hide".equals(view)) {
        handleHideView(request, response, userId);
    } else if ("payments".equals(view)) {
        LOGGER.info("Loading payments view for user " + userId + ", tasksWaitingForPayment size: " + tasksWaitingForPayment.size());
        request.setAttribute("currentView", "payments");
        request.getRequestDispatcher("/paymentConfirmation.jsp").forward(request, response);
    } else {
        request.setAttribute("currentView", "main");
        request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
    }
} catch (SQLException e) {
    handleDatabaseError(request, response, e);
} catch (Exception e) {
    handleGeneralError(request, response, e);
}
    }
    private void handleEditView(HttpServletRequest request, HttpServletResponse response, 
                              int userId, List<Category> categories) 
            throws ServletException, IOException, SQLException {
        String taskIdStr = request.getParameter("taskId");
        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskDAO.getTaskById(taskId);
        
        if (task == null || task.getUserId() != userId) {
            throw new IllegalArgumentException("Không tìm thấy task hoặc không thuộc quyền của bạn");
        }
        
        String normalizedLocation = normalizeLocation(task.getLocation());
        task.setLocation(normalizedLocation);
        String formattedScheduledTime = (task.getScheduledTime() != null) ?
                task.getScheduledTime().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null;
        
        request.setAttribute("task", task);
        request.setAttribute("formattedScheduledTime", formattedScheduledTime);
        request.setAttribute("categories", categories);
        request.setAttribute("taskStatus", task.getStatus());
        request.getRequestDispatcher("/editTask.jsp").forward(request, response);
    }

    private void handleHideView(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException, SQLException {
        String taskIdStr = request.getParameter("taskId");
        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskDAO.getTaskById(taskId);
        
        if (task == null || task.getUserId() != userId) {
            throw new IllegalArgumentException("Không tìm thấy task hoặc không thuộc quyền của bạn");
        }
        
        request.setAttribute("task", task);
        request.getRequestDispatcher("/hideTask.jsp").forward(request, response);
    }

    private void handleDatabaseError(HttpServletRequest request, HttpServletResponse response, SQLException e) 
            throws ServletException, IOException {
        LOGGER.log(Level.SEVERE, "Database error in LoadJobPosterServlet", e);
        String view = request.getParameter("view");
        if ("payments".equals(view)) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            setEmptyAttributes(request);
            request.getRequestDispatcher("/paymentConfirmation.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            setEmptyAttributes(request);
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        }
    }

    private void handleGeneralError(HttpServletRequest request, HttpServletResponse response, Exception e) 
            throws ServletException, IOException {
        LOGGER.log(Level.SEVERE, "General error in LoadJobPosterServlet", e);
        String view = request.getParameter("view");
        if ("payments".equals(view)) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            setEmptyAttributes(request);
            request.getRequestDispatcher("/paymentConfirmation.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            setEmptyAttributes(request);
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        }
    }

    private void setEmptyAttributes(HttpServletRequest request) {
        request.setAttribute("tasks", new ArrayList<Task>());
        request.setAttribute("categories", new ArrayList<Category>());
        request.setAttribute("applications", new HashMap<Integer, List<TaskApplication>>());
        request.setAttribute("notifications", new ArrayList<Notification>());
        request.setAttribute("tasksWaitingForPayment", new ArrayList<Task>());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String normalizeLocation(String location) {
        if (location == null) return "";
        location = location.trim().toLowerCase();
        if (location.contains("hanoi") || location.contains("ha noi")) return "Hanoi";
        if (location.contains("ho chi minh") || location.contains("hcmc")) return "HCMC";
        if (location.contains("da nang") || location.contains("danang")) return "Danang";
        return location; // Giữ nguyên nếu không khớp
    }
}