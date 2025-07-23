package controller;

import dao.DBContext;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet để hiển thị hồ sơ của một worker, bao gồm thông tin cơ bản và danh sách đánh giá.
 */
public class ViewProfileServlet extends HttpServlet {
    private DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(ViewProfileServlet.class.getName());

    @Override
    public void init() throws ServletException {
        dbContext = new DBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int workerId;
        try {
            workerId = Integer.parseInt(request.getParameter("workerId"));
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid workerId format", e);
            request.setAttribute("error", "ID ứng viên không hợp lệ.");
            request.getRequestDispatcher("/jobPoster").forward(request, response);
            return;
        }

        // Lấy thông tin cơ bản của worker
        String sqlUser = "SELECT full_name, email, phone, address FROM users WHERE user_id = ?";
        try (ResultSet rs = dbContext.getData(sqlUser, workerId)) {
            if (rs != null && rs.next()) {
                request.setAttribute("workerName", rs.getString("full_name"));
                request.setAttribute("workerEmail", rs.getString("email"));
                request.setAttribute("workerPhone", rs.getString("phone"));
                request.setAttribute("workerAddress", rs.getString("address"));
            } else {
                request.setAttribute("error", "Không tìm thấy thông tin ứng viên.");
                request.getRequestDispatcher("/jobPoster").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy thông tin hồ sơ", e);
            request.setAttribute("error", "Lỗi khi lấy thông tin hồ sơ: " + e.getMessage());
            request.getRequestDispatcher("/jobPoster").forward(request, response);
            return;
        }

        // Lấy điểm trung bình của đánh giá
        String sqlAvgRating = "SELECT AVG(CAST(rating AS FLOAT)) as avg_rating FROM reviews WHERE reviewee_id = ?";
        try (ResultSet rs = dbContext.getData(sqlAvgRating, workerId)) {
            if (rs != null && rs.next()) {
                double avgRating = rs.getDouble("avg_rating");
                request.setAttribute("avgRating", String.format("%.1f", avgRating));
            } else {
                request.setAttribute("avgRating", "Chưa có đánh giá");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính điểm trung bình đánh giá", e);
            request.setAttribute("avgRating", "Lỗi khi tính điểm trung bình");
        }

        // Lấy danh sách đánh giá
        List<Review> reviews = new ArrayList<>();
        String sqlReviews = "SELECT r.review_id, r.rating, r.comment, r.review_date, t.title " +
                           "FROM reviews r " +
                           "LEFT JOIN tasks t ON r.task_id = t.task_id " +
                           "WHERE r.reviewee_id = ? " +
                           "ORDER BY r.review_date DESC";
        try (ResultSet rs = dbContext.getData(sqlReviews, workerId)) {
            while (rs != null && rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setReviewDate(rs.getTimestamp("review_date"));
                review.setTaskTitle(rs.getString("title"));
                reviews.add(review);
            }
            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewCount", reviews.size());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách đánh giá", e);
            request.setAttribute("error", "Lỗi khi lấy danh sách đánh giá: " + e.getMessage());
        }

        request.getRequestDispatcher("/viewProfile.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        if (dbContext != null) dbContext.close();
    }

    // Lớp nội trồng để lưu trữ thông tin đánh giá
    public static class Review {
        private int reviewId;
        private int rating;
        private String comment;
        private java.sql.Timestamp reviewDate;
        private String taskTitle;

        // Getter và Setter
        public int getReviewId() { return reviewId; }
        public void setReviewId(int reviewId) { this.reviewId = reviewId; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
        public java.sql.Timestamp getReviewDate() { return reviewDate; }
        public void setReviewDate(java.sql.Timestamp reviewDate) { this.reviewDate = reviewDate; }
        public String getTaskTitle() { return taskTitle; }
        public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }
    }
}