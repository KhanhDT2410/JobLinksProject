package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false); // Kh�ng t?o session m?i n?u ch?a c�
        if (session != null) {
            session.invalidate(); // H?y to�n b? session
            LOGGER.info("LogoutServlet - ??ng xu?t th�nh c�ng, session ?� b? h?y");
        } else {
            LOGGER.warning("LogoutServlet - Kh�ng t�m th?y session ?? h?y");
        }
        resp.sendRedirect(req.getContextPath() + "/login"); // Redirect v? trang ??ng nh?p
    }
}