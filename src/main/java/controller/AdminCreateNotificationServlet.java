package controller;

import dao.NotificationDAO;
import dao.UserDAO;
import dao.LogDAO;
import model.SystemLog;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminCreateNotificationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminCreateNotificationServlet.class.getName());
    private final LogDAO logDAO = new LogDAO(); // thêm LogDAO để ghi log

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDAO userDAO = new UserDAO();
            List<User> users = userDAO.getAllUser();

            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin-create-notification.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi load form tạo notification", e);

            String status = request.getParameter("status");
            if (status == null || !status.equals("error")) {
                response.sendRedirect(request.getContextPath() + "/admin/createNotification?status=error");
            } else {
                response.setContentType("text/plain");
                response.getWriter().println("Error loading create notification page.");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String message = request.getParameter("message");
        String targetUserIdStr = request.getParameter("targetUserId");

        Integer targetUserId = null;
        if (targetUserIdStr != null && !targetUserIdStr.isEmpty()) {
            try {
                targetUserId = Integer.parseInt(targetUserIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid targetUserId: " + targetUserIdStr);
                targetUserId = null;
            }
        }

        HttpSession session = request.getSession();
        Integer adminId = (Integer) session.getAttribute("userId");
        String adminEmail = (String) session.getAttribute("email");

        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.createNotification(message, targetUserId);

            // Ghi log hành động tạo thông báo
            String target = (targetUserId != null) ? "USER #" + targetUserId : "ALL USERS";
            String description = "Admin đã tạo thông báo cho " + (targetUserId != null ? ("người dùng ID " + targetUserId) : "tất cả người dùng");

            SystemLog log = new SystemLog(0, adminId != null ? adminId : 0,
                    adminEmail != null ? adminEmail : "unknown",
                    "TẠO", target, description, Timestamp.valueOf(LocalDateTime.now()));
            logDAO.insertLog(log);

            response.sendRedirect(request.getContextPath() + "/admin/createNotification?status=success");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo notification", e);
            response.sendRedirect(request.getContextPath() + "/admin/createNotification?status=error");
        }
    }
}
