package dao;

import java.sql.PreparedStatement;
import model.Review;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ReviewDAO {
    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());

    public ReviewDAO() {
        this.dbContext = new DBContext();
    }

    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.rating, r.comment, r.review_date, u.full_name AS reviewer_name, " +
                     "t.title AS task_title " +
                     "FROM reviews r " +
                     "LEFT JOIN users u ON r.reviewer_id = u.user_id " +
                     "LEFT JOIN tasks t ON r.task_id = t.task_id " +
                     "ORDER BY r.review_date DESC";

        ResultSet rs = null;
        try {
            System.out.println("Executing query: " + sql);
            rs = dbContext.getData(sql);
            if (rs == null) {
                System.out.println("ResultSet is null, check DBContext.getData() implementation.");
                return reviews;
            }
            int rowCount = 0;
            while (rs.next()) {
                int reviewId = rs.getInt("review_id");
                int rating = rs.getInt("rating");
                String comment = rs.getString("comment");
                Timestamp reviewDate = rs.getTimestamp("review_date");
                String reviewerName = rs.getString("reviewer_name");
                String taskTitle = rs.getString("task_title");

                if (reviewerName == null) reviewerName = "Unknown";
                if (taskTitle == null) taskTitle = "No Task";

                Review review = new Review(reviewId, rating, comment, reviewDate, reviewerName, taskTitle);
                reviews.add(review);
                rowCount++;
            }
            if (rowCount == 0) {
                System.out.println("No rows returned from ResultSet.");
            } else {
                System.out.println("Retrieved " + rowCount + " reviews.");
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            dbContext.closeResources(null, rs);
        }
        return reviews;
    }
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (task_id, reviewer_id, reviewee_id, rating, comment, review_date) " +
                     "VALUES (?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement pstmt = dbContext.getConnection().prepareStatement(sql)) {
            pstmt.setInt(1, review.getReviewId()); // Thay bằng task_id nếu cần
            pstmt.setInt(2, review.getRating());   // Thay bằng reviewer_id nếu cần
            pstmt.setInt(3, 0);                    // reviewee_id, cần cập nhật logic
            pstmt.setInt(4, review.getRating());
            pstmt.setString(5, review.getComment());
            pstmt.setTimestamp(6, new Timestamp(review.getReviewDate().getTime()));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error inserting review: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}