package dao;

import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UpdateProfileDAO {
    private final DBContext dbContext;

    public UpdateProfileDAO() {
        this.dbContext = new DBContext();
    }

    public boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setAddress(rs.getString("address"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
            return null;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public boolean updateUserProfile(User user, String fullName, String email, String phone, String address) throws SQLException {
        PreparedStatement stmt = null;
        PreparedStatement notificationStmt = null;
        try {
            Connection conn = dbContext.getConnection();

            // Cập nhật thông tin người dùng
            String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, address = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, address != null ? address : "");
            stmt.setInt(5, user.getUserId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                // Thêm thông báo
                String notificationSql = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
                notificationStmt = conn.prepareStatement(notificationSql);
                notificationStmt.setInt(1, user.getUserId());
                notificationStmt.setString(2, "Hồ sơ của bạn đã được cập nhật thành công.");
                notificationStmt.executeUpdate();
                return true;
            }
            return false;
        } finally {
            // Đóng các PreparedStatement theo thứ tự ngược lại khi mở
            dbContext.closeResources(notificationStmt, null);
            dbContext.closeResources(stmt, null);
        }
    }
}
