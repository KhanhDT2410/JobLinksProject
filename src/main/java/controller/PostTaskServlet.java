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

public class PostTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private static final Logger LOGGER = Logger.getLogger(PostTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        categoryDAO = new CategoryDAO();
        LOGGER.info("PostTaskServlet - DAOs khởi tạo thành công");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null) {
            LOGGER.severe("PostTaskServlet - DAOs chưa được khởi tạo");
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
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String budgetStr = request.getParameter("budget");
            String location = request.getParameter("location");
            String scheduledTimeStr = request.getParameter("scheduledTime");
            String categoryIdStr = request.getParameter("categoryId");

            LOGGER.info("PostTaskServlet - Dữ liệu đầu vào:");
            LOGGER.info("Title: " + title);
            LOGGER.info("Description: " + description);
            LOGGER.info("Budget: " + budgetStr);
            LOGGER.info("Location: " + location);
            LOGGER.info("Scheduled Time: " + scheduledTimeStr);
            LOGGER.info("Category ID: " + categoryIdStr);
            LOGGER.info("User ID: " + userId);

            // Basic validation checks
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Tiêu đề là bắt buộc");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Mô tả là bắt buộc");
            }
            
            // Parse and validate budget
            double budget;
            if (budgetStr == null || budgetStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Ngân sách là bắt buộc");
            }
            try {
                budget = Double.parseDouble(budgetStr);
                if (budget <= 0) {
                    throw new IllegalArgumentException("Ngân sách phải lớn hơn 0");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Giá trị ngân sách không hợp lệ");
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
            
            // Enhanced validation - Budget limit check
            if (budget >= 10000000) {
                throw new IllegalArgumentException("Ngân sách không được vượt quá 10.000.000 VND.");
            }

            // Continue with other validations
            if (location == null || location.trim().isEmpty()) {
                throw new IllegalArgumentException("Địa điểm là bắt buộc");
            }
            
            Timestamp scheduledTime;
            if (scheduledTimeStr == null || scheduledTimeStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Thời gian dự kiến là bắt buộc");
            }
            try {
                LocalDateTime dateTime = LocalDateTime.parse(scheduledTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                scheduledTime = Timestamp.valueOf(dateTime);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi parse thời gian: " + scheduledTimeStr, e);
                throw new IllegalArgumentException("Định dạng thời gian dự kiến không hợp lệ: " + scheduledTimeStr);
            }
            
            int categoryId;
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn danh mục");
            }
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Danh mục không hợp lệ");
            }

            // Create and save task
            Task task = new Task();
            task.setUserId(userId);
            task.setTitle(title);
            task.setDescription(description);
            task.setCategoryId(categoryId);
            task.setLocation(location);
            task.setScheduledTime(scheduledTime);
            task.setBudget(budget);

            taskDAO.createTask(task);
            LOGGER.info("Đã tạo task thành công: " + title);

            response.sendRedirect(request.getContextPath() + "/loadJobPoster");
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Lỗi dữ liệu đầu vào: " + e.getMessage(), e);
            request.setAttribute("error", e.getMessage());
            try {
                List<Task> tasks = taskDAO.getTasksByUserId(userId);
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("tasks", tasks);
                request.setAttribute("categories", categories);
            } catch (SQLException | NumberFormatException ex) {
                LOGGER.log(Level.SEVERE, "Lỗi tải dữ liệu: " + ex.getMessage(), ex);
                String errorMessage = (String) request.getAttribute("error");
                errorMessage = errorMessage != null ? errorMessage + " | " : "";
                request.setAttribute("error", errorMessage + "Không thể tải dữ liệu: " + ex.getMessage());
            }
            request.getRequestDispatcher("/postTask.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            try {
                List<Task> tasks = taskDAO.getTasksByUserId(userId);
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("tasks", tasks);
                request.setAttribute("categories", categories);
            } catch (SQLException | NumberFormatException ex) {
                LOGGER.log(Level.SEVERE, "Lỗi tải dữ liệu: " + ex.getMessage(), ex);
                String errorMessage = (String) request.getAttribute("error");
                errorMessage = errorMessage != null ? errorMessage + " | " : "";
                request.setAttribute("error", errorMessage + "Không thể tải dữ liệu: " + ex.getMessage());
            }
            request.getRequestDispatcher("/postTask.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}