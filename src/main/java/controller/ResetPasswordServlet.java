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

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            request.setAttribute("error", "Vui l�ng nh?p email ?? ??t l?i m?t kh?u!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            request.setAttribute("error", "Phi�n l�m vi?c kh�ng h?p l?! Vui l�ng th? l?i.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Ki?m tra d? li?u
        if (newPassword == null || confirmPassword == null || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui l�ng nh?p ??y ?? th�ng tin!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "M?t kh?u x�c nh?n kh�ng kh?p!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        try {
            // C?p nh?t m?t kh?u
            userDAO.updatePassword(email, newPassword);
            session.removeAttribute("resetEmail"); // X�a email kh?i session
            request.setAttribute("message", "M?t kh?u ?� ???c c?p nh?t th�nh c�ng! Vui l�ng ??ng nh?p.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "L?i h? th?ng. Vui l�ng th? l?i sau!");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        }
    }
}