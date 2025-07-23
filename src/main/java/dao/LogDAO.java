package dao;

import model.SystemLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogDAO {

    // Lấy số log gần nhất (mới nhất ở trên)
    public List<SystemLog> getRecentLogs(int limit) {
        List<SystemLog> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM system_logs ORDER BY timestamp DESC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy tất cả logs với phân trang và lọc theo thời gian
    public List<SystemLog> getPagedLogs(int page, int pageSize, Timestamp startTime, Timestamp endTime) {
        List<SystemLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM system_logs WHERE 1=1");
        
        if (startTime != null) {
            sql.append(" AND timestamp >= ?");
        }
        if (endTime != null) {
            sql.append(" AND timestamp <= ?");
        }
        sql.append(" ORDER BY timestamp DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (startTime != null) {
                ps.setTimestamp(paramIndex++, startTime);
            }
            if (endTime != null) {
                ps.setTimestamp(paramIndex++, endTime);
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLog(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số log (có thể lọc theo thời gian)
    public int getTotalLogs(Timestamp startTime, Timestamp endTime) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM system_logs WHERE 1=1");
        
        if (startTime != null) {
            sql.append(" AND timestamp >= ?");
        }
        if (endTime != null) {
            sql.append(" AND timestamp <= ?");
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (startTime != null) {
                ps.setTimestamp(paramIndex++, startTime);
            }
            if (endTime != null) {
                ps.setTimestamp(paramIndex, endTime);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tất cả logs (giữ nguyên chức năng cũ)
    public List<SystemLog> getAllLogs() {
        return getPagedLogs(1, Integer.MAX_VALUE, null, null);
    }

    // Thêm 1 bản ghi log vào bảng system_logs
    public void insertLog(SystemLog log) {
        String sql = "INSERT INTO system_logs (user_id, email, action, target, description, timestamp) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getEmail());
            ps.setString(3, log.getAction());
            ps.setString(4, log.getTarget());
            ps.setString(5, log.getDescription());
            ps.setTimestamp(6, log.getTimestamp());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Ánh xạ dữ liệu từ ResultSet sang đối tượng SystemLog
    private SystemLog mapLog(ResultSet rs) throws SQLException {
        return new SystemLog(
                rs.getInt("log_id"),
                rs.getInt("user_id"),
                rs.getString("email"),
                rs.getString("action"),
                rs.getString("target"),
                rs.getString("description"),
                rs.getTimestamp("timestamp")
        );
    }
}