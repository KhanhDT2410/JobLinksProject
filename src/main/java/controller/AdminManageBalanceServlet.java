package servlet;

import dao.LogDAO;
import dao.UserDAO;
import model.SystemLog;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class AdminManageBalanceServlet extends HttpServlet {
    private UserDAO userDAO;
    private LogDAO logDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        logDAO = new LogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        // Kiểm tra admin
        if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("/JobLinks/login.jsp");
            return;
        }

        try {
            // Lấy danh sách user với phân trang (10 user/trang)
            int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            int limit = 10;
            int offset = (page - 1) * limit;
            List<User> users = userDAO.getUsersForAdmin(offset, limit);
            int totalUsers = userDAO.countNonAdminUsers();
            int totalPages = (int) Math.ceil((double) totalUsers / limit);

            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("/admin-manage-balance.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy danh sách người dùng: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        // Kiểm tra admin
        if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        double newBalance;
        String description = request.getParameter("description");

        try {
            newBalance = Double.parseDouble(request.getParameter("newBalance"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số dư không hợp lệ.");
            doGet(request, response);
            return;
        }

        try {
            boolean success = userDAO.updateBalance(userId, newBalance, description);
            if (success) {
                // Ghi log sau khi cập nhật số dư thành công
                SystemLog log = new SystemLog();
                log.setUserId(loggedInUser.getUserId());
                log.setEmail(loggedInUser.getEmail());
                log.setAction("Update User Balance");
                log.setTarget(String.valueOf(userId));
                log.setDescription(description != null && !description.isEmpty() ? description : "Cập nhật số dư bởi admin");
                log.setTimestamp(new Timestamp(System.currentTimeMillis()));
                logDAO.insertLog(log);

                request.setAttribute("message", "Cập nhật số dư thành công cho user ID: " + userId);
            } else {
                request.setAttribute("error", "Không thể cập nhật số dư. Vui lòng kiểm tra lại.");
            }
            doGet(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật số dư: " + e.getMessage());
            doGet(request, response);
        }
    }
}