package controller;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.TaskDAO;
import dao.CategoryDAO;
import dao.NotificationDAO;
import dao.DBContext;
import model.Task;
import model.Category;
import model.TaskApplication;
import model.Notification;

public class LoadCompletedTasksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;
    private NotificationDAO notificationDAO;
    private DBContext dbContext;
    private static final long SEVEN_DAYS_IN_MILLIS = 7 * 24 * 60 * 60 * 1000L;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        categoryDAO = new CategoryDAO();
        notificationDAO = new NotificationDAO();
        dbContext = new DBContext();
        System.out.println("LoadCompletedTasksServlet - DAOs khởi tạo thành công");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (taskDAO == null || categoryDAO == null || notificationDAO == null || dbContext == null) {
            System.err.println("LoadCompletedTasksServlet - DAOs chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAOs chưa được khởi tạo");
            request.setAttribute("completedTasks", new ArrayList<Task>());
            request.setAttribute("applications", new HashMap<Integer, List<TaskApplication>>());
            request.getRequestDispatcher("/completedTasks.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Task> completedTasks = new ArrayList<>();
            Map<Integer, List<TaskApplication>> applications = new HashMap<>();
            List<Category> categories = new ArrayList<>();
            List<Notification> notifications = new ArrayList<>();

            // Lấy tất cả task của user
            List<Task> allTasks = taskDAO.getTasksByUserId(userId);
            if (allTasks != null) {
                for (Task task : allTasks) {
                    if ("COMPLETED".equalsIgnoreCase(task.getStatus())) {
                        // Kiểm tra xem task đã được đánh giá chưa
                        String checkReviewSql = "SELECT COUNT(*) FROM reviews WHERE task_id = ? AND reviewer_id = ?";
                        boolean hasReview = dbContext.queryExists(checkReviewSql, task.getTaskId(), userId);

                        // Lấy payment_time hoặc scheduled_time để tính thời hạn đánh giá
                        String timeSql = "SELECT payment_time FROM payments WHERE task_id = ?";
                        Timestamp completionTime = null;
                        long daysRemaining = -1;
                        boolean canReview = !hasReview;

                        try (ResultSet rs = dbContext.getData(timeSql, task.getTaskId())) {
                            if (rs.next()) {
                                completionTime = rs.getTimestamp("payment_time");
                            }
                            if (completionTime == null) {
                                // Fallback sang scheduled_time nếu không có payment_time
                                completionTime = task.getScheduledTime();
                            }
                            if (completionTime != null) {
                                long timeDiff = System.currentTimeMillis() - completionTime.getTime();
                                if (timeDiff <= SEVEN_DAYS_IN_MILLIS) {
                                    daysRemaining = (SEVEN_DAYS_IN_MILLIS - timeDiff) / (24 * 60 * 60 * 1000L);
                                } else {
                                    canReview = false; // Hết thời hạn 7 ngày
                                }
                            }
                        } catch (SQLException e) {
                            System.err.println("Lỗi khi lấy thời gian hoàn thành: " + e.getMessage());
                            canReview = false;
                        }

                        task.setCanReview(canReview);
                        task.setDaysRemaining(daysRemaining);

                        // Lấy acceptedWorkerId
                        List<TaskApplication> taskApps = taskDAO.getApplicationsByTaskId(task.getTaskId());
                        int acceptedWorkerId = 0;
                        if (taskApps != null && !taskApps.isEmpty()) {
                            for (TaskApplication app : taskApps) {
                                if ("ACCEPTED".equalsIgnoreCase(app.getStatus())) {
                                    acceptedWorkerId = app.getWorkerId();
                                    break;
                                }
                            }
                            applications.put(task.getTaskId(), taskApps);
                        }
                        task.setAcceptedWorkerId(acceptedWorkerId);
                        completedTasks.add(task);
                    }
                }
            }

            categories = categoryDAO.getAllCategories();
            notifications = notificationDAO.getNotificationsByUserId(userId);

            request.setAttribute("completedTasks", completedTasks);
            request.setAttribute("applications", applications);
            request.setAttribute("categories", categories);
            request.setAttribute("notifications", notifications);

            request.getRequestDispatcher("/completedTasks.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("LoadCompletedTasksServlet - Lỗi khi lấy dữ liệu: " + e.getMessage());
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.setAttribute("completedTasks", new ArrayList<Task>());
            request.setAttribute("applications", new HashMap<Integer, List<TaskApplication>>());
            request.getRequestDispatcher("/completedTasks.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            System.err.println("LoadCompletedTasksServlet - Lỗi không xác định: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("completedTasks", new ArrayList<Task>());
            request.setAttribute("applications", new HashMap<Integer, List<TaskApplication>>());
            request.getRequestDispatcher("/completedTasks.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public void destroy() {
        if (dbContext != null) dbContext.close();
    }
}