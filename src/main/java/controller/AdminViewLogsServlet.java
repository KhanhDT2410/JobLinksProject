package controller;

import dao.LogDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.SystemLog;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminViewLogsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of logs per page
    private static final Logger LOGGER = Logger.getLogger(AdminViewLogsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session and admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            LOGGER.log(Level.INFO, "Unauthorized access attempt to /admin/view-logs");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get parameters
            String pageStr = request.getParameter("page");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");

            // Parse page number with validation
            int page = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid page number format: {0}", pageStr);
                    page = 1; // Default to page 1 on invalid input
                }
            }

            // Parse timestamps with validation
            Timestamp startTime = null;
            Timestamp endTime = null;
            try {
                if (startTimeStr != null && !startTimeStr.isEmpty()) {
                    startTime = Timestamp.valueOf(startTimeStr.replace("T", " ") + ":00");
                }
                if (endTimeStr != null && !endTimeStr.isEmpty()) {
                    endTime = Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00");
                }
                // Validate that endTime is not before startTime
                if (startTime != null && endTime != null && endTime.before(startTime)) {
                    throw new IllegalArgumentException("End time cannot be before start time");
                }
            } catch (IllegalArgumentException e) {
                LOGGER.log(Level.WARNING, "Invalid date format or range: {0}", e.getMessage());
                request.setAttribute("errorMessage", "Định dạng ngày không hợp lệ hoặc khoảng thời gian không đúng. Vui lòng sử dụng định dạng yyyy-MM-dd'T'HH:mm và đảm bảo thời gian kết thúc sau thời gian bắt đầu.");
                request.getRequestDispatcher("/admin-view-logs.jsp").forward(request, response);
                return;
            }

            // Get logs from DAO
            LogDAO dao = new LogDAO();
            List<SystemLog> logs = dao.getPagedLogs(page, PAGE_SIZE, startTime, endTime);
            int totalLogs = dao.getTotalLogs(startTime, endTime);
            int totalPages = (int) Math.ceil((double) totalLogs / PAGE_SIZE);

            // Ensure page is within valid range
            if (page > totalPages && totalPages > 0) {
                LOGGER.log(Level.INFO, "Requested page {0} exceeds total pages {1}, redirecting to last page", new Object[]{page, totalPages});
                page = totalPages; // Redirect to last page if requested page is out of bounds
                logs = dao.getPagedLogs(page, PAGE_SIZE, startTime, endTime);
            }

            // Set attributes
            request.setAttribute("logs", logs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages > 0 ? totalPages : 1); // Ensure at least 1 page

            // Forward to JSP
            request.getRequestDispatcher("/admin-view-logs.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching logs", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải nhật ký. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}