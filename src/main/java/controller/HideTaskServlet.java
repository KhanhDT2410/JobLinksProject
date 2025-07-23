package controller;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import dao.TaskDAO;
import dao.CategoryDAO;
import model.Task;
import model.Category;

public class HideTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private static final Logger LOGGER = Logger.getLogger(HideTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            categoryDAO = new CategoryDAO();
            LOGGER.info("HideTaskServlet - DAOs khởi tạo thành công");
        } catch (Exception e) {
            LOGGER.severe("HideTaskServlet - Lỗi khởi tạo DAO: " + e.getMessage());
            throw new ServletException("Không thể khởi tạo DAO classes: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null) {
            LOGGER.severe("HideTaskServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String taskIdStr = request.getParameter("taskId");
            LOGGER.info("doGet - Received taskIdStr: '" + taskIdStr + "'");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("ID công việc không hợp lệ");
            }

            int taskId = Integer.parseInt(taskIdStr);
            Task task = taskDAO.getTaskById(taskId);
            LOGGER.info("doGet - Task found: " + (task != null ? "Yes" : "No") + " for taskId=" + taskId);

            if (task == null) {
                throw new IllegalArgumentException("Không tìm thấy task với ID: " + taskId);
            }

            request.setAttribute("task", task);
            request.getRequestDispatcher("/hideTask.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "HideTaskServlet - Lỗi định dạng taskId: " + e.getMessage(), e);
            request.setAttribute("error", "ID công việc không hợp lệ");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "HideTaskServlet - Lỗi tham số: " + e.getMessage(), e);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null) {
            LOGGER.severe("HideTaskServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String taskIdStr = request.getParameter("taskId");
            LOGGER.info("doPost - Received taskIdStr: '" + taskIdStr + "'");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("ID công việc không hợp lệ");
            }
            int taskId = Integer.parseInt(taskIdStr);

            LOGGER.info("HideTaskServlet - Ẩn task: taskId=" + taskId + ", userId=" + userId);

            Task task = taskDAO.getTaskById(taskId);
            LOGGER.info("doPost - Task found: " + (task != null ? "Yes" : "No") + " for taskId=" + taskId);
            if (task == null) {
                throw new IllegalArgumentException("Không tìm thấy task với ID: " + taskId);
            }

            taskDAO.hideTask(taskId, userId); // Gọi phương thức hideTask
            LOGGER.info("Đã ẩn task thành công: " + taskId);

            response.sendRedirect(request.getContextPath() + "/loadJobPoster");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "HideTaskServlet - Lỗi định dạng taskId: " + e.getMessage(), e);
            handleError(request, response, userId, "ID công việc không hợp lệ");
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "HideTaskServlet - Lỗi tham số: " + e.getMessage(), e);
            handleError(request, response, userId, e.getMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "HideTaskServlet - Lỗi cơ sở dữ liệu: " + e.getMessage(), e);
            handleError(request, response, userId, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "HideTaskServlet - Lỗi không xác định: " + e.getMessage(), e);
            handleError(request, response, userId, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, int userId, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        try {
            List<Task> tasks = taskDAO.getTasksByUserId(userId);
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("tasks", tasks != null ? tasks : new ArrayList<Task>());
            request.setAttribute("categories", categories != null ? categories : new ArrayList<Category>());
            request.getRequestDispatcher("/hideTask.jsp").forward(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "HideTaskServlet - Lỗi trong handleError: " + ex.getMessage(), ex);
            request.setAttribute("error", errorMessage + " | Không thể tải dữ liệu: " + ex.getMessage());
            request.setAttribute("tasks", new ArrayList<Task>());
            request.setAttribute("categories", new ArrayList<Category>());
            request.getRequestDispatcher("/hideTask.jsp").forward(request, response);
        }
    }
}