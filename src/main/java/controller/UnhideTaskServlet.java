package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Logger;
import dao.TaskDAO;
import model.Task;

public class UnhideTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskDAO taskDAO;
    private static final Logger LOGGER = Logger.getLogger(UnhideTaskServlet.class.getName());

    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        LOGGER.info("UnhideTaskServlet - DAO khởi tạo thành công");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID công việc không hợp lệ");
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response); // Chuyển về hiddenTasks.jsp
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || task.getUserId() != userId) {
                throw new IllegalArgumentException("Không tìm thấy task hoặc không thuộc quyền của bạn");
            }
            taskDAO.unhideTask(taskId, userId);
            LOGGER.info("Đã hủy ẩn task thành công: " + taskId);
            response.sendRedirect(request.getContextPath() + "/loadJobPoster"); // Tải lại jobPoster
        } catch (NumberFormatException e) {
            LOGGER.severe("UnhideTaskServlet - Lỗi định dạng taskId: " + e.getMessage());
            request.setAttribute("error", "ID công việc không hợp lệ");
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.severe("UnhideTaskServlet - Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi hủy ẩn công việc: " + e.getMessage());
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.warning("UnhideTaskServlet - Lỗi tham số: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/hiddenTasks.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}