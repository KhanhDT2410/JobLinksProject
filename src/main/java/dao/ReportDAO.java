package dao;

import model.Report;
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {
    private final DBContext dbContext = new DBContext();

    // Lưu báo cáo vào cơ sở dữ liệu
    public boolean saveReport(Report report) {
        String sql = "INSERT INTO reports (reporter_id, reported_id, report_type, message, report_time, status) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            int rowsAffected = dbContext.executeUpdate(sql,
                    report.getReporterId(),
                    report.getReportedId(),
                    report.getReportType(),
                    report.getMessage(),
                    report.getReportTime(),
                    report.getStatus());
            System.out.println("Số hàng ảnh hưởng khi lưu báo cáo: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi SQL khi lưu báo cáo: " + e.getMessage());
            return false;
        }
    }

    // Lấy danh sách báo cáo của một người dùng
    public List<Report> getReportsByUserId(int userId) {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT r.report_id, r.reporter_id, r.reported_id, r.report_type, r.message, r.report_time, r.status, u.full_name AS reported_name " +
                     "FROM reports r " +
                     "LEFT JOIN users u ON r.reported_id = u.user_id AND r.reported_id > 0 " +
                     "WHERE r.reporter_id = ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, userId);
            while (rs.next()) {
                Report report = new Report();
                report.setReportId(rs.getInt("report_id"));
                report.setReporterId(rs.getInt("reporter_id"));
                int reportedId = rs.getInt("reported_id");
                report.setReportedId(reportedId);
                report.setReportType(rs.getString("report_type"));
                report.setMessage(rs.getString("message"));
                report.setReportTime(rs.getTimestamp("report_time"));
                report.setStatus(rs.getString("status"));
                report.setReportedName(rs.getString("reported_name"));

                // Phân tách task_id và reported_id
                if (reportedId < 0) {
                    int combinedId = -reportedId;
                    int taskId = combinedId / 1000000; // Lấy phần taskId
                    int userIdReported = combinedId % 1000000; // Lấy phần reportedId
                    if (taskId > 0) {
                        report.setTaskTitle(getTaskTitleById(taskId));
                    }
                    if (userIdReported > 0) {
                        report.setReportedId(userIdReported); // Cập nhật reportedId thực tế
                        report.setReportedName(this.getUserNameById(userIdReported)); // Sử dụng this.getUserNameById
                    }
                }
                reports.add(report);
            }
            System.out.println("Số lượng báo cáo truy xuất cho userId " + userId + ": " + reports.size());
        } catch (SQLException e) {
            System.out.println("Lỗi SQL khi lấy báo cáo: " + e.getMessage());
        } finally {
            dbContext.closeResources(null, rs);
        }
        return reports;
    }

    // Lấy tên người dùng dựa trên user_id
    public String getUserNameById(int userId) {
        String sql = "SELECT full_name FROM users WHERE user_id = ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, userId);
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy tên người dùng: " + e.getMessage());
        } finally {
            dbContext.closeResources(null, rs);
        }
        return "Không xác định";
    }

    // Lấy tiêu đề task dựa trên task_id
    public String getTaskTitleById(int taskId) {
        String sql = "SELECT title FROM tasks WHERE task_id = ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, taskId);
            if (rs.next()) {
                return rs.getString("title");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy tiêu đề task: " + e.getMessage());
        } finally {
            dbContext.closeResources(null, rs);
        }
        return "Không xác định";
    }

    // Lấy danh sách người dùng theo tên (dùng để kiểm tra trùng lặp)
    public List<User> getUsersByName(String name) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name FROM users WHERE full_name LIKE ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, "%" + (name != null ? name : "") + "%");
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách người dùng: " + e.getMessage());
        } finally {
            dbContext.closeResources(null, rs);
        }
        return users;
    }

    // Đóng kết nối khi không cần thiết
    public void close() {
        dbContext.close();
    }
}