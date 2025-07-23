package controller;

import dao.TaskDAO;
import dao.UserDAO;
import dao.DBContext;
import dao.LogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Task;
import model.User;
import model.SystemLog;

public class AdminBoostTaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private UserDAO userDAO;
    private DBContext dbContext;
    private LogDAO logDAO;
    private static final Logger LOGGER = Logger.getLogger(AdminBoostTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            userDAO = new UserDAO();
            dbContext = new DBContext();
            logDAO = new LogDAO();
            LOGGER.info("AdminBoostTaskServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminBoostTaskServlet", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("AdminBoostTaskServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equals(loggedInUser.getRole())) {
            LOGGER.warning("Non-admin user " + loggedInUser.getUserId() + " attempted to access admin page");
            response.sendRedirect(request.getContextPath() + "/boostTask");
            return;
        }

        loadAdminTasksPage(request, response, loggedInUser);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("AdminBoostTaskServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equals(loggedInUser.getRole())) {
            LOGGER.warning("Non-admin user " + loggedInUser.getUserId() + " attempted to access admin action");
            response.sendRedirect(request.getContextPath() + "/boostTask");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String action = request.getParameter("action");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            LOGGER.warning("AdminBoostTaskServlet: Task ID is required");
            request.setAttribute("error", "Yêu cầu Task ID.");
            loadAdminTasksPage(request, response, loggedInUser);
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("AdminBoostTaskServlet: Invalid Task ID format: " + taskIdStr);
            request.setAttribute("error", "Định dạng Task ID không hợp lệ.");
            loadAdminTasksPage(request, response, loggedInUser);
            return;
        }

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Kiểm tra task tồn tại
            Task task = taskDAO.getTaskById(taskId);
            if (task == null) {
                LOGGER.warning("Task " + taskId + " does not exist");
                request.setAttribute("error", "Công việc không tồn tại.");
                loadAdminTasksPage(request, response, loggedInUser);
                return;
            }

            boolean success = false;
            String actionType = "";
            if ("boost".equalsIgnoreCase(action)) {
                if (task.isBoosted()) {
                    LOGGER.warning("Task " + taskId + " is already boosted");
                    request.setAttribute("error", "Công việc này đã được boost.");
                    loadAdminTasksPage(request, response, loggedInUser);
                    return;
                }
                success = taskDAO.adminBoostTask(taskId);
                actionType = "BOOST_TASK";
                if (success) {
                    request.setAttribute("success", "Công việc ID " + taskId + " đã được đẩy lên đầu!");
                } else {
                    request.setAttribute("error", "Không thể boost công việc.");
                }
            } else if ("unboost".equalsIgnoreCase(action)) {
                if (!task.isBoosted()) {
                    LOGGER.warning("Task " + taskId + " is not boosted");
                    request.setAttribute("error", "Công việc này chưa được boost.");
                    loadAdminTasksPage(request, response, loggedInUser);
                    return;
                }
                success = taskDAO.adminUnboostTask(taskId);
                actionType = "UNBOOST_TASK";
                if (success) {
                    request.setAttribute("success", "Công việc ID " + taskId + " đã được hủy ưu tiên!");
                } else {
                    request.setAttribute("error", "Không thể hủy ưu tiên công việc.");
                }
            } else {
                LOGGER.warning("AdminBoostTaskServlet: Invalid action: " + action);
                request.setAttribute("error", "Hành động không hợp lệ.");
                loadAdminTasksPage(request, response, loggedInUser);
                return;
            }

            if (success) {
                logBoostAction(loggedInUser, taskId, actionType);
                conn.commit(); // Commit giao dịch
                LOGGER.info("Admin " + loggedInUser.getUserId() + " performed " + actionType + " on task " + taskId);
            } else {
                conn.rollback(); // Rollback nếu thất bại
                LOGGER.warning("Admin failed to perform " + actionType + " on task " + taskId);
            }

            loadAdminTasksPage(request, response, loggedInUser);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while processing task " + taskId + " with action " + action, e);
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback nếu có lỗi
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error during rollback", ex);
            }
            request.setAttribute("error", "Lỗi cơ sở dữ liệu. Vui lòng thử lại.");
            loadAdminTasksPage(request, response, loggedInUser);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    private void loadAdminTasksPage(HttpServletRequest request, HttpServletResponse response, User loggedInUser) 
            throws ServletException, IOException {
        try {
            List<Task> tasks = taskDAO.getAllTasksByAdmin();
            request.setAttribute("userName", loggedInUser.getFullName());
            request.setAttribute("tasks", tasks);
            request.getRequestDispatcher("/admin-boost-task.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all tasks for admin", e);
            request.setAttribute("error", "Không thể tải danh sách công việc. Vui lòng thử lại.");
            request.getRequestDispatcher("/admin-boost-task.jsp").forward(request, response);
        }
    }

    private void logBoostAction(User admin, int taskId, String actionType) {
        SystemLog log = new SystemLog();
        log.setUserId(admin.getUserId());
        log.setEmail(admin.getEmail());
        log.setAction(actionType);
        log.setTarget("Task ID: " + taskId);
        log.setDescription(actionType.equals("BOOST_TASK") ? "Admin boosted task manually" : "Admin unboosted task manually");
        log.setTimestamp(new Timestamp(System.currentTimeMillis()));

        try {
            logDAO.insertLog(log);
            LOGGER.info("Log recorded for admin " + admin.getUserId() + " " + actionType.toLowerCase() + " task " + taskId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to record " + actionType + " log for admin " + admin.getUserId() + " and task " + taskId, e);
        }
    }

    @Override
    public void destroy() {
        taskDAO = null;
        userDAO = null;
        dbContext = null;
        logDAO = null;
        super.destroy();
    }
}