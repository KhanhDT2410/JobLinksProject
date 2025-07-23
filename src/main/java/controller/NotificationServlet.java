package controller;

import dao.NotificationDAO;
import model.Notification;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(NotificationServlet.class.getName());
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
            request.setAttribute("notifications", notifications);
            request.getRequestDispatcher("/notifications.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/notifications.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        NotificationDAO notificationDAO = new NotificationDAO();

        try {
            if ("markAsRead".equals(action)) {
                notificationDAO.markNotificationAsRead(notificationId);
            } else if ("delete".equals(action)) {
                notificationDAO.deleteNotification(notificationId);
            }
            response.sendRedirect(request.getContextPath() + "/notifications");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/notifications.jsp").forward(request, response);
        }
    }
}