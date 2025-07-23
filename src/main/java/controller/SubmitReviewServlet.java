package controller;

import dao.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SubmitReviewServlet extends HttpServlet {
    private DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(SubmitReviewServlet.class.getName());
    private static final long SEVEN_DAYS_IN_MILLIS = 7 * 24 * 60 * 60 * 1000L;

    @Override
    public void init() throws ServletException {
        dbContext = new DBContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response encoding
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        int taskId;
        int rating;
        int revieweeId;
        String comment;
        int reviewerId;
        
        try {
            // Lấy parameters từ request
            taskId = Integer.parseInt(request.getParameter("task_id"));
            rating = Integer.parseInt(request.getParameter("rating"));
            revieweeId = Integer.parseInt(request.getParameter("reviewee_id"));
            comment = request.getParameter("comment");
            
            // Kiểm tra session
            Object userIdObj = request.getSession().getAttribute("userId");
            if (userIdObj == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            reviewerId = Integer.parseInt(userIdObj.toString());
            
            // Validate dữ liệu
            if (comment == null || comment.trim().isEmpty()) {
                redirectWithError(request, response, "Bình luận không được để trống.");
                return;
            }
            
            if (rating < 1 || rating > 5) {
                redirectWithError(request, response, "Điểm đánh giá phải từ 1 đến 5 sao.");
                return;
            }
            
            // Debug log
            LOGGER.info("Processing review - TaskId: " + taskId + ", ReviewerId: " + reviewerId + 
                       ", RevieweeId: " + revieweeId + ", Rating: " + rating);
            
        } catch (NumberFormatException | NullPointerException e) {
            LOGGER.log(Level.SEVERE, "Dữ liệu đầu vào không hợp lệ", e);
            redirectWithError(request, response, "Dữ liệu đầu vào không hợp lệ.");
            return;
        }
        
        // Kiểm tra quyền đánh giá (phải là job poster của task)
        if (!isJobPoster(taskId, reviewerId)) {
            redirectWithError(request, response, "Bạn không có quyền đánh giá công việc này.");
            return;
        }
        
        // Kiểm tra thời gian đánh giá
        if (!isWithinReviewTime(taskId)) {
            redirectWithError(request, response, "Đã hết thời hạn 7 ngày để gửi đánh giá cho công việc này.");
            return;
        }
        
        // Kiểm tra xem có phải worker đã hoàn thành task không
        if (!isValidWorker(taskId, revieweeId)) {
            redirectWithError(request, response, "Worker không hợp lệ cho công việc này.");
            return;
        }
        
        // Kiểm tra xem đã có review chưa
        if (hasExistingReview(taskId, reviewerId)) {
            redirectWithError(request, response, "Bạn đã đánh giá công việc này rồi.");
            return;
        }
        
        // Lưu đánh giá
        if (saveReview(taskId, reviewerId, revieweeId, rating, comment.trim())) {
            // Gửi thông báo cho worker
            sendNotificationToWorker(taskId, revieweeId);
            
            // Lấy thông tin task để hiển thị trong thông báo
            String taskTitle = getTaskTitle(taskId);
            String successMessage = "Đánh giá đã được gửi thành công cho công việc: " + taskTitle + 
                                   " (Điểm: " + rating + "/5 sao)";
            
            // Redirect với thông báo thành công
            redirectWithSuccess(request, response, successMessage);
        } else {
            redirectWithError(request, response, "Không thể lưu đánh giá. Vui lòng thử lại.");
        }
    }
    
    private String getTaskTitle(int taskId) {
        String sql = "SELECT title FROM tasks WHERE task_id = ?";
        try (ResultSet rs = dbContext.getData(sql, taskId)) {
            if (rs.next()) {
                return rs.getString("title");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể lấy title của task", e);
        }
        return "Công việc #" + taskId;
    }
    
    private boolean isJobPoster(int taskId, int userId) {
        String sql = "SELECT user_id FROM tasks WHERE task_id = ? AND status = 'completed'";
        try (ResultSet rs = dbContext.getData(sql, taskId)) {
            return rs.next() && rs.getInt("user_id") == userId;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra quyền jobPoster", e);
            return false;
        }
    }
    
    private boolean isWithinReviewTime(int taskId) {
        String checkTimeSql = "SELECT payment_time FROM payments WHERE task_id = ?";
        try (ResultSet rs = dbContext.getData(checkTimeSql, taskId)) {
            if (rs.next()) {
                Timestamp paymentTime = rs.getTimestamp("payment_time");
                if (paymentTime != null) {
                    long currentTime = System.currentTimeMillis();
                    return (currentTime - paymentTime.getTime()) <= SEVEN_DAYS_IN_MILLIS;
                }
            }
            
            // Fallback: kiểm tra theo scheduled_time
            String fallbackSql = "SELECT scheduled_time FROM tasks WHERE task_id = ?";
            try (ResultSet rsFallback = dbContext.getData(fallbackSql, taskId)) {
                if (rsFallback.next()) {
                    Timestamp scheduledTime = rsFallback.getTimestamp("scheduled_time");
                    if (scheduledTime != null) {
                        long currentTime = System.currentTimeMillis();
                        return (currentTime - scheduledTime.getTime()) <= SEVEN_DAYS_IN_MILLIS;
                    }
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra thời gian đánh giá", e);
            return false;
        }
        return false;
    }
    
    private boolean isValidWorker(int taskId, int workerId) {
        String sql = "SELECT worker_id FROM task_assignments WHERE task_id = ? AND worker_id = ?";
        try (ResultSet rs = dbContext.getData(sql, taskId, workerId)) {
            return rs.next();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra worker hợp lệ", e);
            return false;
        }
    }
    
    private boolean hasExistingReview(int taskId, int reviewerId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE task_id = ? AND reviewer_id = ?";
        try (ResultSet rs = dbContext.getData(sql, taskId, reviewerId)) {
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra review đã tồn tại", e);
            return false;
        }
    }
    
    private boolean saveReview(int taskId, int reviewerId, int revieweeId, int rating, String comment) {
        String sql = "INSERT INTO reviews (task_id, reviewer_id, reviewee_id, rating, comment, review_date) " +
                    "VALUES (?, ?, ?, ?, ?, GETDATE())";
        int rowsAffected = dbContext.executeUpdate(sql, taskId, reviewerId, revieweeId, rating, comment);
        LOGGER.info("Review saved successfully. Rows affected: " + rowsAffected);
        return rowsAffected > 0;
    }
    
    private void sendNotificationToWorker(int taskId, int workerId) {
        try {
            String taskTitleSql = "SELECT title FROM tasks WHERE task_id = ?";
            try (ResultSet rs = dbContext.getData(taskTitleSql, taskId)) {
                if (rs.next()) {
                    String taskTitle = rs.getString("title");
                    String notifySql = "INSERT INTO notifications (user_id, message, is_read, created_at) " +
                                      "VALUES (?, ?, 0, GETDATE())";
                    dbContext.executeUpdate(notifySql, workerId, 
                        "Bạn đã nhận được một đánh giá mới cho công việc: " + taskTitle);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể gửi thông báo cho worker", e);
        }
    }
    
    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws IOException {
        try {
            response.sendRedirect(request.getContextPath() + "/completedTasks?error=" + 
                                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi redirect với error", e);
            throw e;
        }
    }
    
    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String successMessage) 
            throws IOException {
        try {
            response.sendRedirect(request.getContextPath() + "/completedTasks?success=" + 
                                java.net.URLEncoder.encode(successMessage, "UTF-8"));
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi redirect với success", e);
            throw e;
        }
    }

    @Override
    public void destroy() {
        if (dbContext != null) dbContext.close();
    }
}