package controller;

import dao.LogDAO;
import dao.TaskDAO;
import model.SystemLog;
import model.Task;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public class AdminManageTaskServlet extends HttpServlet {

    private TaskDAO taskDAO;
    private LogDAO logDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        logDAO = new LogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        String email = (String) session.getAttribute("email");

        if (userId == null || role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            switch (action != null ? action : "list") {
                case "delete":
                    deleteTask(request, response, userId, email);
                    break;
                case "view":
                    viewTaskDetail(request, response, userId, email);
                    break;
                case "edit":
                    showEditForm(request, response, userId, email);
                    break;
                default:
                    listTasks(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Task> taskList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            taskList = taskDAO.searchTasksByKeyword(keyword);
        } else {
            taskList = taskDAO.getAllTasksByAdmin();
        }

        request.setAttribute("taskList", taskList);
        request.getRequestDispatcher("/admin-manage-task.jsp").forward(request, response);
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response, int userId, String email)
            throws SQLException, IOException {
        String taskIdParam = request.getParameter("taskId");
        if (taskIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list&error=missingTaskId");
            return;
        }

        int taskId = Integer.parseInt(taskIdParam);
        taskDAO.deleteTaskByAdmin(taskId);

        logAction(userId, email, "XÓA", "TASK #" + taskId, "Admin đã xóa công việc có ID " + taskId);

        response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list&deleteSuccess=true");
    }

    private void viewTaskDetail(HttpServletRequest request, HttpServletResponse response, int userId, String email)
            throws SQLException, ServletException, IOException {
        String taskIdParam = request.getParameter("taskId");
        if (taskIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list&error=missingTaskId");
            return;
        }

        int taskId = Integer.parseInt(taskIdParam);
        Task task = taskDAO.getTaskById(taskId);
        request.setAttribute("task", task);

        logAction(userId, email, "XEM", "TASK #" + taskId, "Admin đã xem chi tiết công việc có ID " + taskId);

        request.getRequestDispatcher("/admin-view-task.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, int userId, String email)
            throws SQLException, ServletException, IOException {
        String taskIdParam = request.getParameter("taskId");
        if (taskIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list&error=missingTaskId");
            return;
        }

        int taskId = Integer.parseInt(taskIdParam);
        Task task = taskDAO.getTaskById(taskId);
        request.setAttribute("task", task);

        logAction(userId, email, "SỬA", "TASK #" + taskId, "Admin mở form sửa công việc có ID " + taskId);

        request.getRequestDispatcher("/admin-edit-task.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        try {
            if ("update".equals(action)) {
                updateTask(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        String email = (String) session.getAttribute("email");

        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String clientName = request.getParameter("clientName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String location = request.getParameter("location");
        String scheduledTimeStr = request.getParameter("scheduledTime");
        double budget = Double.parseDouble(request.getParameter("budget"));
        String status = request.getParameter("status");
        String createdAtStr = request.getParameter("createdAt");

        Timestamp scheduledTime = parseTimestampFromString(scheduledTimeStr);
        Timestamp createdAt = parseTimestampFromString(createdAtStr);

        Task task = new Task();
        task.setTaskId(taskId);
        task.setTitle(title);
        task.setDescription(description);
        task.setClientName(clientName);
        task.setCategoryId(categoryId);
        task.setLocation(location);
        task.setScheduledTime(scheduledTime);
        task.setBudget(budget);
        task.setStatus(status);
        task.setCreatedAt(createdAt);

        taskDAO.updateTaskByAdmin(task);

        logAction(userId, email, "CẬP NHẬT", "TASK #" + taskId, "Admin đã cập nhật công việc có ID " + taskId);

        response.sendRedirect(request.getContextPath() + "/admin/AdminManageTaskServlet?action=list&updateSuccess=true");
    }

    private Timestamp parseTimestampFromString(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.isEmpty()) return null;
        if (dateTimeStr.length() == 16) dateTimeStr += ":00";
        return Timestamp.valueOf(dateTimeStr.replace("T", " "));
    }

    private void logAction(int userId, String email, String action, String target, String description) {
        if (email == null) email = "unknown";
        SystemLog log = new SystemLog(0, userId, email, action, target, description, Timestamp.valueOf(LocalDateTime.now()));
        logDAO.insertLog(log);
    }
}
