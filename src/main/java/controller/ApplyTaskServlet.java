package controller;

import dao.DBContext;
import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ApplyTaskServlet extends HttpServlet {
    private DBContext dbContext;
    private TaskDAO taskDAO;
    private static final Logger LOGGER = Logger.getLogger(ApplyTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        try {
            dbContext = new DBContext();
            taskDAO = new TaskDAO();
            LOGGER.info("ApplyTaskServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ApplyTaskServlet", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("ApplyTaskServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/applyTask.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            LOGGER.warning("ApplyTaskServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int workerId = user.getUserId();
        String action = request.getParameter("action");

        if ("apply".equals(action)) {
            handleApplyTask(request, response, workerId);
        } else if ("cancel".equals(action)) {
            try {
                handleCancelApplication(request, response, workerId);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error cancelling application", e);
                request.setAttribute("error", "Database error occurred. Please try again later.");
                response.sendRedirect(request.getContextPath() + "/tasks?action=applied");
            }
        } else {
            LOGGER.warning("ApplyTaskServlet: Invalid action specified");
            response.sendRedirect(request.getContextPath() + "/tasks");
        }
    }

private void handleApplyTask(HttpServletRequest request, HttpServletResponse response, int workerId) 
        throws ServletException, IOException {
    String taskIdStr = request.getParameter("task_id");
    
    // Validate task ID
    if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
        LOGGER.warning("ApplyTaskServlet: Task ID is required");
        request.setAttribute("error", "Task ID is required.");
        request.getRequestDispatcher("applyTask.jsp").forward(request, response);
        return;
    }

    int taskId;
    try {
        taskId = Integer.parseInt(taskIdStr);
    } catch (NumberFormatException e) {
        LOGGER.log(Level.WARNING, "Invalid Task ID format: " + taskIdStr, e);
        request.setAttribute("error", "Invalid Task ID format.");
        request.getRequestDispatcher("applyTask.jsp?task_id=" + taskIdStr).forward(request, response);
        return;
    }

    // Validate message
    String message = request.getParameter("message");
    if (message == null || message.trim().isEmpty()) {
        LOGGER.warning("ApplyTaskServlet: Application message is required");
        request.setAttribute("error", "Application message is required.");
        request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
        return;
    }

    // Check if already applied (using TaskDAO)
    try {
        if (taskDAO.hasApplied(taskId, workerId)) {
            LOGGER.warning("ApplyTaskServlet: Worker " + workerId + " has already applied for task " + taskId);
            request.setAttribute("error", "You have already applied for this task.");
            request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
            return;
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error checking if worker has applied for task " + taskId, e);
        request.setAttribute("error", "Error checking application status. Please try again later.");
        request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
        return;
    }

    // Insert application
    String sql = "INSERT INTO task_applications (task_id, worker_id, message, status, applied_at) " +
                 "VALUES (?, ?, ?, 'pending', ?)";
    
    try {
        int rowsAffected = dbContext.executeUpdate(sql, taskId, workerId, message.trim(), 
                                                 new Timestamp(System.currentTimeMillis()));
        
        if (rowsAffected > 0) {
            LOGGER.info("Successfully applied for task " + taskId + " by worker " + workerId);
            request.setAttribute("success", "Successfully applied for the task!");

            // Get job poster ID and create notification
            String notificationSql = "INSERT INTO notifications (user_id, message, is_read, created_at) " +
                                   "SELECT user_id, ?, 0, ? FROM tasks WHERE task_id = ?";
            dbContext.executeUpdate(notificationSql, 
                                   "New application received for your task (Task ID: " + taskId + ")",
                                   new Timestamp(System.currentTimeMillis()), taskId);

            request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
        } else {
            LOGGER.warning("No rows affected when applying for task " + taskId);
            request.setAttribute("error", "Failed to apply for the task. Please try again.");
            request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
        }
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Database error while applying for task " + taskId, e);
        if (e.getMessage() != null && e.getMessage().toLowerCase().contains("duplicate")) {
            request.setAttribute("error", "You have already applied for this task.");
        } else {
            request.setAttribute("error", "Database error occurred. Please try again later.");
        }
        request.getRequestDispatcher("applyTask.jsp?task_id=" + taskId).forward(request, response);
    }
}

    private void handleCancelApplication(HttpServletRequest request, HttpServletResponse response, int workerId) 
            throws ServletException, IOException, SQLException {
        String applicationIdStr = request.getParameter("application_id");
        
        if (applicationIdStr == null || applicationIdStr.trim().isEmpty()) {
            LOGGER.warning("ApplyTaskServlet: Application ID is required");
            request.setAttribute("error", "Application ID is required.");
            response.sendRedirect(request.getContextPath() + "/tasks?action=applied");
            return;
        }

        int applicationId;
        try {
            applicationId = Integer.parseInt(applicationIdStr);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid Application ID format: " + applicationIdStr, e);
            request.setAttribute("error", "Invalid Application ID format.");
            response.sendRedirect(request.getContextPath() + "/tasks?action=applied");
            return;
        }

        // Cancel application using TaskDAO
        try {
            boolean success = taskDAO.cancelApplication(applicationId, workerId);
            if (success) {
                LOGGER.info("Application " + applicationId + " cancelled successfully by worker " + workerId);
                request.setAttribute("success", "Application cancelled successfully!");
            } else {
                LOGGER.warning("Failed to cancel application " + applicationId + " for worker " + workerId);
                request.setAttribute("error", "Failed to cancel application. It may not exist or is not pending.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while cancelling application " + applicationId, e);
            request.setAttribute("error", "Database error occurred. Please try again later.");
        }
        
        response.sendRedirect(request.getContextPath() + "/tasks?action=applied");
    }

    @Override
    public void destroy() {
        try {
            if (dbContext != null) {
                dbContext.close();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error closing database connection", e);
        }
        super.destroy();
    }
}