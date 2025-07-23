package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email != null) {
            email = email.trim().toLowerCase();
        }

        // Ki?m tra email
        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email không ???c ?? tr?ng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        try {
            // Ki?m tra email t?n t?i
            if (!userDAO.emailExists(email)) {
                request.setAttribute("error", "Email không t?n t?i trong h? th?ng!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // L?u email vào session
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);

            // Chuy?n h??ng ??n trang ??t l?i m?t kh?u
            response.sendRedirect(request.getContextPath() + "/resetPassword");
        } catch (SQLException e) {
            request.setAttribute("error", "L?i h? th?ng: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}