package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.User;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email và mật khẩu không được để trống!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = null;
        try {
            user = userDAO.login(email, password);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra tài khoản bị khóa
        if (user.isLocked()) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        int userId = user.getUserId();
        System.out.println("Debug: userId before saving: " + userId);
        if (userId <= 0) {
            System.out.println("Error: Invalid userId: " + userId);
            request.setAttribute("error", "Lỗi hệ thống: ID người dùng không hợp lệ!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", userId);
        session.setAttribute("role", user.getRole());
        session.setAttribute("email", user.getEmail());
        System.out.println("Debug: userId in session: " + session.getAttribute("userId"));

        // Chuyển hướng theo role
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}