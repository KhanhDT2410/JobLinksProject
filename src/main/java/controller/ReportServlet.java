package controller;

import dao.ReportDAO;
import model.Report;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReportServlet extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        System.out.println("User ID from session in doGet: " + userId);
        String userIdParam = request.getParameter("userId");
        String taskIdParam = request.getParameter("taskId");
        String action = request.getParameter("action");

        // Lấy danh sách báo cáo của người dùng
        List<Report> reports = reportDAO.getReportsByUserId(userId);
        System.out.println("Số lượng báo cáo trong doGet cho userId " + userId + ": " + (reports != null ? reports.size() : 0));
        request.setAttribute("reports", reports != null ? reports : new ArrayList<>());

        // Lấy thông tin người dùng hoặc task nếu có
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                int reportedId = Integer.parseInt(userIdParam);
                String reportedName = reportDAO.getUserNameById(reportedId);
                request.setAttribute("reportedId", reportedId);
                request.setAttribute("reportedName", reportedName);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID người dùng không hợp lệ!");
            }
        }
        if (taskIdParam != null && !taskIdParam.isEmpty()) {
            try {
                int taskId = Integer.parseInt(taskIdParam);
                String taskTitle = reportDAO.getTaskTitleById(taskId);
                request.setAttribute("taskId", taskId);
                request.setAttribute("taskTitle", taskTitle);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID task không hợp lệ!");
            }
        }
        request.setAttribute("action", action != null ? action : "user");

        request.getRequestDispatcher("report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int reporterId = (Integer) session.getAttribute("userId");
        System.out.println("User ID from session in doPost: " + reporterId);
        String reportedName = request.getParameter("reportedName");
        String taskTitle = request.getParameter("taskTitle");
        String reportType = request.getParameter("reportType");
        String message = request.getParameter("message");
        String action = request.getParameter("action");
        String taskIdParam = request.getParameter("taskId");

        // Lấy reportedId từ form và đặt lại mặc định, bỏ qua hoàn toàn khi action="task"
        String reportedIdParam = request.getParameter("reportedId");
        int reportedId = 0; // Đặt lại mặc định thành 0
        if (reportedIdParam != null && !reportedIdParam.isEmpty() && !action.equals("task")) {
            try {
                reportedId = Integer.parseInt(reportedIdParam); // Chỉ áp dụng nếu không phải action="task"
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID người bị báo cáo không hợp lệ!");
                reportedId = 0;
            }
        }

        // Lấy taskId nếu có
        int taskId = 0;
        if (taskIdParam != null && !taskIdParam.isEmpty()) {
            try {
                taskId = Integer.parseInt(taskIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID task không hợp lệ!");
            }
        }

        // Kiểm tra trùng lặp tên người dùng chỉ khi reportedId chưa được chọn và action là user/both
        List<User> matchingUsers = null;
        if ((action != null && (action.equals("user") || action.equals("both"))) && reportedId == 0 && reportedName != null && !reportedName.isEmpty()) {
            matchingUsers = reportDAO.getUsersByName(reportedName);
            if (matchingUsers.size() > 1) {
                request.setAttribute("matchingUsers", matchingUsers);
                request.setAttribute("reportedName", reportedName);
                request.setAttribute("taskTitle", taskTitle);
                request.setAttribute("reportType", reportType);
                request.setAttribute("message", message);
                request.setAttribute("action", action);
                request.setAttribute("taskId", taskId);
                request.setAttribute("reports", reportDAO.getReportsByUserId(reporterId));
                request.getRequestDispatcher("report.jsp").forward(request, response);
                return;
            } else if (!matchingUsers.isEmpty()) {
                reportedId = matchingUsers.get(0).getUserId();
            }
        }

        // Xử lý reportedId dựa trên action
        int finalReportedId = 0;
        if (action != null && action.equals("task") && taskId > 0) {
            finalReportedId = -taskId; // Chỉ sử dụng taskId khi report task
        } else if (action != null && action.equals("both") && taskId > 0 && reportedId > 0) {
            finalReportedId = -(taskId * 1000000 + reportedId); // Kết hợp taskId và reportedId
        } else if (action != null && action.equals("user")) {
            finalReportedId = reportedId; // Chỉ người dùng
        }

        Report report = new Report();
        report.setReporterId(reporterId);
        report.setReportedId(finalReportedId);
        report.setReportType(reportType);
        report.setMessage(message);
        report.setReportTime(new Timestamp(System.currentTimeMillis()));
        report.setStatus("pending");

        boolean success = reportDAO.saveReport(report);
        if (success) {
            request.setAttribute("success", "Báo cáo đã được gửi thành công!");
        } else {
            request.setAttribute("error", "Lỗi khi gửi báo cáo! Vui lòng kiểm tra lại dữ liệu hoặc liên hệ quản trị viên.");
            System.out.println("Lỗi khi lưu báo cáo cho reporterId: " + reporterId + ", reportedId: " + finalReportedId);
        }

        // Lấy lại danh sách báo cáo để hiển thị
        List<Report> reports = reportDAO.getReportsByUserId(reporterId);
        System.out.println("Số lượng báo cáo sau khi lưu cho userId " + reporterId + ": " + (reports != null ? reports.size() : 0));
        for (Report r : reports) {
            System.out.println("Report ID: " + r.getReportId() + ", Reporter ID: " + r.getReporterId() + ", Reported ID: " + r.getReportedId());
        }
        request.setAttribute("reports", reports != null ? reports : new ArrayList<>());

        request.getRequestDispatcher("report.jsp").forward(request, response);
    }
}