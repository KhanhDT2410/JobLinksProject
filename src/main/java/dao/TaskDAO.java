package dao;

import jakarta.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Task;
import model.TaskApplication;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;

public class TaskDAO {

    private DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(TaskDAO.class.getName());
    private final TaskBoostManager boostManager = TaskBoostManager.getInstance();

    public TaskDAO() {
        this.dbContext = new DBContext();
    }

    public void createTask(Task task) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho createTask.");
            dbContext = new DBContext();
        }
        String sql = "INSERT INTO tasks (user_id, title, description, category_id, location, scheduled_time, budget, status, is_boosted, boost_expiry) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            dbContext.executeUpdate(sql,
                    task.getUserId(),
                    task.getTitle(),
                    task.getDescription(),
                    task.getCategoryId(),
                    task.getLocation(),
                    task.getScheduledTime(),
                    task.getBudget(),
                    task.getStatus() != null ? task.getStatus() : "pending",
                    false, // Mặc định is_boosted = false
                    null); // Mặc định boost_expiry = NULL
            LOGGER.info("Đã thêm task: " + task.getTitle() + ", Category ID: " + task.getCategoryId());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm task: " + e.getMessage(), e);
            throw new SQLException("Lỗi khi thêm task: " + e.getMessage(), e);
        }
    }

    public List<Category> getAllCategories() throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getAllCategories.");
            dbContext = new DBContext();
        }
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, name FROM categories";
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql);
            while (rs != null && rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
            LOGGER.info("Retrieved " + categories.size() + " categories");
            return categories;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách categories: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }
    }

    public List<Task> getRecommendedTasksWithFilters(String searchKeyword, String location, Double budgetMin, Double budgetMax, Integer categoryId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getRecommendedTasksWithFilters.");
            dbContext = new DBContext();
        }
        List<Task> tasks = new ArrayList<>();
        LOGGER.info("Filtering tasks with: searchKeyword=" + searchKeyword + ", location=" + location +
                    ", budgetMin=" + budgetMin + ", budgetMax=" + budgetMax + ", categoryId=" + categoryId);

        StringBuilder sql = new StringBuilder("SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.status IN ('pending', 'open') AND t.is_hidden = 0");

        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND LOWER(CAST(t.title AS NVARCHAR)) COLLATE Vietnamese_CI_AS LIKE ?");
            params.add("%" + searchKeyword.trim().toLowerCase() + "%");
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND LOWER(CAST(t.location AS NVARCHAR)) COLLATE Vietnamese_CI_AS LIKE ?");
            params.add("%" + location.trim().toLowerCase() + "%");
        }

        if (budgetMin != null || budgetMax != null) {
            sql.append(" AND t.budget BETWEEN ? AND ?");
            params.add(budgetMin != null ? budgetMin : 0.0);
            params.add(budgetMax != null ? budgetMax : Double.MAX_VALUE);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND t.category_id = ?");
            params.add(categoryId);
        }

        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql.toString(), params.toArray());
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }

            tasks.sort(Comparator.comparing(Task::isBoosted, Comparator.reverseOrder())
                    .thenComparing((Task t) -> t.getBoostedAt() != null ? t.getBoostedAt() : new Timestamp(0), Comparator.reverseOrder())
                    .thenComparing(Task::getCreatedAt, Comparator.reverseOrder()));

            LOGGER.info("Retrieved " + tasks.size() + " filtered tasks");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting filtered tasks: " + e.getMessage(), e);
            throw new SQLException("Database error while retrieving filtered tasks: " + e.getMessage(), e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }
