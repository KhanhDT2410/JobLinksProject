package controller;

import dao.TaskDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.stream.Collectors;
import model.Category;
import model.Task;
import model.TaskApplication;
import model.User;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TaskServlet.class.getName());
    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("TaskServlet - Không tìm thấy user hoặc userId trong session, chuyển hướng đến login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                showAvailableTasks(request, response, userId);
                break;
            case "applied":
                showAppliedTasks(request, response, userId);
                break;
            case "details":
                showTaskDetails(request, response, userId);
                break;
            case "accepted":
                showAcceptedTasks(request, response, userId);
                break;
            default:
                showAvailableTasks(request, response, userId);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String jsonResponse = "{\"success\": false, \"message\": \"Hành động không được hỗ trợ\"}";

        response.setContentType("application/json;charset=UTF-8");
        
        try {
            switch (action) {
                case "apply":
                    handleTaskApplication(request, response, userId);
                    return;
                case "cancel":
                    handleTaskCancellation(request, response, userId);
                    return;
                case "delete":
                    handleTaskDeletion(request, response, userId);
                    return;
                case "accept":
                    handleAcceptApplication(request, response, userId);
                    return;
                case "reject":
                    handleRejectApplication(request, response, userId);
                    return;
                case "bookmark":
                    jsonResponse = handleBookmarkTask(request, userId);
                    break;
                case "unbookmark":
                    jsonResponse = handleUnbookmarkTask(request, userId);
                    break;
                case "complete":
                    handleTaskCompletion(request, response, userId);
                    return;
                default:
                    jsonResponse = "{\"success\": false, \"message\": \"Hành động không được hỗ trợ\"}";
            }
        } catch (Exception e) {
            jsonResponse = "{\"success\": false, \"message\": \"Lỗi: " + e.getMessage().replace("\"", "'") + "\"}";
        }
        
        response.getWriter().write(jsonResponse);
    }

