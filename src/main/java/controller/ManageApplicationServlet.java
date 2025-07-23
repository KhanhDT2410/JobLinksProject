package controller;

import dao.DBContext;
import dao.TaskDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ManageApplicationServlet extends HttpServlet {
    private DBContext dbContext;
    private TaskDAO taskDAO;
    private static final Logger LOGGER = Logger.getLogger(ManageApplicationServlet.class.getName());

    @Override
    public void init() throws ServletException {
        dbContext = new DBContext();
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response); // G?i l?i doPost ?? x? lý logic gi?ng nhau
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        int taskId = Integer.parseInt(request.getParameter("taskId"));

        try {
            if ("accept".equals(action)) {
                taskDAO.acceptApplication(applicationId, taskId);
            } else if ("reject".equals(action)) {
                taskDAO.rejectApplication(applicationId, taskId);
            }
            response.sendRedirect(request.getContextPath() + "/loadJobPoster");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error managing application", e);
            request.setAttribute("error", "L?i c? s? d? li?u. Vui lòng th? l?i.");
            request.getRequestDispatcher("/jobPoster.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (dbContext != null) dbContext.close();
    }
}