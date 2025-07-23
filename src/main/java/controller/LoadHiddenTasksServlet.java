package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.TaskDAO;
import model.Task;

public class LoadHiddenTasksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        System.out.println("LoadHiddenTasksServlet - DAO khởi tạo thành công");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (taskDAO == null) {
            System.err.println("LoadHiddenTasksServlet - DAO chưa được khởi tạo");
            request.setAttribute("error", "Lỗi hệ thống: DAO chưa được khởi tạo");
            request.setAttribute("tasks", new ArrayList<Task>());
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("LoadHiddenTasksServlet - UserId from session: " + userId);

        try {
            // Debug: Kiểm tra tổng số tasks
            int totalTasks = taskDAO.getTotalTasksByUserId(userId);
            System.out.println("Total tasks for userId " + userId + ": " + totalTasks);
            
            // Debug: Kiểm tra số lượng tasks ẩn
            int hiddenTasksCount = taskDAO.getHiddenTasksCountByUserId(userId);
            System.out.println("Hidden tasks count for userId " + userId + ": " + hiddenTasksCount);
            
            // Lấy danh sách tasks ẩn
            List<Task> tasks = taskDAO.getHiddenTasksByUserId(userId);
            if (tasks == null) {
                tasks = new ArrayList<>();
            }
            
            System.out.println("LoadHiddenTasksServlet - Found " + tasks.size() + " hidden tasks");
            
            // Debug: In ra thông tin từng task
            for (Task task : tasks) {
                System.out.println("Task ID: " + task.getTaskId() + 
                                 ", Title: " + task.getTitle() + 
                                 ", IsHidden: " + task.getIsHidden());
            }
            
            request.setAttribute("tasks", tasks);
            request.setAttribute("totalTasks", totalTasks);
            request.setAttribute("hiddenTasksCount", hiddenTasksCount);
            
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("LoadHiddenTasksServlet - Lỗi khi lấy dữ liệu: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.setAttribute("tasks", new ArrayList<Task>());
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}