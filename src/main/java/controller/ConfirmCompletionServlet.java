package controller;

import dao.TaskDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Logger;
import java.util.logging.Level;

public class ConfirmCompletionServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ConfirmCompletionServlet.class.getName());
    private TaskDAO taskDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chuyển hướng đến trang thanh toán nếu truy cập bằng GET
        response.sendRedirect(request.getContextPath() + "/loadJobPoster?view=payments");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("ConfirmCompletionServlet - No user session found");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String taskIdStr = request.getParameter("taskId");

        LOGGER.info("Processing payment confirmation - User: " + userId + ", TaskId: " + taskIdStr);

        // Validate taskId parameter
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            LOGGER.warning("Invalid or missing taskId parameter");
            setErrorAndRedirect(request, response, "ID công việc không hợp lệ.");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            LOGGER.info("Processing payment confirmation for task " + taskId + " by poster " + userId);

            // Validate task and permissions
            ValidationResult validation = validateTaskForPayment(taskId, userId);
            if (!validation.isValid()) {
                LOGGER.warning("Validation failed: " + validation.getErrorMessage());
                setErrorAndRedirect(request, response, validation.getErrorMessage());
                return;
            }

            LOGGER.info("Validation passed, proceeding with payment");

            // Process payment
            boolean success = processPayment(validation.getTask(), validation.getWorkerId(), userId);
            if (success) {
                LOGGER.info("Payment completed successfully for task " + taskId);
                setSuccessAndRedirect(request, response, "Thanh toán thành công! Công việc đã hoàn tất.");
            } else {
                LOGGER.warning("Payment processing failed for task " + taskId);
                setErrorAndRedirect(request, response, "Không thể thực hiện thanh toán. Vui lòng thử lại.");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid taskId format: " + taskIdStr, e);
            setErrorAndRedirect(request, response, "ID công việc không hợp lệ.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during payment confirmation", e);
            setErrorAndRedirect(request, response, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in ConfirmCompletionServlet", e);
            setErrorAndRedirect(request, response, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Kiểm tra tính hợp lệ của công việc trước khi xử lý thanh toán.
     */
    private ValidationResult validateTaskForPayment(int taskId, int posterId) throws SQLException {
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            return new ValidationResult(false, "Công việc không tồn tại.", null, -1);
        }
        if (!taskDAO.isTaskOwnedByPoster(taskId, posterId)) {
            return new ValidationResult(false, "Bạn không có quyền xác nhận công việc này.", null, -1);
        }
        if (!"COMPLETED_BY_WORKER".equals(task.getStatus())) {
            return new ValidationResult(false, "Công việc chưa được worker xác nhận hoàn thành.", null, -1);
        }
        int workerId = taskDAO.getWorkerIdFromTaskAssignment(taskId);
        if (workerId == -1) {
            return new ValidationResult(false, "Không tìm thấy worker được giao công việc này.", null, -1);
        }
        return new ValidationResult(true, null, task, workerId);
    }

    /**
     * Xử lý thanh toán từ poster sang worker.
     */
    private boolean processPayment(Task task, int workerId, int posterId) throws SQLException {
        double amount = task.getBudget();
        
        // Validate amount
        if (amount <= 0) {
            LOGGER.warning("Invalid payment amount: " + amount);
            return false;
        }
        
        User poster = userDAO.getUserById(posterId);
        User worker = userDAO.getUserById(workerId);

        if (poster == null || worker == null) {
            LOGGER.warning("Poster or worker not found - Poster: " + posterId + ", Worker: " + workerId);
            return false;
        }

        if (poster.getBalance() < amount) {
            LOGGER.warning("Insufficient balance for poster " + posterId + ". Required: " + amount + ", Available: " + poster.getBalance());
            return false;
        }

        // Kiểm tra xem task đã được thanh toán chưa
        if ("COMPLETED".equals(task.getStatus())) {
            LOGGER.warning("Task " + task.getTaskId() + " already completed and paid");
            return false;
        }

        try {
            // Cập nhật số dư
            double newPosterBalance = poster.getBalance() - amount;
            double newWorkerBalance = worker.getBalance() + amount;
            
            boolean posterUpdateSuccess = userDAO.updateBalance(posterId, newPosterBalance);
            if (!posterUpdateSuccess) {
                LOGGER.warning("Failed to update poster balance");
                return false;
            }
            
            boolean workerUpdateSuccess = userDAO.updateBalance(workerId, newWorkerBalance);
            if (!workerUpdateSuccess) {
                LOGGER.warning("Failed to update worker balance");
                // Rollback poster balance
                userDAO.updateBalance(posterId, poster.getBalance());
                return false;
            }

            // Cập nhật trạng thái công việc
            boolean statusUpdateSuccess = taskDAO.updateTaskStatus(task.getTaskId(), "COMPLETED");
            if (!statusUpdateSuccess) {
                LOGGER.warning("Failed to update task status");
                // Rollback balances
                userDAO.updateBalance(posterId, poster.getBalance());
                userDAO.updateBalance(workerId, worker.getBalance());
                return false;
            }

            // Ghi lại thanh toán
            Timestamp now = new Timestamp(System.currentTimeMillis());
            try {
                taskDAO.recordPayment(task.getTaskId(), amount, now);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to record payment but transaction completed", e);
            }

            // Gửi thông báo cho worker
            try {
                String message = "Bạn đã nhận được thanh toán " + amount + " VND cho công việc '" + task.getTitle() + "'";
                taskDAO.sendNotification(workerId, message, now);
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to send notification but payment completed", e);
            }

            LOGGER.info("Payment successful - Task: " + task.getTaskId() + ", Amount: " + amount + ", From: " + posterId + " To: " + workerId);
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during payment processing", e);
            throw e;
        }
    }

    private void setErrorAndRedirect(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws IOException {
        request.getSession().setAttribute("error", errorMessage);
        response.sendRedirect(request.getContextPath() + "/loadJobPoster?view=payments");
    }

    private void setSuccessAndRedirect(HttpServletRequest request, HttpServletResponse response, String successMessage) 
            throws IOException {
        request.getSession().setAttribute("success", successMessage);
        response.sendRedirect(request.getContextPath() + "/loadJobPoster?view=payments");
    }

    /**
     * Class nội bộ để lưu kết quả kiểm tra tính hợp lệ.
     */
    private static class ValidationResult {
        private boolean valid;
        private String errorMessage;
        private Task task;
        private int workerId;

        public ValidationResult(boolean valid, String errorMessage, Task task, int workerId) {
            this.valid = valid;
            this.errorMessage = errorMessage;
            this.task = task;
            this.workerId = workerId;
        }

        public boolean isValid() { return valid; }
        public String getErrorMessage() { return errorMessage; }
        public Task getTask() { return task; }
        public int getWorkerId() { return workerId; }
    }
}