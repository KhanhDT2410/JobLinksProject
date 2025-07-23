package controller;

import dao.TaskDAO;
import dao.UserDAO;
import dao.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Task;
import model.User;

@WebServlet("/boostTask")
public class BoostTaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private UserDAO userDAO;
    private DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(BoostTaskServlet.class.getName());
    private static final double BOOST_FEE = 50000.0; // Phí boost là 50,000 VND

    @Override
    public void init() throws ServletException {
        try {
            taskDAO = new TaskDAO();
            userDAO = new UserDAO();
            dbContext = new DBContext();
            LOGGER.info("Khởi tạo BoostTaskServlet thành công");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi khởi tạo BoostTaskServlet", e);
            throw new ServletException("Lỗi khởi tạo servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("BoostTaskServlet: Không có người dùng trong session, chuyển hướng đến login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        forwardToBoostPage(request, response, userId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("BoostTaskServlet: Không có người dùng trong session, chuyển hướng đến login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("boost".equals(action)) {
            handleBoostTask(request, response, userId);
        } else {
            LOGGER.warning("BoostTaskServlet: Hành động không hợp lệ: " + action);
            request.setAttribute("error", "Hành động không hợp lệ.");
            forwardToBoostPage(request, response, userId);
        }
    }

    private void handleBoostTask(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            LOGGER.warning("BoostTaskServlet: Yêu cầu Task ID");
            request.setAttribute("error", "Yêu cầu Task ID.");
            forwardToBoostPage(request, response, userId);
            return;
        }

        int taskId;
        try {
            taskId = Integer.parseInt(taskIdStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("BoostTaskServlet: Định dạng Task ID không hợp lệ: " + taskIdStr);
            request.setAttribute("error", "Định dạng Task ID không hợp lệ.");
            forwardToBoostPage(request, response, userId);
            return;
        }

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Kiểm tra task tồn tại, thuộc về user, có trạng thái PENDING, và chưa được boost
            Task task = taskDAO.getTaskById(taskId);
            if (task == null || task.getUserId() != userId) {
                LOGGER.warning("Người dùng " + userId + " không sở hữu task " + taskId);
                request.setAttribute("error", "Bạn không sở hữu công việc này hoặc công việc không tồn tại.");
                forwardToBoostPage(request, response, userId);
                return;
            }

            if (!"PENDING".equalsIgnoreCase(task.getStatus())) {
                LOGGER.warning("Task " + taskId + " không ở trạng thái PENDING, trạng thái hiện tại: " + task.getStatus());
                request.setAttribute("error", "Chỉ các công việc có trạng thái PENDING mới có thể được boost.");
                forwardToBoostPage(request, response, userId);
                return;
            }

            if (task.isBoosted()) {
                LOGGER.warning("Task " + taskId + " đã được boost");
                request.setAttribute("error", "Công việc này đã được boost.");
                forwardToBoostPage(request, response, userId);
                return;
            }

            // Kiểm tra số dư
            User user = userDAO.getUserById(userId);
            if (user.getBalance() < BOOST_FEE) {
                LOGGER.warning("Số dư không đủ để boost task " + taskId + " cho user " + userId);
                request.setAttribute("error", "Số dư không đủ. Vui lòng nạp thêm (" + String.format("%,.0f", BOOST_FEE) + " VND cần thiết).");
                forwardToBoostPage(request, response, userId);
                return;
            }

            // Trừ phí và ghi giao dịch WITHDRAW
            boolean withdrawSuccess = userDAO.addToBalance(userId, -BOOST_FEE, "WITHDRAW", "Đẩy task ID: " + taskId);
            if (!withdrawSuccess) {
                LOGGER.warning("Số dư không đủ để boost task " + taskId + " cho user " + userId);
                request.setAttribute("error", "Số dư không đủ. Vui lòng nạp thêm (" + String.format("%,.0f", BOOST_FEE) + " VND cần thiết).");
                forwardToBoostPage(request, response, userId);
                return;
            }

            // Thực hiện boost task
            boolean boostSuccess = taskDAO.boostTask(taskId, userId);
            if (boostSuccess) {
                conn.commit(); // Commit giao dịch
                LOGGER.info("Task " + taskId + " được boost thành công bởi user " + userId);
                user.setBalance(user.getBalance() - BOOST_FEE); // Cập nhật số dư
                request.setAttribute("userBalance", user.getBalance());
                request.setAttribute("success", "Công việc đã được đẩy lên đầu danh sách! Phí: " + String.format("%,.0f", BOOST_FEE) + " VND");
            } else {
                conn.rollback(); // Rollback nếu boost thất bại
                LOGGER.warning("Không thể boost task " + taskId + " cho user " + userId);
                userDAO.addToBalance(userId, BOOST_FEE, "REFUND", "Hoàn tiền cho boost task ID: " + taskId + " thất bại");
                request.setAttribute("error", "Không thể boost công việc. Đã hoàn lại phí.");
            }

            forwardToBoostPage(request, response, userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu khi boost task " + taskId, e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Lỗi khi rollback", ex);
            }
            request.setAttribute("error", "Lỗi cơ sở dữ liệu. Vui lòng thử lại.");
            forwardToBoostPage(request, response, userId);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối", e);
                }
            }
        }
    }

    private void forwardToBoostPage(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                request.setAttribute("userName", user.getFullName());
                request.setAttribute("userBalance", user.getBalance());
            } else {
                request.setAttribute("error", "Không tìm thấy thông tin người dùng.");
            }
            List<Task> userTasks = taskDAO.getTasksByUserId(userId, "PENDING");
            request.setAttribute("userTasks", userTasks != null ? userTasks : new ArrayList<>());
            LOGGER.info("Số lượng userTasks: " + (userTasks != null ? userTasks.size() : "null"));
            request.getRequestDispatcher("boostTask.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách task cho user", e);
            request.setAttribute("error", "Không thể tải danh sách công việc. Vui lòng thử lại.");
            request.setAttribute("userTasks", new ArrayList<>());
            request.getRequestDispatcher("boostTask.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        taskDAO = null;
        userDAO = null;
        dbContext = null;
        super.destroy();
    }
}