private void showAvailableTasks(HttpServletRequest request, HttpServletResponse response, int userId) 
        throws ServletException, IOException {
    try {
        String searchKeyword = request.getParameter("searchKeyword");
        String location = request.getParameter("location");
        Double budgetMin = null;
        Double budgetMax = null;
        Integer categoryId = null;

        // Lấy và xử lý budgetMin, budgetMax
        try {
            String budgetMinStr = request.getParameter("budgetMin");
            String budgetMaxStr = request.getParameter("budgetMax");
            if (budgetMinStr != null && !budgetMinStr.isEmpty()) {
                budgetMin = Double.parseDouble(budgetMinStr);
            }
            if (budgetMaxStr != null && !budgetMaxStr.isEmpty()) {
                budgetMax = Double.parseDouble(budgetMaxStr);
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid budget format", e);
        }

        // Lấy và xử lý categoryId
        try {
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr);
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid categoryId format", e);
        }

        // Lấy danh sách công việc
        List<Task> availableTasks = taskDAO.getRecommendedTasksWithFilters(searchKeyword, location, budgetMin, budgetMax, categoryId);

        // Lấy danh sách danh mục
        List<Category> categories = taskDAO.getAllCategories();

        // Lấy danh sách task đã bookmark
        List<Task> bookmarkedTasks = taskDAO.getBookmarkedTasks(userId);
        Set<Integer> bookmarkedTaskIds = bookmarkedTasks.stream()
                .map(Task::getTaskId)
                .collect(Collectors.toSet());

        // Đặt các thuộc tính vào request
        request.setAttribute("tasks", availableTasks);
        request.setAttribute("categories", categories);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("location", location);
        request.setAttribute("budgetMin", budgetMin);
        request.setAttribute("budgetMax", budgetMax);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("bookmarkedTaskIds", bookmarkedTaskIds); // Thêm bookmarkedTaskIds
        request.setAttribute("currentPage", "available");
        request.setAttribute("pageTitle", "Danh Sách Công Việc");

        LOGGER.info("Retrieved " + availableTasks.size() + " available tasks and " + bookmarkedTaskIds.size() + " bookmarked tasks for userId: " + userId);
        request.getRequestDispatcher("/availableTasks.jsp").forward(request, response);
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error retrieving available tasks", e);
        request.setAttribute("error", "Không thể tải danh sách công việc. Vui lòng thử lại.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}

    private void showAppliedTasks(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            List<Task> appliedTasks = taskDAO.getAppliedTasks(userId);
            List<Task> postedTasks = taskDAO.getTasksByUserId(userId);
            List<Task> bookmarkedTasks = taskDAO.getBookmarkedTasks(userId);
            request.setAttribute("tasks", appliedTasks);
            request.setAttribute("postedTasks", postedTasks);
            request.setAttribute("bookmarkedTasks", bookmarkedTasks);
            request.setAttribute("pageTitle", "My Applications");
            request.setAttribute("currentPage", "applied");
            request.getRequestDispatcher("/myApplications.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Unable to load applied tasks. Please try again.");
            request.getRequestDispatcher("/myApplications.jsp").forward(request, response);
        }
    }

private void showTaskDetails(HttpServletRequest request, HttpServletResponse response, int userId) 
        throws ServletException, IOException {
    // Vô hiệu hóa cache
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    try {
        // Thử lấy taskId từ parameter trước, sau đó từ attribute
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            taskIdStr = (String) request.getAttribute("taskId"); // Lấy từ attribute nếu parameter không có
        }
        
        LOGGER.info("Nhận taskId: " + taskIdStr);
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            LOGGER.warning("taskId không hợp lệ hoặc rỗng");
            request.setAttribute("error", "Yêu cầu phải có Task ID.");
            request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);
            return;
        }

        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskDAO.getTaskById(taskId);
        LOGGER.info("Task lấy được: " + (task != null ? task.getTitle() : "null"));
        
        if (task == null) {
            request.setAttribute("error", "Không tìm thấy task với ID: " + taskId);
            request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);
            return;
        }

        boolean hasApplied = taskDAO.hasApplied(taskId, userId);
        List<TaskApplication> applications = null;
        if (task.getUserId() == userId) {
            applications = taskDAO.getApplicationsByTaskId(taskId);
        }

        // Lấy danh sách công việc được đề xuất
        String searchKeyword = null;
        String location = null;
        Double budgetMin = null;
        Double budgetMax = null;
        Integer categoryId = task.getCategoryId();
        List<Task> recommendedTasks = taskDAO.getLimitedRecommendedTasksWithFilters(
            searchKeyword, location, budgetMin, budgetMax, categoryId, taskId, userId, 4);

        // Đặt các thuộc tính vào request
        request.setAttribute("task", task);
        request.setAttribute("hasApplied", hasApplied);
        request.setAttribute("applications", applications);
        request.setAttribute("recommendedTasks", recommendedTasks);
        request.setAttribute("currentPage", "details");
        request.setAttribute("pageTitle", "Chi Tiết Công Việc");
        LOGGER.info("Chuyển tiếp đến taskDetails.jsp cho taskId: " + taskId + ", recommendedTasks size: " + recommendedTasks.size());
        request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);
    } catch (NumberFormatException e) {
        LOGGER.log(Level.WARNING, "Định dạng task ID không hợp lệ", e);
        request.setAttribute("error", "Task ID không hợp lệ.");
        request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);
    } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Lỗi khi hiển thị chi tiết task", e);
        request.setAttribute("error", "Không thể tải chi tiết task. Vui lòng thử lại.");
        request.getRequestDispatcher("/taskDetails.jsp").forward(request, response);
    }
}
    private void handleTaskCancellation(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String applicationIdStr = request.getParameter("application_id");
        if (applicationIdStr == null || applicationIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Application ID is required.\"}");
            return;
        }

        int applicationId;
        try {
            applicationId = Integer.parseInt(applicationIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid Application ID format.\"}");
            return;
        }

        try {
            boolean success = taskDAO.cancelApplication(applicationId, userId);
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Application cancelled successfully!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to cancel application. It may have already been processed.\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred while cancelling the application.\"}");
        }
    }

    private void handleTaskDeletion(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String applicationIdStr = request.getParameter("application_id");
        if (applicationIdStr == null || applicationIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Application ID is required.\"}");
            return;
        }

        int applicationId;
        try {
            applicationId = Integer.parseInt(applicationIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid Application ID format.\"}");
            return;
        }

        try {
            boolean success = taskDAO.deleteApplication(applicationId, userId);
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Application deleted successfully!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to delete application. It may not exist or you don't have permission.\"}");
            }
        } catch (SQLException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred while deleting the application.\"}");
        }
    }

    private void handleAcceptApplication(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String applicationIdStr = request.getParameter("application_id");
        String taskIdStr = request.getParameter("taskId");

        if (applicationIdStr == null || taskIdStr == null || applicationIdStr.trim().isEmpty() || taskIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Application ID or Task ID is required.\"}");
            return;
        }

        int applicationId, taskId;
        try {
            applicationId = Integer.parseInt(applicationIdStr);
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid Application ID or Task ID format.\"}");
            return;
        }

        try {
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || task.getUserId() != userId) {
                response.getWriter().write("{\"success\": false, \"message\": \"You do not have permission to accept applications for this task.\"}");
                return;
            }

            boolean success = taskDAO.acceptApplication(applicationId, taskId);
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Application accepted successfully!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to accept application. It may have already been processed.\"}");
            }
        } catch (SQLException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred while accepting the application.\"}");
        }
    }

    private void handleRejectApplication(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String applicationIdStr = request.getParameter("application_id");
        String taskIdStr = request.getParameter("taskId");

        if (applicationIdStr == null || taskIdStr == null || applicationIdStr.trim().isEmpty() || taskIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Application ID or Task ID is required.\"}");
            return;
        }

        int applicationId, taskId;
        try {
            applicationId = Integer.parseInt(applicationIdStr);
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid Application ID or Task ID format.\"}");
            return;
        }

        try {
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || task.getUserId() != userId) {
                response.getWriter().write("{\"success\": false, \"message\": \"You do not have permission to reject applications for this task.\"}");
                return;
            }

            boolean success = taskDAO.rejectApplication(applicationId, taskId);
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Application rejected successfully!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to reject application. It may have already been processed.\"}");
            }
        } catch (SQLException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred while rejecting the application.\"}");
        }
    }

    private String handleBookmarkTask(HttpServletRequest request, int userId) {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                return "{\"success\": false, \"message\": \"Task ID là bắt buộc.\"}";
            }
            
            int taskId = Integer.parseInt(taskIdStr);
            LOGGER.info("Đang bookmark task - userId: " + userId + ", taskId: " + taskId);
            
            boolean success = taskDAO.bookmarkTask(userId, taskId);
            String message = success ? 
                "Task đã được bookmark thành công!" : 
                "Không thể bookmark task. Task có thể đã được bookmark rồi.";
                
            LOGGER.info("Kết quả bookmark: " + success + ", message: " + message);
            return "{\"success\": " + success + ", \"message\": \"" + message + "\"}";
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Task ID không hợp lệ: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Task ID không hợp lệ.\"}";
        } catch (SQLException e) {
            LOGGER.severe("Lỗi cơ sở dữ liệu khi bookmark: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Lỗi cơ sở dữ liệu xảy ra.\"}";
        } catch (Exception e) {
            LOGGER.severe("Lỗi không xác định khi bookmark: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Đã xảy ra lỗi không xác định.\"}";
        }
    }

    private String handleUnbookmarkTask(HttpServletRequest request, int userId) {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                return "{\"success\": false, \"message\": \"Task ID là bắt buộc.\"}";
            }
            
            int taskId = Integer.parseInt(taskIdStr);
            LOGGER.info("Đang unbookmark task - userId: " + userId + ", taskId: " + taskId);
            
            boolean success = taskDAO.unbookmarkTask(userId, taskId);
            String message = success ? 
                "Task đã được bỏ bookmark thành công!" : 
                "Không thể bỏ bookmark task. Task có thể chưa được bookmark.";
                
            LOGGER.info("Kết quả unbookmark: " + success + ", message: " + message);
            return "{\"success\": " + success + ", \"message\": \"" + message + "\"}";
            
        } catch (NumberFormatException e) {
            LOGGER.severe("Task ID không hợp lệ: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Task ID không hợp lệ.\"}";
        } catch (SQLException e) {
            LOGGER.severe("Lỗi cơ sở dữ liệu khi unbookmark: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Lỗi cơ sở dữ liệu xảy ra.\"}";
        } catch (Exception e) {
            LOGGER.severe("Lỗi không xác định khi unbookmark: " + e.getMessage());
            return "{\"success\": false, \"message\": \"Đã xảy ra lỗi không xác định.\"}";
        }
    }

    private void showAcceptedTasks(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            request.setAttribute("userName", user.getFullName());
            request.setAttribute("userBalance", user.getBalance());

            List<Task> acceptedTasks = taskDAO.getAcceptedTasks(userId);
            request.setAttribute("acceptedTasks", acceptedTasks);
            request.getRequestDispatcher("/acceptedTasks.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách công việc đã nhận. Vui lòng thử lại.");
            request.getRequestDispatcher("/acceptedTasks.jsp").forward(request, response);
        }
    }
