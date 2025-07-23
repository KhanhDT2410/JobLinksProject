package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Payment;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DepositServlet extends HttpServlet {
    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(DepositServlet.class.getName());

    @Override
    public void init() throws ServletException {
        try {
            userDAO = new UserDAO();
            LOGGER.info("DepositServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DepositServlet", e);
            throw new ServletException("Failed to initialize servlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("DepositServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                session.setAttribute("user", user);
                request.setAttribute("userName", user.getFullName());
                request.setAttribute("userBalance", user.getBalance());
            }
            
            List<Payment> paymentHistory = userDAO.getPaymentHistory(userId, 10);
            request.setAttribute("paymentHistory", paymentHistory);
            request.setAttribute("currentPage", "deposit");
            request.getRequestDispatcher("/deposit.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user data", e);
            request.setAttribute("error", "Không thể tải thông tin người dùng.");
            request.getRequestDispatcher("/deposit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            LOGGER.warning("DepositServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String amountStr = request.getParameter("amount");
        String txnRef = request.getParameter("txnRef");

        LOGGER.info("Processing deposit: userId=" + userId + ", amount=" + amountStr + ", txnRef=" + txnRef); // Debug log

        try {
            double amount = Double.parseDouble(amountStr);
            if (amount < 10000) {
                request.setAttribute("error", "Số tiền nạp phải tối thiểu 10,000 VND.");
                forwardToDepositPage(request, response, userId, session);
                return;
            }

            // Kiểm tra xem giao dịch đã được xử lý chưa (dựa trên txnRef)
            if (txnRef != null && userDAO.isTransactionProcessed(txnRef)) {
                LOGGER.warning("Giao dịch " + txnRef + " đã được xử lý trước đó.");
                request.setAttribute("error", "Giao dịch đã được xử lý trước đó.");
                forwardToDepositPage(request, response, userId, session);
                return;
            }

            boolean success = userDAO.addToBalance(userId, amount, "DEPOSIT", "Nạp tiền qua VNPAY, mã giao dịch: " + (txnRef != null ? txnRef : "N/A"));
            if (success) {
                LOGGER.info("Nạp tiền thành công cho user " + userId + ": " + amount + " VND");
                User updatedUser = userDAO.getUserById(userId);
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                }
                request.setAttribute("success", "Nạp tiền thành công: " + String.format("%,.0f", amount) + " VND!");
            } else {
                LOGGER.warning("Không thể nạp tiền cho user " + userId);
                request.setAttribute("error", "Không thể nạp tiền. Vui lòng thử lại.");
            }
            forwardToDepositPage(request, response, userId, session);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Số tiền không hợp lệ: " + amountStr, e);
            request.setAttribute("error", "Số tiền không hợp lệ. Vui lòng nhập số hợp lệ.");
            forwardToDepositPage(request, response, userId, session);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while depositing", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu. Vui lòng thử lại.");
            forwardToDepositPage(request, response, userId, session);
        }
    }

    private void forwardToDepositPage(HttpServletRequest request, HttpServletResponse response, 
                                    int userId, HttpSession session)
            throws ServletException, IOException {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                session.setAttribute("user", user);
                request.setAttribute("userName", user.getFullName());
                request.setAttribute("userBalance", user.getBalance());
            }
            
            List<Payment> paymentHistory = userDAO.getPaymentHistory(userId, 10);
            request.setAttribute("paymentHistory", paymentHistory);
            request.setAttribute("currentPage", "deposit");
            request.getRequestDispatcher("/deposit.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user data after deposit", e);
            request.setAttribute("error", "Không thể tải thông tin người dùng.");
            request.getRequestDispatcher("/deposit.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        userDAO = null;
        super.destroy();
    }
}