package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Message;
import model.User;

public class MessageDAO {

    private Connection connection;

    public MessageDAO() {
        DBContext dbContext = new DBContext();
        this.connection = dbContext.getConnection();
        if (connection == null) {
            System.out.println("Database connection is null!");
        }
    }

    private static final int DEFAULT_TASK_ID = 1;

    public boolean sendMessage(Message message) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, task_id, message) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, message.getSenderId());
            ps.setInt(2, message.getReceiverId());
            ps.setInt(3, message.getTaskId());
            ps.setString(4, message.getMessage());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Message> getMessagesBetweenUsers(int userId1, int userId2, int taskId) throws SQLException {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT message_id, sender_id, receiver_id, task_id, message, sent_at " +
                    "FROM messages " +
                    "WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) " +
                    "AND task_id = ? " +
                    "ORDER BY sent_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId1);
            ps.setInt(2, userId2);
            ps.setInt(3, userId2);
            ps.setInt(4, userId1);
            ps.setInt(5, taskId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message message = new Message();
                message.setMessageId(rs.getInt("message_id"));
                message.setSenderId(rs.getInt("sender_id"));
                message.setReceiverId(rs.getInt("receiver_id"));
                message.setTaskId(rs.getInt("task_id"));
                message.setMessage(rs.getString("message"));
                message.setSentAt(rs.getTimestamp("sent_at"));
                messages.add(message);
            }
        }
        return messages;
    }

    public List<Map<String, Object>> getAllUsersWithLatestMessage(int currentUserId) throws SQLException {
        if (connection == null) {
            throw new SQLException("Database connection is null");
        }
        List<Map<String, Object>> users = new ArrayList<>();
        String sql = "SELECT u.user_id AS userId, u.full_name AS fullName, " +
                    "m.message AS latestMessage, m.sent_at AS latestMessageTime, m.sender_id AS senderId " +
                    "FROM users u " +
                    "LEFT JOIN messages m ON ((m.sender_id = u.user_id AND m.receiver_id = ?) OR (m.receiver_id = u.user_id AND m.sender_id = ?)) " +
                    "AND m.task_id = ? " +
                    "AND m.sent_at = (" +
                    "    SELECT MAX(sent_at) " +
                    "    FROM messages m2 " +
                    "    WHERE ((m2.sender_id = u.user_id AND m2.receiver_id = ?) OR (m2.receiver_id = u.user_id AND m2.sender_id = ?)) " +
                    "    AND m2.task_id = ?" +
                    ") " +
                    "WHERE u.user_id != ? " +
                    "GROUP BY u.user_id, u.full_name, m.message, m.sent_at, m.sender_id " +
                    "ORDER BY CASE WHEN m.sent_at IS NULL THEN 1 ELSE 0 END, m.sent_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);
            ps.setInt(3, DEFAULT_TASK_ID);
            ps.setInt(4, currentUserId);
            ps.setInt(5, currentUserId);
            ps.setInt(6, DEFAULT_TASK_ID);
            ps.setInt(7, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("userId", rs.getInt("userId"));
                    user.put("fullName", rs.getString("fullName"));
                    user.put("latestMessage", rs.getString("latestMessage"));
                    user.put("latestMessageTime", rs.getTimestamp("latestMessageTime"));
                    user.put("senderId", rs.getInt("senderId"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllUsersWithLatestMessage: " + e.getMessage());
            throw e;
        }
        return users;
    }

    public boolean deleteMessage(int messageId, int userId) throws SQLException {
        String sql = "DELETE FROM messages WHERE message_id = ? AND sender_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsersExceptCurrent(int currentUserId) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE user_id != ? ORDER BY full_name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                users.add(user);
            }
        }
        return users;
    }
}