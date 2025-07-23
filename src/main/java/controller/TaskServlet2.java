package controller;

import dao.TaskDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TaskServlet2 extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TaskServlet2.class.getName());
    private TaskDAO taskDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            userDAO = new UserDAO();
        } catch (Exception e) {
            throw new ServletException("Không thể khởi tạo TaskServlet2", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("TaskServlet2 - Không tìm thấy user hoặc userId trong session, chuyển hướng đến login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if (action == null) {
            action = "compare";
        }

        switch (action) {
            case "compare":
                showComparisonTasks(request, response, userId);
                break;
            default:
                showComparisonTasks(request, response, userId);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            out.write("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
            out.flush();
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String jsonResponse;

        try {
            switch (action) {
                case "addToComparison":
                    jsonResponse = handleAddToComparison(request, userId);
                    break;
                case "removeFromComparison":
                    jsonResponse = handleRemoveFromComparison(request, userId);
                    break;
                default:
                    jsonResponse = "{\"success\": false, \"message\": \"Hành động không được hỗ trợ\"}";
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi trong doPost: " + e.getMessage(), e);
            // Thoát ký tự đặc biệt trong message
            String escapedMessage = e.getMessage().replace("\"", "\\\"").replace("\n", "\\n");
            jsonResponse = "{\"success\": false, \"message\": \"Lỗi: " + escapedMessage + "\"}";
        }

        out.write(jsonResponse);
        out.flush();
        out.close();
    }

    private void showComparisonTasks(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                LOGGER.warning("Không tìm thấy người dùng với userId: " + userId);
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            request.setAttribute("userName", user.getFullName());
            request.setAttribute("userBalance", user.getBalance());

            // Lấy danh sách công việc đã bookmark để so sánh
            List<Task> tasksToCompare = taskDAO.getBookmarkedTasks(userId);
            // Thêm số lượng ứng tuyển cho mỗi công việc
            for (Task task : tasksToCompare) {
                task.setApplicationCount(taskDAO.getApplicationCount(task.getTaskId()));
            }
            request.setAttribute("tasksToCompare", tasksToCompare);
            request.setAttribute("pageTitle", "So sánh công việc");
            request.getRequestDispatcher("/comparisonTasks.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tải danh sách công việc để so sánh", e);
            request.setAttribute("error", "Không thể tải danh sách công việc để so sánh. Vui lòng thử lại.");
            request.getRequestDispatcher("/comparisonTasks.jsp").forward(request, response);
        }
    }

    private String handleAddToComparison(HttpServletRequest request, int userId) throws SQLException {
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            return "{\"success\": false, \"message\": \"Task ID là bắt buộc.\"}";
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            LOGGER.info("Đang thêm task vào danh sách so sánh - userId: " + userId + ", taskId: " + taskId);

            // Giới hạn số lượng công việc so sánh (tối đa 5)
            List<Task> tasks = taskDAO.getBookmarkedTasks(userId);
            if (tasks.size() >= 5) {
                return "{\"success\": false, \"message\": \"Danh sách so sánh đã đạt giới hạn 5 công việc.\"}";
            }

            boolean success = taskDAO.bookmarkTask(userId, taskId);
            String message = success ?
                    "Đã thêm công việc vào danh sách so sánh!" :
                    "Không thể thêm công việc. Công việc có thể đã được chọn.";
            // Thoát ký tự đặc biệt trong message
            String escapedMessage = message.replace("\"", "\\\"").replace("\n", "\\n");

            LOGGER.info("Kết quả thêm: " + success + ", message: " + message);
            return "{\"success\": " + success + ", \"message\": \"" + escapedMessage + "\"}";
        } catch (NumberFormatException e) {
            LOGGER.warning("Task ID không hợp lệ: " + taskIdStr);
            return "{\"success\": false, \"message\": \"Task ID không hợp lệ.\"}";
        }
    }

    private String handleRemoveFromComparison(HttpServletRequest request, int userId) throws SQLException {
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            return "{\"success\": false, \"message\": \"Task ID là bắt buộc.\"}";
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            LOGGER.info("Đang xóa task khỏi danh sách so sánh - userId: " + userId + ", taskId: " + taskId);

            boolean success = taskDAO.unbookmarkTask(userId, taskId);
            String message = success ?
                    "Đã xóa công việc khỏi danh sách so sánh!" :
                    "Không thể xóa công việc. Công việc có thể chưa được chọn.";
            // Thoát ký tự đặc biệt trong message
            String escapedMessage = message.replace("\"", "\\\"").replace("\n", "\\n");

            LOGGER.info("Kết quả xóa: " + success + ", message: " + message);
            return "{\"success\": " + success + ", \"message\": \"" + escapedMessage + "\"}";
        } catch (NumberFormatException e) {
            LOGGER.warning("Task ID không hợp lệ: " + taskIdStr);
            return "{\"success\": false, \"message\": \"Task ID không hợp lệ.\"}";
        }
    }
}