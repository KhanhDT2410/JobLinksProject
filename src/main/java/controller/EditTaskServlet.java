package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import dao.TaskDAO;
import dao.CategoryDAO;
import model.Task;
import model.Category;

public class EditTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private static final Logger LOGGER = Logger.getLogger(EditTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            categoryDAO = new CategoryDAO();
            LOGGER.info("EditTaskServlet - DAOs khởi tạo thành công");
        } catch (Exception e) {
            LOGGER.severe("EditTaskServlet - Lỗi khởi tạo DAO: " + e.getMessage());
            throw new ServletException("Không thể khởi tạo DAO classes: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null) {
            LOGGER.severe("EditTaskServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String taskIdStr = request.getParameter("taskId");
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("ID task là bắt buộc");
            }

            int taskId = Integer.parseInt(taskIdStr);
            Task task = taskDAO.getTaskById(taskId);

            if (task == null || task.getUserId() != userId) {
                throw new IllegalArgumentException("Không tìm thấy task hoặc bạn không có quyền chỉnh sửa");
            }

            // Chuẩn hóa location để khớp với dropdown
            String normalizedLocation = normalizeLocation(task.getLocation());
            task.setLocation(normalizedLocation); // Cập nhật lại task với location chuẩn

            List<Category> categories = categoryDAO.getAllCategories();
            String formattedScheduledTime = null;
            if (task.getScheduledTime() != null) {
                formattedScheduledTime = task.getScheduledTime().toLocalDateTime()
                        .format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }
            request.setAttribute("task", task);
            request.setAttribute("categories", categories != null ? categories : new ArrayList<Category>());
            request.setAttribute("formattedScheduledTime", formattedScheduledTime);
            request.setAttribute("taskStatus", task.getStatus());
            request.getRequestDispatcher("/editTask.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "EditTaskServlet - Lỗi định dạng taskId: " + e.getMessage(), e);
            request.setAttribute("error", "ID task không hợp lệ");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "EditTaskServlet - Lỗi tham số: " + e.getMessage(), e);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "EditTaskServlet - Lỗi cơ sở dữ liệu: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null) {
            LOGGER.severe("EditTaskServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String taskIdStr = request.getParameter("taskId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String categoryIdStr = request.getParameter("categoryId");
            String location = request.getParameter("location");
            String scheduledTimeStr = request.getParameter("scheduledTime");
            String budgetStr = request.getParameter("budget");

            LOGGER.info("EditTaskServlet - Dữ liệu đầu vào:");
            LOGGER.info("Task ID: " + taskIdStr);
            LOGGER.info("Title: " + title);
            LOGGER.info("Description: " + description);
            LOGGER.info("Category ID: " + categoryIdStr);
            LOGGER.info("Location: " + location);
            LOGGER.info("Scheduled Time: " + scheduledTimeStr);
            LOGGER.info("Budget: " + budgetStr);
            LOGGER.info("User ID: " + userId);

            // Basic validation - Task ID
            int taskId;
            if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("ID task là bắt buộc");
            }
            try {
                taskId = Integer.parseInt(taskIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("ID task không hợp lệ");
            }
            
            // Basic validation - Title and Description
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Tiêu đề không được để trống");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Mô tả không được để trống");
            }
            
            // Enhanced validation - Title and Description word count limits
            String[] titleWords = title.trim().split("\\s+");
            if (titleWords.length > 10) {
                throw new IllegalArgumentException("Tiêu đề không được vượt quá 10 từ.");
            }
            
            String[] descriptionWords = description.trim().split("\\s+");
            if (descriptionWords.length > 50) {
                throw new IllegalArgumentException("Mô tả không được vượt quá 50 từ.");
            }
            
            // Basic validation - Category
            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Danh mục không hợp lệ");
            }
            
            // Basic validation - Location
            if (location == null || location.trim().isEmpty()) {
                throw new IllegalArgumentException("Địa điểm không được để trống");
            }
            // Kiểm tra location hợp lệ
            if (!"Hanoi".equalsIgnoreCase(location) && !"HCMC".equalsIgnoreCase(location) && !"Danang".equalsIgnoreCase(location)) {
                throw new IllegalArgumentException("Địa điểm không hợp lệ. Vui lòng chọn Hà Nội, Hồ Chí Minh hoặc Đà Nẵng.");
            }
            
            // Basic validation - Scheduled Time
            Timestamp scheduledTime;
            try {
                LocalDateTime dateTime = LocalDateTime.parse(scheduledTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                scheduledTime = Timestamp.valueOf(dateTime);
            } catch (Exception e) {
                throw new IllegalArgumentException("Định dạng thời gian không hợp lệ: " + scheduledTimeStr);
            }
            
            // Basic validation - Budget
            double budget;
            try {
                budget = Double.parseDouble(budgetStr);
                if (budget <= 0) throw new IllegalArgumentException("Ngân sách phải lớn hơn 0");
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Giá trị ngân sách không hợp lệ");
            }
            
            // Enhanced validation - Budget limit check
            if (budget >= 10000000) {
                throw new IllegalArgumentException("Ngân sách không được vượt quá 10.000.000 VND.");
            }

            // Check task ownership and status
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || task.getUserId() != userId) {
                throw new IllegalArgumentException("Không tìm thấy task hoặc bạn không có quyền chỉnh sửa");
            }

            // Chỉ cho phép chỉnh sửa nếu task không phải COMPLETED
            if ("COMPLETED".equalsIgnoreCase(task.getStatus())) {
                throw new IllegalArgumentException("Không thể chỉnh sửa task đã hoàn thành");
            }

            // Update task data
            location = normalizeLocation(location);
            task.setTitle(title);
            task.setDescription(description);
            task.setCategoryId(categoryId);
            task.setLocation(location);
            task.setScheduledTime(scheduledTime);
            task.setBudget(budget);

            taskDAO.updateTask(task);
            LOGGER.info("Đã cập nhật task thành công: " + taskId);

            response.sendRedirect(request.getContextPath() + "/loadJobPoster");
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "EditTaskServlet - Lỗi dữ liệu đầu vào: " + e.getMessage(), e);
            request.setAttribute("error", e.getMessage());
            try {
                List<Category> categories = categoryDAO.getAllCategories();
                Integer taskId = Integer.parseInt(request.getParameter("taskId"));
                Task task = taskDAO.getTaskById(taskId);
                if (task != null) {
                    String normalizedLocation = normalizeLocation(task.getLocation());
                    task.setLocation(normalizedLocation); // Chuẩn hóa lại location
                    String formattedScheduledTime = task.getScheduledTime() != null ?
                            task.getScheduledTime().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null;
                    request.setAttribute("task", task);
                    request.setAttribute("formattedScheduledTime", formattedScheduledTime);
                    request.setAttribute("categories", categories != null ? categories : new ArrayList<Category>());
                    request.setAttribute("taskStatus", task.getStatus());
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "EditTaskServlet - Lỗi khi lấy dữ liệu: " + ex.getMessage(), ex);
                request.setAttribute("error", (String) request.getAttribute("error") + " | Không thể tải dữ liệu: " + ex.getMessage());
            }
            request.getRequestDispatcher("/editTask.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "EditTaskServlet - Lỗi cơ sở dữ liệu: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                List<Category> categories = categoryDAO.getAllCategories();
                Integer taskId = Integer.parseInt(request.getParameter("taskId"));
                Task task = taskDAO.getTaskById(taskId);
                if (task != null) {
                    String normalizedLocation = normalizeLocation(task.getLocation());
                    task.setLocation(normalizedLocation); // Chuẩn hóa lại location
                    String formattedScheduledTime = task.getScheduledTime() != null ?
                            task.getScheduledTime().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null;
                    request.setAttribute("task", task);
                    request.setAttribute("formattedScheduledTime", formattedScheduledTime);
                    request.setAttribute("categories", categories != null ? categories : new ArrayList<Category>());
                    request.setAttribute("taskStatus", task.getStatus());
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "EditTaskServlet - Lỗi khi lấy dữ liệu: " + ex.getMessage(), ex);
                request.setAttribute("error", (String) request.getAttribute("error") + " | Không thể tải dữ liệu: " + ex.getMessage());
            }
            request.getRequestDispatcher("/editTask.jsp").forward(request, response);
        }
    }

    // Hàm chuẩn hóa location
    private String normalizeLocation(String location) {
        if (location == null) return "";
        location = location.trim().toLowerCase();
        if (location.contains("hanoi") || location.contains("ha noi")) return "Hanoi";
        if (location.contains("ho chi minh") || location.contains("hcmc")) return "HCMC";
        if (location.contains("da nang") || location.contains("danang")) return "Danang";
        return location; // Giữ nguyên nếu không khớp
    }
}