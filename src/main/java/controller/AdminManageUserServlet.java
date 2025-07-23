package controller;

import dao.UserDAO;
import model.User;
import service.LogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminManageUserServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;   // số user trên mỗi trang
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    /* ----------- Helper ----------- */
    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: You must login as admin");
            return false;
        }
        String role = (String) session.getAttribute("role");
        return "admin".equalsIgnoreCase(role);
    }
    private int parseId(HttpServletRequest req, String param) throws ServletException {
        try { return Integer.parseInt(req.getParameter(param)); }
        catch (NumberFormatException e) { throw new ServletException("Invalid "+param+" parameter"); }
    }

    /* ----------- GET ----------- */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteUser(req, resp);
                    break;
                case "lock":
                    lockUnlockUser(req, resp, true);
                    break;
                case "unlock":
                    lockUnlockUser(req, resp, false);
                    break;
                default:
                    listUsers(req, resp);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    /* ----------- List w/ Pagination ----------- */
    private void listUsers(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Math.max(1, Integer.parseInt(pageParam)); }
            catch (NumberFormatException ignored) {}
        }

        int offset = (currentPage - 1) * PAGE_SIZE;
        int totalRecords = userDAO.countNonAdminUsers();
        int totalPages   = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        List<User> users = userDAO.getNonAdminUsersPaginated(offset, PAGE_SIZE);

        req.setAttribute("users", users);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/view-userList.jsp").forward(req, resp);
    }

    /* ----------- Edit/Delete/Lock ----------- */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        int userId = parseId(req, "id");
        User user  = userDAO.getUserById(userId);
        if (user == null || "admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect("AdminManageUserServlet");
            return;
        }
        req.setAttribute("user", user);
        req.getRequestDispatcher("/edit-userList.jsp").forward(req, resp);
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {

        int userId = parseId(req, "id");
        User user  = userDAO.getUserById(userId);
        if (user == null || "admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect("AdminManageUserServlet");
            return;
        }
        userDAO.deleteUser(userId);

        User admin = (User) req.getSession().getAttribute("user");
        LogService.log(admin.getUserId(), admin.getEmail(), "DELETE_USER",
                "User", "Admin đã xóa tài khoản: "+user.getEmail());

        resp.sendRedirect("AdminManageUserServlet");
    }

    private void lockUnlockUser(HttpServletRequest req, HttpServletResponse resp, boolean lock)
            throws SQLException, IOException, ServletException {

        int userId = parseId(req, "id");
        User user  = userDAO.getUserById(userId);
        if (user == null || "admin".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect("AdminManageUserServlet");
            return;
        }
        userDAO.lockUnlockUser(userId, lock);

        User admin = (User) req.getSession().getAttribute("user");
        String action  = lock ? "LOCK_USER"   : "UNLOCK_USER";
        String message = lock ? "Admin đã khóa tài khoản: "
                              : "Admin đã mở khóa tài khoản: ";
        LogService.log(admin.getUserId(), admin.getEmail(), action, "User",
                message + user.getEmail());

        resp.sendRedirect("AdminManageUserServlet?page="+req.getParameter("page"));
    }

    /* ----------- POST (update) ----------- */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!checkAdmin(req, resp)) return;

        try {
            int userId  = Integer.parseInt(req.getParameter("userId"));
            String role = req.getParameter("role");

            User oldUser = userDAO.getUserById(userId);
            if (oldUser == null || "admin".equalsIgnoreCase(oldUser.getRole())
                    || "admin".equalsIgnoreCase(role)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid role change");
                return;
            }

            User user = new User();
            user.setUserId(userId);
            user.setFullName(req.getParameter("fullName").trim());
            user.setEmail(req.getParameter("email").trim());
            user.setPhone(req.getParameter("phone"));
            user.setPassword((req.getParameter("password").isBlank())
                             ? oldUser.getPassword()
                             : req.getParameter("password").trim());
            user.setRole(role.trim());
            user.setAddress(req.getParameter("address"));
            user.setLocked("on".equals(req.getParameter("locked")));

            userDAO.updateUser(user);

            User admin = (User) req.getSession().getAttribute("user");
            LogService.log(admin.getUserId(), admin.getEmail(), "UPDATE_USER",
                    "User", "Admin đã cập nhật tài khoản: "+user.getEmail());

            resp.sendRedirect("AdminManageUserServlet");
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid userId parameter");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
