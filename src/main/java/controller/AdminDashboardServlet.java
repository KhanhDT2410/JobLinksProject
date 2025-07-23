package controller;

import com.google.gson.Gson;
import dao.DashboardDAO;
import dao.LogDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();
        LogDAO logDAO = new LogDAO(); 
        Gson gson = new Gson();

        // ✅ Thống kê
        request.setAttribute("totalUsers", dao.countTotalUsers());
        request.setAttribute("totalTasks", dao.countTotalTasks());
        request.setAttribute("pendingTasks", dao.countPendingTasks());

        // ✅ Danh sách gần đây
        request.setAttribute("recentUsers", dao.getRecentUsers());
        request.setAttribute("recentTasks", dao.getRecentTasks());
        request.setAttribute("recentLogs", logDAO.getRecentLogs(5));
        // ✅ Dữ liệu biểu đồ
        request.setAttribute("monthlyLabelsJson", gson.toJson(dao.getMonthlyLabels()));
        request.setAttribute("monthlyCountsJson", gson.toJson(dao.getMonthlyTaskCounts()));
        request.setAttribute("taskTypeLabelsJson", gson.toJson(dao.getTaskTypeLabels()));
        request.setAttribute("taskTypeDataJson", gson.toJson(dao.getTaskTypeData()));

        // ✅ Chuyển tiếp tới JSP
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
