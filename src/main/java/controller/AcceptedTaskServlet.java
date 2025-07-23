package controller;

import dao.TaskDAO;
import dao.UserDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.User;
import model.Notification;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class AcceptedTaskServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AcceptedTaskServlet.class.getName());
    private TaskDAO taskDAO;
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        userDAO = new UserDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("AcceptedTaskServlet - Không tìm thấy user hoặc userId trong session");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showAcceptedTasks(request, response, userId);
                    break;
                case "details":
                    showTaskDetails(request, response, userId);
                    break;
                default:
                    showAcceptedTasks(request, response, userId);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AcceptedTaskServlet doGet", e);
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            showAcceptedTasks(request, response, userId);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            switch (action) {
                case "complete":
                    handleTaskCompletion(request, response, userId);
                    break;
                default:
                    response.getWriter().write("{\"success\": false, \"message\": \"Hành động không được hỗ trợ\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AcceptedTaskServlet doPost", e);
            String jsonResponse = "{\"success\": false, \"message\": \"Lỗi: " + e.getMessage().replace("\"", "'") + "\"}";
            response.getWriter().write(jsonResponse);
        }
    }

    private void showAcceptedTasks(HttpServletRequest request, HttpServletResponse response, int userId) {
        try {
            // Lấy thông tin user
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Lấy danh sách công việc đã nhận (status = 'IN_PROGRESS')
            List<Task> acceptedTasks = taskDAO.getAcceptedTasks(userId);
            if (acceptedTasks == null) {
                acceptedTasks = new ArrayList<>();
            }

            // Lấy thông báo
            List<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
            if (notifications == null) {
                notifications = new ArrayList<>();
            }

            // Set attributes
            request.setAttribute("userName", user.getFullName());
            request.setAttribute("userBalance", user.getBalance());
            request.setAttribute("acceptedTasks", acceptedTasks);
            request.setAttribute("notifications", notifications);
            request.setAttribute("currentPage", "acceptedTasks");

            LOGGER.info("Loaded " + acceptedTasks.size() + " accepted tasks for user " + userId);
            
            // Forward to JSP
            request.getRequestDispatcher("/acceptedTasks.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in showAcceptedTasks", e);
            request.setAttribute("error", "Không thể tải danh sách công việc đã nhận. Lỗi cơ sở dữ liệu.");
            try {
                request.getRequestDispatcher("/acceptedTasks.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                LOGGER.log(Level.SEVERE, "Error forwarding to error page", ex);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in showAcceptedTasks", e);
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            try {
                request.getRequestDispatcher("/acceptedTasks.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                LOGGER.log(Level.SEVERE, "Error forwarding to error page", ex);
            }
        }
    }

    private void showTaskDetails(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID công việc không hợp lệ.");
                showAcceptedTasks(request, response, userId);
                return;
            }

            int taskId = Integer.parseInt(taskIdStr);
            Task task = taskDAO.getTaskById(taskId);

            // Kiểm tra quyền truy cập
            if (task == null || !isWorkerAssignedToTask(taskId, userId)) {
                request.setAttribute("error", "Bạn không có quyền xem chi tiết công việc này.");
                showAcceptedTasks(request, response, userId);
                return;
            }

            // Lấy thông tin người đăng việc
            User poster = userDAO.getUserById(task.getUserId());
            if (poster != null) {
                task.setClientName(poster.getFullName());
            }

            request.setAttribute("task", task);
            request.setAttribute("currentPage", "taskDetails");
            request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID công việc không hợp lệ.");
            showAcceptedTasks(request, response, userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in showTaskDetails", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            showAcceptedTasks(request, response, userId);
        }
    }

    private void handleTaskCompletion(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws IOException {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"ID công việc không hợp lệ.\"}");
                return;
            }

            int taskId = Integer.parseInt(taskIdStr);
            
            // Kiểm tra quyền truy cập
            if (!isWorkerAssignedToTask(taskId, userId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"Bạn không có quyền thực hiện hành động này.\"}");
                return;
            }

            // Kiểm tra trạng thái công việc
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || !"IN_PROGRESS".equals(task.getStatus())) {
                response.getWriter().write("{\"success\": false, \"message\": \"Công việc không ở trạng thái có thể hoàn thành.\"}");
                return;
            }

            // Xác nhận hoàn thành công việc
            boolean success = taskDAO.confirmTaskCompletionByWorker(taskId, userId);
            
            if (success) {
                LOGGER.info("Task " + taskId + " marked as completed by worker " + userId);
                response.getWriter().write("{\"success\": true, \"message\": \"Đã xác nhận hoàn thành công việc. Chờ người đăng việc xác nhận để thanh toán.\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể xác nhận hoàn thành công việc. Vui lòng thử lại.\"}");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid task ID format", e);
            response.getWriter().write("{\"success\": false, \"message\": \"ID công việc không hợp lệ.\"}");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in handleTaskCompletion", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi cơ sở dữ liệu. Vui lòng thử lại.\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in handleTaskCompletion", e);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống. Vui lòng thử lại.\"}");
        }
    }

    // Phương thức hỗ trợ kiểm tra worker có được giao công việc này không
private boolean isWorkerAssignedToTask(int taskId, int workerId) throws SQLException {
    try {
        return taskDAO.isWorkerAssignedToTask(taskId, workerId);
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error checking worker assignment", e);
        throw e;
    }
}
}