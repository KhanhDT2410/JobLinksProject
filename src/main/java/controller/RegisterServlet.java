package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.LogService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

public class RegisterServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,12}$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Kiểm tra dữ liệu đầu vào
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            req.setAttribute("error", "Email không hợp lệ!");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (!PHONE_PATTERN.matcher(phone).matches()) {
            req.setAttribute("error", "Số điện thoại không hợp lệ (phải có 10-12 chữ số)!");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        UserDAO dao = new UserDAO();
        try {
            if (dao.emailExists(email)) {
                req.setAttribute("error", "Email đã tồn tại, vui lòng chọn email khác!");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            // Tạo user mới
            User user = new User();
            user.setEmail(email);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRole("user");

            // Thêm vào DB
            dao.insertUser(user);

            // Lấy userId sau khi insert
            int userId = dao.getUserIdByEmail(email);
            user.setUserId(userId);

            // ✅ Ghi log tạo tài khoản
            LogService.log(
                user.getUserId(),
                user.getEmail(),
                "REGISTER",
                "User",
                "Tài khoản mới được đăng ký: " + email
            );

            req.setAttribute("registerSuccess", "Đăng ký thành công. <a href='login.jsp'>Nhấn vào đây để đăng nhập</a>.");
        } catch (SQLException e) {
            e.printStackTrace();
            String msg = e.getMessage().contains("UNIQUE") ?
                    "Email đã tồn tại, vui lòng chọn email khác!" :
                    "Lỗi khi đăng ký. Vui lòng thử lại sau!";
            req.setAttribute("error", msg);
        }

        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
