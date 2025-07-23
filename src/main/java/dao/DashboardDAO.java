package dao;

import model.Task;
import model.User;

import java.sql.*;
import java.util.*;

public class DashboardDAO extends DBContext {

    // Th?ng kê
    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalTasks() {
        String sql = "SELECT COUNT(*) FROM tasks";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countPendingTasks() {
        String sql = "SELECT COUNT(*) FROM tasks WHERE status = 'pending'";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Danh sách 5 ng??i dùng m?i nh?t
    public List<User> getRecentUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM users ORDER BY created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setAddress(rs.getString("address"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setLocked(rs.getBoolean("locked"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Danh sách 5 công vi?c m?i nh?t
    public List<Task> getRecentTasks() {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT TOP 5 t.*, u.full_name AS clientName, c.name AS categoryName "
                + "FROM tasks t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "LEFT JOIN categories c ON t.category_id = c.category_id "
                + "ORDER BY t.created_at DESC";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setBudget(rs.getDouble("budget"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setStatus(rs.getString("status"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setClientName(rs.getString("clientName")); // l?y t? alias full_name
                task.setCategoryName(rs.getString("categoryName"));
                list.add(task);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Chart: Tasks theo tháng
    public List<String> getMonthlyLabels() {
        return Arrays.asList("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    }

    public List<Integer> getMonthlyTaskCounts() {
        List<Integer> counts = new ArrayList<>(Collections.nCopies(12, 0));
        String sql = "SELECT MONTH(created_at) AS month, COUNT(*) AS total FROM tasks GROUP BY MONTH(created_at)";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                int month = rs.getInt("month");
                counts.set(month - 1, rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // Pie chart: task theo category
    public List<String> getTaskTypeLabels() {
        List<String> labels = new ArrayList<>();
        String sql = "SELECT DISTINCT c.name FROM tasks t JOIN categories c ON t.category_id = c.category_id";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                labels.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return labels;
    }

    public List<Integer> getTaskTypeData() {
        List<Integer> data = new ArrayList<>();
        String sql = "SELECT c.name, COUNT(*) AS total FROM tasks t JOIN categories c ON t.category_id = c.category_id GROUP BY c.name";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                data.add(rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}
