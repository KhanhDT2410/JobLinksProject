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
        HttpSession session = req.getSession(false); // Không t?o session m?i n?u ch?a có
        if (session != null) {
            session.invalidate(); // H?y toàn b? session
            LOGGER.info("LogoutServlet - ??ng xu?t thành công, session ?ã b? h?y");
        } else {
            LOGGER.warning("LogoutServlet - Không tìm th?y session ?? h?y");
        }
        resp.sendRedirect(req.getContextPath() + "/login"); // Redirect v? trang ??ng nh?p
    }
}