public List<Task> getLimitedRecommendedTasksWithFilters(String searchKeyword, String location, Double budgetMin, Double budgetMax, Integer categoryId, int taskId, int userId, int limit) throws SQLException {
    if (!dbContext.isConnected()) {
        LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getLimitedRecommendedTasksWithFilters.");
        dbContext = new DBContext();
    }
    List<Task> boostedTasks = new ArrayList<>();
    List<Task> nonBoostedTasks = new ArrayList<>();
    LOGGER.info("Filtering tasks with: searchKeyword=" + searchKeyword + ", location=" + location +
                ", budgetMin=" + budgetMin + ", budgetMax=" + budgetMax + ", categoryId=" + categoryId +
                ", taskId=" + taskId + ", userId=" + userId + ", limit=" + limit);

    StringBuilder sql = new StringBuilder("SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
            "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
            "FROM tasks t " +
            "LEFT JOIN users u ON t.user_id = u.user_id " +
            "LEFT JOIN categories c ON t.category_id = c.category_id " +
            "WHERE t.status IN ('pending', 'open') AND t.is_hidden = 0 AND t.task_id != ? AND t.user_id != ?");

    List<Object> params = new ArrayList<>();
    params.add(taskId);
    params.add(userId);

    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        sql.append(" AND LOWER(CAST(t.title AS NVARCHAR)) COLLATE Vietnamese_CI_AS LIKE ?");
        params.add("%" + searchKeyword.trim().toLowerCase() + "%");
    }

    if (location != null && !location.trim().isEmpty()) {
        sql.append(" AND LOWER(CAST(t.location AS NVARCHAR)) COLLATE Vietnamese_CI_AS LIKE ?");
        params.add("%" + location.trim().toLowerCase() + "%");
    }

    if (budgetMin != null || budgetMax != null) {
        sql.append(" AND t.budget BETWEEN ? AND ?");
        params.add(budgetMin != null ? budgetMin : 0.0);
        params.add(budgetMax != null ? budgetMax : Double.MAX_VALUE);
    }

    if (categoryId != null && categoryId > 0) {
        sql.append(" AND t.category_id = ?");
        params.add(categoryId);
    }

    sql.append(" ORDER BY t.is_boosted DESC, t.boost_expiry DESC");

    ResultSet rs = null;
    try {
        rs = dbContext.getData(sql.toString(), params.toArray());
        while (rs != null && rs.next()) {
            Task task = new Task();
            task.setTaskId(rs.getInt("task_id"));
            task.setUserId(rs.getInt("user_id"));
            task.setTitle(rs.getString("title"));
            task.setDescription(rs.getString("description"));
            task.setLocation(rs.getString("location"));
            task.setScheduledTime(rs.getTimestamp("scheduled_time"));
            task.setBudget(rs.getDouble("budget"));
            task.setStatus(rs.getString("status"));
            task.setClientName(rs.getString("client_name"));
            task.setCategoryName(rs.getString("category_name"));
            task.setCreatedAt(rs.getTimestamp("created_at"));
            task.setBoosted(rs.getBoolean("is_boosted"));
            task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
            task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
            if (task.isBoosted()) {
                boostedTasks.add(task);
            } else {
                nonBoostedTasks.add(task);
            }
        }
        LOGGER.info("Retrieved " + boostedTasks.size() + " boosted tasks and " + nonBoostedTasks.size() + " non-boosted tasks");
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error getting filtered tasks: " + e.getMessage(), e);
        throw new SQLException("Database error while retrieving filtered tasks: " + e.getMessage(), e);
    } finally {
        dbContext.closeResources(null, rs);
    }

    // Xáo trộn danh sách không boosted
    Collections.shuffle(nonBoostedTasks);

    // Gộp danh sách: boosted + non-boosted (giới hạn tổng số)
    List<Task> tasks = new ArrayList<>();
    tasks.addAll(boostedTasks);
    tasks.addAll(nonBoostedTasks.subList(0, Math.min(nonBoostedTasks.size(), limit - boostedTasks.size())));

    LOGGER.info("Final recommended tasks: " + tasks.size() + " (Boosted: " + boostedTasks.size() + ", Non-boosted: " + (tasks.size() - boostedTasks.size()) + ")");
    for (Task task : tasks) {
        LOGGER.info("Task: id=" + task.getTaskId() + ", boosted=" + task.isBoosted() + ", title=" + task.getTitle());
    }

    return tasks;
}
    public List<Task> getAvailableTasks(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getAvailableTasks.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.status = 'pending' AND t.is_hidden = 0 " +
                "AND (t.task_id NOT IN (" +
                "    SELECT task_id FROM task_applications WHERE worker_id = ? AND status = 'pending'" +
                ") OR NOT EXISTS (" +
                "    SELECT 1 FROM task_applications WHERE worker_id = ? AND task_id = t.task_id" +
                ")) ";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, userId, userId);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }

            tasks.sort(Comparator.comparing(Task::isBoosted, Comparator.reverseOrder())
                    .thenComparing((Task t) -> t.getBoostedAt() != null ? t.getBoostedAt() : new Timestamp(0), Comparator.reverseOrder())
                    .thenComparing(Task::getCreatedAt, Comparator.reverseOrder()));

            LOGGER.info("Retrieved " + tasks.size() + " available tasks for user " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting available tasks", e);
            throw new SQLException("Database error while retrieving available tasks", e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public List<Task> getRecommendedTasks() throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getRecommendedTasks.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.status IN ('pending', 'open') AND t.is_hidden = 0";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }

            tasks.sort(Comparator.comparing(Task::isBoosted, Comparator.reverseOrder())
                    .thenComparing((Task t) -> t.getBoostedAt() != null ? t.getBoostedAt() : new Timestamp(0), Comparator.reverseOrder())
                    .thenComparing(Task::getCreatedAt, Comparator.reverseOrder()));

            LOGGER.info("Retrieved " + tasks.size() + " recommended tasks");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recommended tasks: " + e.getMessage(), e);
            throw new SQLException("Database error while retrieving recommended tasks: " + e.getMessage(), e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public List<Task> getTasksByUserId(int userId, String status) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getTasksByUserId.");
            dbContext = new DBContext();
        }
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.task_id, t.user_id, t.title, t.description, t.category_id, c.name AS category_name, t.location, t.scheduled_time, " +
            "t.budget, t.status, t.created_at, t.is_boosted, t.boost_expiry, " +
            "(SELECT COUNT(*) FROM task_applications ta WHERE ta.task_id = t.task_id AND ta.status IN ('pending', 'accepted', 'rejected')) AS application_count " +
            "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id WHERE t.user_id = ? AND t.is_hidden = 0"
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.status = ?");
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            if (status != null && !status.isEmpty()) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskId(rs.getInt("task_id"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setCategoryId(rs.getInt("category_id"));
                    task.setCategoryName(rs.getString("category_name"));
                    task.setLocation(rs.getString("location"));
                    task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    task.setBudget(rs.getDouble("budget"));
                    task.setStatus(rs.getString("status"));
                    task.setCreatedAt(rs.getTimestamp("created_at"));
                    task.setApplicationCount(rs.getInt("application_count"));
                    task.setBoosted(rs.getBoolean("is_boosted"));
                    task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                    task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy tasks cho user ID " + userId + ": " + e.getMessage(), e);
            throw e;
        }
        return tasks;
    }

    public List<Task> getTasksByUserId(int userId) throws SQLException {
        return getTasksByUserId(userId, null); // Gọi phương thức mới với status = null để giữ logic cũ
    }

    public boolean boostTask(int taskId, int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho boostTask.");
            dbContext = new DBContext();
        }
        String sql = "SELECT COUNT(*) FROM tasks WHERE task_id = ? AND user_id = ?";
        try {
            boolean exists = dbContext.queryExists(sql, taskId, userId);
            if (exists) {
                String updateSql = "UPDATE tasks SET is_boosted = ?, boost_expiry = ? WHERE task_id = ? AND user_id = ?";
                Connection conn = dbContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(updateSql);
                stmt.setBoolean(1, true);
                LocalDateTime expiryTime = LocalDateTime.now().plusDays(7);
                stmt.setTimestamp(2, Timestamp.valueOf(expiryTime));
                stmt.setInt(3, taskId);
                stmt.setInt(4, userId);
                int rowsAffected = stmt.executeUpdate();
                stmt.close();

                if (rowsAffected > 0) {
                    boostManager.boostTask(taskId);
                    String logSql = "INSERT INTO system_logs (user_id, email, action, target, description, timestamp) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement logStmt = conn.prepareStatement(logSql);
                    logStmt.setInt(1, userId);
                    logStmt.setString(2, "unknown"); // Thay bằng email người dùng nếu có
                    logStmt.setString(3, "BOOST");
                    logStmt.setString(4, "TASK #" + taskId);
                    logStmt.setString(5, "Người dùng đã boost task ID: " + taskId);
                    logStmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
                    logStmt.executeUpdate();
                    logStmt.close();

                    LOGGER.info("Boost task thành công cho taskId: " + taskId + ", userId: " + userId);
                    return true;
                } else {
                    LOGGER.warning("Không thể cập nhật trạng thái boost cho task " + taskId);
                    return false;
                }
            } else {
                LOGGER.warning("Boost task thất bại: Người dùng " + userId + " không sở hữu task " + taskId);
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi boost task", e);
            throw e;
        }
    }

    public Task getTaskById(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getTaskById.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.task_id = ?";
        ResultSet rs = null;
        Task task = null;

        try {
            rs = dbContext.getData(sql, taskId);
            if (rs != null && rs.next()) {
                task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                LOGGER.info("Retrieved task: ID=" + taskId + ", Category Name=" + task.getCategoryName());
            } else {
                LOGGER.warning("No task found with ID: " + taskId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting task by ID " + taskId + ": " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }

        return task;
    }

    public List<Task> getHiddenTasksByUserId(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getHiddenTasksByUserId.");
            dbContext = new DBContext();
        }

        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.category_id, c.name AS category_name, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, t.created_at, t.is_hidden, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "WHERE t.user_id = ? AND t.is_hidden = 1 " +
                "ORDER BY t.created_at DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            LOGGER.info("Executing query for hidden tasks with userId: " + userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskId(rs.getInt("task_id"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setCategoryId(rs.getInt("category_id"));
                    task.setCategoryName(rs.getString("category_name"));
                    task.setLocation(rs.getString("location"));
                    task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                    task.setBudget(rs.getDouble("budget"));
                    task.setStatus(rs.getString("status"));
                    task.setClientName(rs.getString("client_name"));
                    task.setCreatedAt(rs.getTimestamp("created_at"));
                    task.setIsHidden(rs.getInt("is_hidden"));
                    task.setBoosted(rs.getBoolean("is_boosted"));
                    task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                    task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                    tasks.add(task);
                }
            }

            LOGGER.info("Found " + tasks.size() + " hidden tasks for userId: " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách task đã ẩn: " + e.getMessage(), e);
            throw e;
        }

        return tasks;
    }

    public List<Task> getBookmarkedTasks(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getBookmarkedTasks.");
            dbContext = new DBContext();
        }
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM user_task_bookmarks utb " +
                "JOIN tasks t ON utb.task_id = t.task_id " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE utb.user_id = ? AND t.is_hidden = 0 AND t.status IN ('pending', 'open') " +
                "ORDER BY utb.created_at DESC";

        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, userId);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }
            LOGGER.info("Lấy được " + tasks.size() + " bookmarked tasks cho userId: " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy bookmarked tasks cho userId: " + userId, e);
            throw e;
        } finally {
            if (rs != null) rs.close();
        }
        return tasks;
    }

    public List<Task> getAcceptedTasks(int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getAcceptedTasks.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "JOIN task_assignments ta ON t.task_id = ta.task_id " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE ta.worker_id = ? AND t.status = 'IN_PROGRESS'";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, workerId);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }
            LOGGER.info("Retrieved " + tasks.size() + " accepted tasks for worker " + workerId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting accepted tasks", e);
            throw new SQLException("Database error while retrieving accepted tasks", e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public List<Task> getTasksWaitingForPayment(int posterId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getTasksWaitingForPayment.");
            dbContext = new DBContext();
        }

        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS worker_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry, " +
                "ta.worker_id " +
                "FROM tasks t " +
                "JOIN task_assignments ta ON t.task_id = ta.task_id " +
                "LEFT JOIN users u ON ta.worker_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.user_id = ? AND t.status = 'COMPLETED_BY_WORKER'";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, posterId);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setWorkerName(rs.getString("worker_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setWorkerId(rs.getInt("worker_id"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }
            LOGGER.info("Retrieved " + tasks.size() + " tasks waiting for payment confirmation for poster " + posterId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting tasks waiting for payment", e);
            throw new SQLException("Database error while retrieving tasks waiting for payment", e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public List<Task> searchTasksByKeyword(String keyword) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho searchTasksByKeyword.");
            dbContext = new DBContext();
        }
        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData("SELECT t.task_id, t.user_id, t.title, t.description, t.category_id, t.location, t.scheduled_time, " +
                    "t.budget, t.status, t.created_at, t.is_boosted, t.boost_expiry " +
                    "FROM tasks t WHERE (LOWER(t.title) LIKE ? OR LOWER(t.description) LIKE ?) AND t.is_hidden = 0",
                    "%" + keyword.toLowerCase() + "%", "%" + keyword.toLowerCase() + "%");
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setCategoryId(rs.getInt("category_id"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }

            tasks.sort(Comparator.comparing(Task::isBoosted, Comparator.reverseOrder())
                    .thenComparing((Task t) -> t.getBoostedAt() != null ? t.getBoostedAt() : new Timestamp(0), Comparator.reverseOrder())
                    .thenComparing(Task::getCreatedAt, Comparator.reverseOrder()));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm tasks với từ khóa " + keyword + ": " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }
        return tasks;
    }

    public void updateTask(Task task) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho updateTask.");
            dbContext = new DBContext();
        }
        try {
            int rowsAffected = dbContext.executeUpdate(
                    "UPDATE tasks SET title = ?, description = ?, category_id = ?, location = ?, scheduled_time = ?, budget = ?, is_boosted = ?, boost_expiry = ? WHERE task_id = ? AND user_id = ?",
                    task.getTitle(),
                    task.getDescription(),
                    task.getCategoryId(),
                    task.getLocation(),
                    task.getScheduledTime(),
                    task.getBudget(),
                    task.isBoosted(),
                    task.getBoostExpiry(),
                    task.getTaskId(),
                    task.getUserId());
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task hoặc bạn không có quyền chỉnh sửa");
            }
            LOGGER.info("Đã cập nhật taskId: " + task.getTaskId());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật task ID " + task.getTaskId() + ": " + e.getMessage(), e);
            throw new SQLException("Lỗi khi cập nhật task: " + e.getMessage(), e);
        }
    }

    public void updateTaskByAdmin(Task task) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho updateTaskByAdmin.");
            dbContext = new DBContext();
        }
        try {
            int rowsAffected = dbContext.executeUpdate(
                    "UPDATE tasks SET title = ?, description = ?, location = ?, scheduled_time = ?, budget = ?, status = ?, is_boosted = ?, boost_expiry = ? WHERE task_id = ?",
                    task.getTitle(),
                    task.getDescription(),
                    task.getLocation(),
                    task.getScheduledTime(),
                    task.getBudget(),
                    task.getStatus(),
                    task.isBoosted(),
                    task.getBoostExpiry(),
                    task.getTaskId());
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task với taskId = " + task.getTaskId());
            }
            LOGGER.info("Admin đã cập nhật taskId: " + task.getTaskId());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật task bởi admin: " + e.getMessage(), e);
            throw new SQLException("Lỗi khi cập nhật task bởi admin: " + e.getMessage(), e);
        }
    }

    public boolean adminBoostTask(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho adminBoostTask.");
            dbContext = new DBContext();
        }
        String sql = "SELECT COUNT(*) FROM tasks WHERE task_id = ?";
        try {
            boolean exists = dbContext.queryExists(sql, taskId);
            if (exists) {
                String updateSql = "UPDATE tasks SET is_boosted = ?, boost_expiry = ? WHERE task_id = ?";
                Connection conn = dbContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(updateSql);
                stmt.setBoolean(1, true);
                LocalDateTime expiryTime = LocalDateTime.now().plusDays(7);
                stmt.setTimestamp(2, Timestamp.valueOf(expiryTime));
                stmt.setInt(3, taskId);
                int rowsAffected = stmt.executeUpdate();
                stmt.close();

                if (rowsAffected > 0) {
                    boostManager.boostTask(taskId);
                    String logSql = "INSERT INTO system_logs (user_id, email, action, target, description, timestamp) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement logStmt = conn.prepareStatement(logSql);
                    logStmt.setInt(1, 0); // Admin không có user_id cụ thể
                    logStmt.setString(2, "admin");
                    logStmt.setString(3, "BOOST");
                    logStmt.setString(4, "TASK #" + taskId);
                    logStmt.setString(5, "Admin đã boost task ID: " + taskId);
                    logStmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
                    logStmt.executeUpdate();
                    logStmt.close();

                    LOGGER.info("Admin boosted task successfully for taskId: " + taskId);
                    return true;
                } else {
                    LOGGER.warning("Không thể cập nhật trạng thái boost cho task " + taskId);
                    return false;
                }
            } else {
                LOGGER.warning("Admin boost failed: Task " + taskId + " does not exist");
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error boosting task by admin", e);
            throw e;
        }
    }

    public boolean adminUnboostTask(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho adminUnboostTask.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE tasks SET is_boosted = ?, boost_expiry = ?, boosted_at = NULL WHERE task_id = ?";
        PreparedStatement ps = null;

        try {
            ps = dbContext.getConnection().prepareStatement(sql);
            ps.setBoolean(1, false);
            ps.setNull(2, java.sql.Types.TIMESTAMP);
            ps.setInt(3, taskId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                boostManager.removeBoost(taskId);
                String logSql = "INSERT INTO system_logs (user_id, email, action, target, description, timestamp) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement logStmt = dbContext.getConnection().prepareStatement(logSql);
                logStmt.setInt(1, 0); // Admin không có user_id cụ thể
                logStmt.setString(2, "admin");
                logStmt.setString(3, "UNBOOST");
                logStmt.setString(4, "TASK #" + taskId);
                logStmt.setString(5, "Admin đã hủy boost task ID: " + taskId);
                logStmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
                logStmt.executeUpdate();
                logStmt.close();

                LOGGER.info("Admin unboosted task successfully for taskId: " + taskId);
                return true;
            } else {
                LOGGER.warning("Admin unboost failed: Task " + taskId + " not found or not boosted");
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unboosting task by admin", e);
            throw e;
        } finally {
            dbContext.closeResources(ps, null);
        }
    }

    public void hideTask(int taskId, int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho hideTask.");
            dbContext = new DBContext();
        }
        try (Connection conn = dbContext.getConnection()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu");
            }
            conn.setAutoCommit(false);
            int rowsAffected = dbContext.executeUpdate(
                    "UPDATE tasks SET is_hidden = ?, is_boosted = ?, boost_expiry = ? WHERE task_id = ? AND user_id = ?",
                    1, false, null, taskId, userId);
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task hoặc bạn không có quyền ẩn");
            }
            boostManager.removeBoost(taskId);
            conn.commit();
            LOGGER.info("Đã ẩn taskId: " + taskId);
        } catch (SQLException e) {
            if (dbContext.getConnection() != null) {
                dbContext.getConnection().rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi ẩn task: " + e.getMessage(), e);
            throw e;
        }
    }

    public void unhideTask(int taskId, int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho unhideTask.");
            dbContext = new DBContext();
        }
        try (Connection conn = dbContext.getConnection()) {
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu");
            }
            conn.setAutoCommit(false);
            int rowsAffected = dbContext.executeUpdate("UPDATE tasks SET is_hidden = 0 WHERE task_id = ? AND user_id = ?", taskId, userId);
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task hoặc bạn không có quyền hủy ẩn");
            }
            conn.commit();
            LOGGER.info("Đã hủy ẩn taskId: " + taskId);
        } catch (SQLException e) {
            if (dbContext.getConnection() != null) {
                dbContext.getConnection().rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi hủy ẩn task: " + e.getMessage(), e);
            throw e;
        }
    }

    public void deleteTask(int taskId, int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            String deleteAppsSql = "DELETE FROM task_applications WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteAppsSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa các ứng tuyển liên quan cho taskId: " + taskId);

            String deleteTaskSql = "DELETE FROM tasks WHERE task_id = ? AND user_id = ?";
            stmt = conn.prepareStatement(deleteTaskSql);
            stmt.setInt(1, taskId);
            stmt.setInt(2, userId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task hoặc bạn không có quyền xóa");
            }
            boostManager.removeBoost(taskId);
            conn.commit();
            LOGGER.info("Đã xóa taskId: " + taskId);
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa task: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, null);
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public void deleteTaskByAdmin(int taskId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            String deleteMessagesSql = "DELETE FROM messages WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteMessagesSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa messages cho taskId: " + taskId);

            String deleteReviewsSql = "DELETE FROM reviews WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteReviewsSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa reviews cho taskId: " + taskId);

            String deleteAssignmentsSql = "DELETE FROM task_assignments WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteAssignmentsSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa task_assignments cho taskId: " + taskId);

            String deleteAppsSql = "DELETE FROM task_applications WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteAppsSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa applications cho taskId: " + taskId);

            String deletePaymentsSql = "DELETE FROM payments WHERE task_id = ?";
            stmt = conn.prepareStatement(deletePaymentsSql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();
            LOGGER.info("Đã xóa payments cho taskId: " + taskId);

            String deleteTaskSql = "DELETE FROM tasks WHERE task_id = ?";
            stmt = conn.prepareStatement(deleteTaskSql);
            stmt.setInt(1, taskId);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected == 0) {
                throw new SQLException("Task không tồn tại hoặc đã bị xóa");
            }

            boostManager.removeBoost(taskId);
            conn.commit();
            LOGGER.info("Admin đã xóa taskId: " + taskId);
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi admin xóa task: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, null);
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public List<Task> getAllTasksByAdmin() throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getAllTasksByAdmin.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.user_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, t.created_at, t.is_boosted, t.boost_expiry " +
                "FROM tasks t " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id ";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setUserId(rs.getInt("user_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setCreatedAt(rs.getTimestamp("created_at"));
                task.setBoosted(rs.getBoolean("is_boosted"));
                task.setBoostExpiry(rs.getTimestamp("boost_expiry"));
                task.setBoostedAt(boostManager.getBoostedAt(task.getTaskId()));
                tasks.add(task);
            }

            tasks.sort(Comparator.comparing(Task::isBoosted, Comparator.reverseOrder())
                    .thenComparing((Task t) -> t.getBoostedAt() != null ? t.getBoostedAt() : new Timestamp(0), Comparator.reverseOrder())
                    .thenComparing(Task::getCreatedAt, Comparator.reverseOrder()));

            LOGGER.info("Admin retrieved " + tasks.size() + " tasks");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all tasks for admin", e);
            throw new SQLException("Database error while retrieving all tasks for admin", e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public List<Task> getAppliedTasks(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getAppliedTasks.");
            dbContext = new DBContext();
        }
        String sql = "SELECT t.task_id, t.title, t.description, t.location, t.scheduled_time, " +
                "t.budget, t.status, u.full_name AS client_name, c.name AS category_name, " +
                "ta.application_id, ta.applied_at, ta.status AS application_status, ta.message AS application_message " +
                "FROM task_applications ta " +
                "JOIN tasks t ON ta.task_id = t.task_id " +
                "LEFT JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE ta.worker_id = ? " +
                "ORDER BY ta.applied_at DESC";

        List<Task> tasks = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, userId);
            while (rs != null && rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setLocation(rs.getString("location"));
                task.setScheduledTime(rs.getTimestamp("scheduled_time"));
                task.setBudget(rs.getDouble("budget"));
                task.setStatus(rs.getString("status"));
                task.setClientName(rs.getString("client_name"));
                task.setCategoryName(rs.getString("category_name"));
                task.setApplicationId(rs.getInt("application_id"));
                task.setAppliedAt(rs.getTimestamp("applied_at"));
                task.setApplicationStatus(rs.getString("application_status"));
                task.setApplicationMessage(rs.getString("application_message"));
                tasks.add(task);
            }
            LOGGER.info("Retrieved " + tasks.size() + " applied tasks for user " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting applied tasks", e);
            throw new SQLException("Database error while retrieving applied tasks", e);
        } finally {
            dbContext.closeResources(null, rs);
        }

        return tasks;
    }

    public boolean applyForTask(int taskId, int workerId, String message) {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho applyForTask.");
            dbContext = new DBContext();
        }
        String sql = "INSERT INTO task_applications (task_id, worker_id, message) VALUES (?, ?, ?)";

        try {
            int result = dbContext.executeUpdate(sql, taskId, workerId, message);
            boolean success = result > 0;
            LOGGER.info("Task application " + (success ? "successful" : "failed")
                    + " - Task ID: " + taskId + ", Worker ID: " + workerId);
            return success;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error applying for task", e);
            return false;
        }
    }

    public boolean hasApplied(int taskId, int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho hasApplied.");
            dbContext = new DBContext();
        }
        String sql = "SELECT COUNT(*) FROM task_applications WHERE task_id = ? AND worker_id = ? AND status != 'cancelled'";
        LOGGER.info("Checking if user " + workerId + " has applied for task " + taskId);

        try {
            boolean exists = dbContext.queryExists(sql, taskId, workerId);
            LOGGER.info("Application check result: " + exists);
            return exists;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking application status for task " + taskId + " and worker " + workerId, e);
            throw e;
        }
    }

    public boolean cancelApplication(int applicationId, int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho cancelApplication.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE task_applications SET status = 'cancelled' WHERE application_id = ? AND worker_id = ? AND status = 'pending'";
        LOGGER.info("Attempting to cancel application ID: " + applicationId + " for worker ID: " + workerId);

        int rowsAffected = dbContext.executeUpdate(sql, applicationId, workerId);
        boolean success = rowsAffected > 0;
        if (success) {
            LOGGER.info("Application cancellation successful for application ID: " + applicationId);
        } else {
            LOGGER.warning("No pending application found to cancel for application ID: " + applicationId);
        }
        return success;
    }

    public void updateTaskTitle(int taskId, String newTitle, int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho updateTaskTitle.");
            dbContext = new DBContext();
        }
        try {
            int rowsAffected = dbContext.executeUpdate(
                    "UPDATE tasks SET title = ? WHERE task_id = ? AND user_id = ?",
                    newTitle, taskId, userId);
            if (rowsAffected == 0) {
                throw new SQLException("Không tìm thấy task hoặc bạn không có quyền chỉnh sửa");
            }
            LOGGER.info("Đã cập nhật title cho taskId: " + taskId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật title cho task ID " + taskId + ": " + e.getMessage(), e);
            throw new SQLException("Lỗi khi cập nhật title: " + e.getMessage(), e);
        }
    }

    public int getTotalTasksByUserId(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            dbContext = new DBContext();
        }

        String sql = "SELECT COUNT(*) as total FROM tasks WHERE user_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    public int getHiddenTasksCountByUserId(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            dbContext = new DBContext();
        }

        String sql = "SELECT COUNT(*) as total FROM tasks WHERE user_id = ? AND is_hidden = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    public boolean acceptApplication(int applicationId, int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho acceptApplication.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE task_applications SET status = 'accepted' WHERE application_id = ? AND task_id = ? AND status = 'pending'";
        LOGGER.info("Attempting to accept application ID: " + applicationId + " for task ID: " + taskId);

        int rowsAffected = dbContext.executeUpdate(sql, applicationId, taskId);
        if (rowsAffected > 0) {
            String updateTaskSql = "UPDATE tasks SET status = 'IN_PROGRESS' WHERE task_id = ?";
            dbContext.executeUpdate(updateTaskSql, taskId);

            String getWorkerSql = "SELECT worker_id FROM task_applications WHERE application_id = ?";
            ResultSet rs = null;
            int workerId = -1;
            try {
                rs = dbContext.getData(getWorkerSql, applicationId);
                if (rs.next()) {
                    workerId = rs.getInt("worker_id");
                }
            } finally {
                dbContext.closeResources(null, rs);
            }

            if (workerId != -1) {
                String insertNotificationSql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, ?)";
                java.sql.Timestamp currentTimestamp = new java.sql.Timestamp(System.currentTimeMillis());
                dbContext.executeUpdate(insertNotificationSql, workerId, "Công việc của bạn đã được chấp thuận!", currentTimestamp);
            }

            String assignSql = "INSERT INTO task_assignments (task_id, worker_id, assigned_at) " +
                    "SELECT task_id, worker_id, ? FROM task_applications WHERE application_id = ?";
            dbContext.executeUpdate(assignSql, new java.sql.Timestamp(System.currentTimeMillis()), applicationId);
            LOGGER.info("Application " + applicationId + " accepted and assigned");
            return true;
        }
        LOGGER.warning("No pending application found to accept for application ID: " + applicationId);
        return false;
    }

    public boolean rejectApplication(int applicationId, int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho rejectApplication.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE task_applications SET status = 'rejected' WHERE application_id = ? AND task_id = ? AND status = 'pending'";
        LOGGER.info("Attempting to reject application ID: " + applicationId + " for task ID: " + taskId);

        int rowsAffected = dbContext.executeUpdate(sql, applicationId, taskId);
        if (rowsAffected > 0) {
            String getWorkerSql = "SELECT worker_id FROM task_applications WHERE application_id = ?";
            ResultSet rs = null;
            int workerId = -1;
            try {
                rs = dbContext.getData(getWorkerSql, applicationId);
                if (rs.next()) {
                    workerId = rs.getInt("worker_id");
                }
            } finally {
                dbContext.closeResources(null, rs);
            }

            if (workerId != -1) {
                Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
                dbContext.executeUpdate("INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, ?)",
                        workerId, "Ứng tuyển của bạn đã bị từ chối!", currentTimestamp);
            }

            LOGGER.info("Application " + applicationId + " rejected");
            return true;
        }
        LOGGER.warning("No pending application found to reject for application ID: " + applicationId);
        return false;
    }

    public List<TaskApplication> getApplicationsByTaskId(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getApplicationsByTaskId.");
            dbContext = new DBContext();
        }
        String sql = "SELECT ta.application_id, ta.task_id, ta.worker_id, ta.message, ta.applied_at, ta.status, u.full_name, u.email, u.phone " +
                "FROM task_applications ta " +
                "JOIN users u ON ta.worker_id = u.user_id " +
                "WHERE ta.task_id = ? AND ta.status IN ('pending', 'accepted', 'rejected') " +
                "ORDER BY ta.applied_at DESC";
        List<TaskApplication> applications = new ArrayList<>();
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, taskId);
            while (rs != null && rs.next()) {
                TaskApplication app = new TaskApplication();
                app.setApplicationId(rs.getInt("application_id"));
                app.setTaskId(rs.getInt("task_id"));
                app.setWorkerId(rs.getInt("worker_id"));
                app.setMessage(rs.getString("message"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setStatus(rs.getString("status"));
                app.setWorkerName(rs.getString("full_name"));
                app.setWorkerEmail(rs.getString("email"));
                app.setWorkerPhone(rs.getString("phone"));
                applications.add(app);
            }
            LOGGER.info("Retrieved " + applications.size() + " applications for task ID: " + taskId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting applications for task " + taskId + ": " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }
        return applications;
    }

    public boolean deleteApplication(int applicationId, int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho deleteApplication.");
            dbContext = new DBContext();
        }
        String sql = "DELETE FROM task_applications WHERE application_id = ? AND worker_id = ?";
        LOGGER.info("Attempting to delete application ID: " + applicationId + " for worker ID: " + workerId);

        int rowsAffected = dbContext.executeUpdate(sql, applicationId, workerId);
        boolean success = rowsAffected > 0;
        if (success) {
            LOGGER.info("Application deletion successful for application ID: " + applicationId);
        } else {
            LOGGER.warning("No application found to delete for application ID: " + applicationId);
        }
        return success;
    }

    public boolean bookmarkTask(int userId, int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho bookmarkTask.");
            dbContext = new DBContext();
        }

        String checkSql = "SELECT COUNT(*) FROM user_task_bookmarks WHERE user_id = ? AND task_id = ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(checkSql, userId, taskId);
            if (rs != null && rs.next() && rs.getInt(1) > 0) {
                LOGGER.info("Task " + taskId + " đã được bookmark bởi user " + userId);
                return false;
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi khi kiểm tra bookmark: " + e.getMessage());
            throw e;
        } finally {
            if (rs != null) rs.close();
        }

        String sql = "INSERT INTO user_task_bookmarks (user_id, task_id, created_at) VALUES (?, ?, ?)";
        java.sql.Timestamp currentTimestamp = new java.sql.Timestamp(System.currentTimeMillis());

        int rowsAffected = dbContext.executeUpdate(sql, userId, taskId, currentTimestamp);
        boolean success = rowsAffected > 0;
        if (success) {
            LOGGER.info("Bookmark task thành công cho userId: " + userId + ", taskId: " + taskId);
        } else {
            LOGGER.warning("Bookmark task thất bại cho userId: " + userId + ", taskId: " + taskId);
        }
        return success;
    }

    public boolean unbookmarkTask(int userId, int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho unbookmarkTask.");
            dbContext = new DBContext();
        }
        String sql = "DELETE FROM user_task_bookmarks WHERE user_id = ? AND task_id = ?";

        int rowsAffected = dbContext.executeUpdate(sql, userId, taskId);
        boolean success = rowsAffected > 0;
        if (success) {
            LOGGER.info("Unbookmark task thành công cho userId: " + userId + ", taskId: " + taskId);
        } else {
            LOGGER.warning("Unbookmark task thất bại, không tìm thấy bookmark cho userId: " + userId + ", taskId: " + taskId);
        }
        return success;
    }

    public List<Integer> getBookmarkedTaskIds(int userId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getBookmarkedTaskIds.");
            dbContext = new DBContext();
        }
        List<Integer> taskIds = new ArrayList<>();
        String sql = "SELECT task_id FROM user_task_bookmarks WHERE user_id = ?";

        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, userId);
            while (rs != null && rs.next()) {
                taskIds.add(rs.getInt("task_id"));
            }
            LOGGER.info("Lấy được " + taskIds.size() + " task IDs đã bookmark cho userId: " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy bookmarked task IDs cho userId: " + userId, e);
            throw e;
        } finally {
            if (rs != null) rs.close();
        }
        return taskIds;
    }

    public boolean confirmTaskCompletionByWorker(int taskId, int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho confirmTaskCompletionByWorker.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE tasks SET status = 'COMPLETED_BY_WORKER' WHERE task_id = ? AND status = 'IN_PROGRESS'";
        int rowsAffected = dbContext.executeUpdate(sql, taskId);
        if (rowsAffected > 0) {
            String posterSql = "SELECT user_id FROM tasks WHERE task_id = ?";
            ResultSet rs = dbContext.getData(posterSql, taskId);
            if (rs.next()) {
                int posterId = rs.getInt("user_id");
                String notificationSql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, ?)";
                Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
                dbContext.executeUpdate(notificationSql, posterId, "Công việc " + taskId + " đã được worker xác nhận hoàn thành. Vui lòng xác nhận để thanh toán.", currentTimestamp);
            }
            dbContext.closeResources(null, rs);
            return true;
        }
        return false;
    }

    public boolean updateTaskStatus(int taskId, String newStatus) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho updateTaskStatus.");
            dbContext = new DBContext();
        }
        String sql = "UPDATE tasks SET status = ? WHERE task_id = ?";
        int rowsAffected = dbContext.executeUpdate(sql, newStatus, taskId);
        if (rowsAffected > 0) {
            LOGGER.info("Cập nhật trạng thái thành công cho task ID: " + taskId + " thành: " + newStatus);
            return true;
        }
        LOGGER.warning("Không thể cập nhật trạng thái cho task ID: " + taskId);
        return false;
    }

    public void recordPayment(int taskId, double amount, Timestamp paymentTime) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho recordPayment.");
            dbContext = new DBContext();
        }

        String sql = "INSERT INTO payments (task_id, amount, payment_date, status) VALUES (?, ?, ?, 'COMPLETED')";
        int rowsAffected = dbContext.executeUpdate(sql, taskId, amount, paymentTime);

        if (rowsAffected > 0) {
            LOGGER.info("Payment recorded successfully for task " + taskId + " amount: " + amount);
        } else {
            throw new SQLException("Failed to record payment for task " + taskId);
        }
    }

    public void sendNotification(int userId, String message, Timestamp timestamp) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho sendNotification.");
            dbContext = new DBContext();
        }

        String sql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, ?)";
        int rowsAffected = dbContext.executeUpdate(sql, userId, message, timestamp);

        if (rowsAffected > 0) {
            LOGGER.info("Notification sent to user " + userId + ": " + message);
        } else {
            LOGGER.warning("Failed to send notification to user " + userId);
        }
    }

    public int getWorkerIdFromTaskAssignment(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getWorkerIdFromTaskAssignment.");
            dbContext = new DBContext();
        }

        String sql = "SELECT worker_id FROM task_assignments WHERE task_id = ?";
        ResultSet rs = null;
        int workerId = -1;

        try {
            rs = dbContext.getData(sql, taskId);
            if (rs != null && rs.next()) {
                workerId = rs.getInt("worker_id");
            }
        } finally {
            dbContext.closeResources(null, rs);
        }

        return workerId;
    }

    public boolean isTaskOwnedByPoster(int taskId, int posterId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho isTaskOwnedByPoster.");
            dbContext = new DBContext();
        }

        String sql = "SELECT COUNT(*) as count FROM tasks WHERE task_id = ? AND user_id = ?";
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, taskId, posterId);
            if (rs != null && rs.next()) {
                return rs.getInt("count") > 0;
            }
        } finally {
            dbContext.closeResources(null, rs);
        }

        return false;
    }

    public boolean isWorkerAssignedToTask(int taskId, int workerId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho isWorkerAssignedToTask.");
            dbContext = new DBContext();
        }

        String sql = "SELECT COUNT(*) as count FROM task_assignments WHERE task_id = ? AND worker_id = ?";
        ResultSet rs = null;

        try {
            rs = dbContext.getData(sql, taskId, workerId);
            if (rs != null && rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking worker assignment for task " + taskId + " and worker " + workerId, e);
            throw e;
        } finally {
            dbContext.closeResources(null, rs);
        }

        return false;
    }

    public int getApplicationCount(int taskId) throws SQLException {
        if (!dbContext.isConnected()) {
            LOGGER.warning("Kết nối đã bị đóng, tái tạo DBContext cho getApplicationCount.");
            dbContext = new DBContext();
        }
        String sql = "SELECT COUNT(*) FROM task_applications WHERE task_id = ?";
        ResultSet rs = null;
        try {
            rs = dbContext.getData(sql, taskId);
            if (rs != null && rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy số lượng ứng tuyển cho taskId: " + taskId, e);
            throw e;
        } finally {
            if (rs != null) rs.close();
        }
        return 0;
    }
}