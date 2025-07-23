package dao;

import model.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationDAO {

    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    public NotificationDAO() {
        this.dbContext = new DBContext();
    }

    public List<Notification> getNotificationsByUserId(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT notification_id, user_id, message, is_read, created_at FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Connection conn = dbContext.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("notification_id"));
                notification.setUserId(rs.getInt("user_id"));
                notification.setMessage(rs.getString("message"));
                notification.setIsRead(rs.getBoolean("is_read"));
                notification.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(notification);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy thông báo cho userId: " + userId, e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
        return notifications;
    }

    public void markNotificationAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warning("Không tìm thấy thông báo để đánh dấu đã đọc với ID: " + notificationId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đánh dấu thông báo đã đọc với ID: " + notificationId, e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public void deleteNotification(int notificationId) throws SQLException {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, notificationId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warning("Không tìm thấy thông báo để xóa với ID: " + notificationId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa thông báo với ID: " + notificationId, e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public void createNotification(String message, Integer targetUserId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement userStmt = null;
        ResultSet rs = null;

        try {
            conn = dbContext.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }

            if (targetUserId != null) {
                // Gửi cho 1 user
                String sql = "INSERT INTO notifications (message, user_id, created_at) VALUES (?, ?, GETDATE())";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, message);
                stmt.setInt(2, targetUserId);
                stmt.executeUpdate();
            } else {
                // Gửi cho all user - lấy tất cả user_id
                String userSql = "SELECT user_id FROM users";
                userStmt = conn.prepareStatement(userSql);
                rs = userStmt.executeQuery();

                String insertSql = "INSERT INTO notifications (message, user_id, created_at) VALUES (?, ?, GETDATE())";
                stmt = conn.prepareStatement(insertSql);

                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    stmt.setString(1, message);
                    stmt.setInt(2, userId);
                    stmt.addBatch();
                }

                stmt.executeBatch();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo notification", e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, null);
            dbContext.closeResources(userStmt, rs);
        }
    }
}
