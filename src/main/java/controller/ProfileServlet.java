package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.Random;
import java.util.regex.Pattern;
import java.util.logging.Logger;

public class ProfileServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,12}$");
    private final UserDAO userDAO = new UserDAO();
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());

    private String generateOTP() {
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000); // 6 chữ số
        return String.valueOf(otp);
    }

    private boolean sendOtpEmail(String email, String otp, HttpSession session) {
        if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
            LOGGER.severe("Email nhận OTP không hợp lệ: " + email);
            session.setAttribute("error", "Email nhận OTP không hợp lệ: " + email);
            return false;
        }

        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/email.properties")) {
            if (input == null) {
                LOGGER.severe("Không tìm thấy file email.properties trong WEB-INF");
                session.setAttribute("error", "Không tìm thấy file cấu hình email.");
                return false;
            }
            props.load(input);
        } catch (IOException e) {
            LOGGER.severe("Lỗi khi đọc file email.properties: " + e.getMessage());
            session.setAttribute("error", "Lỗi đọc file cấu hình: " + e.getMessage());
            return false;
        }

        String senderEmail = props.getProperty("email.username");
        String senderPassword = props.getProperty("email.password");

        if (senderEmail == null || senderPassword == null) {
            LOGGER.severe("Thiếu email.username hoặc email.password trong email.properties");
            session.setAttribute("error", "Thiếu thông tin email trong file cấu hình.");
            return false;
        }

        Properties mailProps = new Properties();
        mailProps.put("mail.smtp.auth", "true");
        mailProps.put("mail.smtp.starttls.enable", "true");
        mailProps.put("mail.smtp.host", props.getProperty("mail.smtp.host", "smtp.gmail.com"));
        mailProps.put("mail.smtp.port", props.getProperty("mail.smtp.port", "587"));

        Session mailSession = Session.getInstance(mailProps, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Mã OTP Xác Minh Tài Khoản");
            message.setText("Mã OTP của bạn là: " + otp + "\nMã này có hiệu lực trong 5 phút.");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            LOGGER.severe("Lỗi khi gửi email OTP: " + e.getMessage());
            session.setAttribute("error", "Lỗi gửi email OTP: " + e.getMessage());
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            session = request.getSession(true);
            session.setAttribute("error", "Vui lòng đăng nhập để xem hồ sơ");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        try {
            User freshUser = userDAO.getUserById(sessionUser.getUserId());

            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                request.setAttribute("user", freshUser);
            } else {
                session.setAttribute("error", "Không tìm thấy thông tin người dùng.");
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi khi lấy thông tin người dùng: " + e.getMessage());
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            session = request.getSession(true);
            session.setAttribute("error", "Vui lòng đăng nhập để thực hiện hành động này");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null) {
            session.setAttribute("error", "Hành động không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            User dbUser = userDAO.getUserById(user.getUserId());

            if ("updateProfile".equals(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");

                if (fullName == null || fullName.trim().isEmpty() || fullName.length() > 100) {
                    session.setAttribute("error", "Họ tên không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                if (email == null || !EMAIL_PATTERN.matcher(email).matches()) {
                    session.setAttribute("error", "Email không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                if (!email.equals(dbUser.getEmail()) && userDAO.emailExists(email)) {
                    session.setAttribute("error", "Email đã được sử dụng bởi tài khoản khác.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                if (phone == null || !PHONE_PATTERN.matcher(phone).matches()) {
                    session.setAttribute("error", "Số điện thoại không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                if (address != null && address.length() > 255) {
                    session.setAttribute("error", "Địa chỉ quá dài.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }

                dbUser.setFullName(fullName);
                dbUser.setEmail(email);
                dbUser.setPhone(phone);
                dbUser.setAddress(address);
                userDAO.updateUser(dbUser);
                session.setAttribute("user", dbUser);
                session.setAttribute("message", "Cập nhật hồ sơ thành công!");
                response.sendRedirect(request.getContextPath() + "/profile");
            } else if ("changePassword".equals(action)) {
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (oldPassword == null || newPassword == null || confirmPassword == null ||
                    oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                    session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }

                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }

                if (!dbUser.getPassword().equals(oldPassword)) {
                    session.setAttribute("error", "Mật khẩu cũ không đúng!");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }

                userDAO.updatePassword(dbUser.getEmail(), newPassword);
                dbUser.setPassword(newPassword);
                session.setAttribute("user", dbUser);
                session.setAttribute("message", "Thay đổi mật khẩu thành công!");
                response.sendRedirect(request.getContextPath() + "/profile");
            } else if ("sendOtp".equals(action)) {
                if (dbUser.isVerified()) {
                    session.setAttribute("message", "Tài khoản đã được xác minh với email " + dbUser.getEmail() + ".");
                } else if (dbUser.getOtpExpiry() != null && 
                           dbUser.getOtpExpiry().after(Timestamp.valueOf(LocalDateTime.now().minusSeconds(30)))) {
                    session.setAttribute("error", "Vui lòng đợi 30 giây trước khi yêu cầu OTP mới.");
                } else {
                    String otp = generateOTP();
                    Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(5));
                    dbUser.setOtpCode(otp);
                    dbUser.setOtpExpiry(expiry);
                    userDAO.updateUser(dbUser);
                    if (sendOtpEmail(dbUser.getEmail(), otp, session)) {
                        session.setAttribute("user", dbUser); // Cập nhật user để truyền otpExpiry
                        session.setAttribute("message", "Mã OTP đã được gửi đến email " + dbUser.getEmail());
                    }
                }
                response.sendRedirect(request.getContextPath() + "/profile");
            } else if ("verifyOtp".equals(action)) {
                if (dbUser.isVerified()) {
                    session.setAttribute("message", "Tài khoản đã được xác minh với email " + dbUser.getEmail() + ".");
                } else {
                    String submittedOtp = request.getParameter("otp");
                    if (submittedOtp == null || submittedOtp.trim().isEmpty()) {
                        session.setAttribute("error", "Vui lòng nhập mã OTP.");
                    } else if (dbUser.getOtpCode() != null &&
                               dbUser.getOtpExpiry() != null &&
                               dbUser.getOtpExpiry().after(new Timestamp(System.currentTimeMillis())) &&
                               dbUser.getOtpCode().equals(submittedOtp)) {
                        dbUser.setVerified(true);
                        dbUser.setOtpCode(null);
                        dbUser.setOtpExpiry(null);
                        userDAO.updateUser(dbUser);
                        session.setAttribute("user", dbUser);
                        session.setAttribute("message", "Tài khoản đã được xác minh với email " + dbUser.getEmail() + ".");
                    } else {
                        session.setAttribute("error", dbUser.getOtpExpiry() != null &&
                                !dbUser.getOtpExpiry().after(new Timestamp(System.currentTimeMillis())) ?
                                "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới." :
                                "Mã OTP không hợp lệ.");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                session.setAttribute("error", "Hành động không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/profile");
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi hệ thống: " + e.getMessage());
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}