private void handleTaskApplication(HttpServletRequest request, HttpServletResponse response, int userId) 
        throws ServletException, IOException {
    String taskIdStr = request.getParameter("task_id");
    String message = request.getParameter("message");

    if (taskIdStr == null || taskIdStr.trim().isEmpty() || message == null || message.trim().isEmpty()) {
        request.setAttribute("error", "Task ID và tin nhắn ứng tuyển là bắt buộc.");
        request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
        showTaskDetails(request, response, userId);
        return;
    }

    int taskId;
    try {
        taskId = Integer.parseInt(taskIdStr);
    } catch (NumberFormatException e) {
        request.setAttribute("error", "Task ID không hợp lệ.");
        request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
        showTaskDetails(request, response, userId);
        return;
    }

    try {
        // Kiểm tra xem người dùng đã ứng tuyển chưa
        if (taskDAO.hasApplied(taskId, userId)) {
            request.setAttribute("error", "Bạn đã ứng tuyển cho công việc này.");
            request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
            showTaskDetails(request, response, userId);
            return;
        }

        // Kiểm tra xem người dùng có phải là chủ task không
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            request.setAttribute("error", "Công việc không tồn tại.");
            request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
            showTaskDetails(request, response, userId);
            return;
        }
        if (task.getUserId() == userId) {
            request.setAttribute("error", "Bạn không thể ứng tuyển cho công việc của chính mình.");
            request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
            showTaskDetails(request, response, userId);
            return;
        }

        // Gửi đơn ứng tuyển
        boolean success = taskDAO.applyForTask(taskId, userId, message);
        if (success) {
            request.setAttribute("success", "Đã gửi đơn ứng tuyển thành công!");
            request.setAttribute("hasApplied", true); // Cập nhật trạng thái đã ứng tuyển
        } else {
            request.setAttribute("error", "Không thể gửi đơn ứng tuyển. Vui lòng thử lại.");
        }
        request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
        showTaskDetails(request, response, userId);
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Lỗi khi xử lý ứng tuyển task: " + e.getMessage(), e);
        request.setAttribute("error", "Lỗi cơ sở dữ liệu khi gửi đơn ứng tuyển.");
        request.setAttribute("taskId", taskIdStr); // Lưu taskId vào request scope
        showTaskDetails(request, response, userId);
    }
}
    private void handleTaskCompletion(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Task ID is required.\"}");
                return;
            }

            int taskId = Integer.parseInt(taskIdStr);
            boolean success = taskDAO.confirmTaskCompletionByWorker(taskId, userId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/tasks?action=accepted");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to mark task as completed.\"}");
            }
        } catch (SQLException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Database error occurred.\"}");
        }
    }
}