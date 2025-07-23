package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class WithdrawServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            request.setAttribute("error", "Vui lòng đăng nhập để rút tiền.");
            request.getRequestDispatcher("deposit.jsp").forward(request, response);
            return;
        }

        // Get form parameters
        String accountNumber = request.getParameter("accountNumber");
        String bank = request.getParameter("bank");
        String password = request.getParameter("password");
        String withdrawAmountStr = request.getParameter("withdrawAmount");

        // Validate input
        if (accountNumber == null || bank == null || password == null || withdrawAmountStr == null ||
            accountNumber.trim().isEmpty() || bank.trim().isEmpty() || password.trim().isEmpty() || withdrawAmountStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("deposit.jsp").forward(request, response);
            return;
        }

        // Parse withdraw amount
        BigDecimal withdrawAmount;
        try {
            withdrawAmount = new BigDecimal(withdrawAmountStr);
            if (withdrawAmount.compareTo(new BigDecimal("10000")) < 0) {
                request.setAttribute("error", "Số tiền rút tối thiểu là 10,000 VND.");
                request.getRequestDispatcher("deposit.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số tiền không hợp lệ.");
            request.getRequestDispatcher("deposit.jsp").forward(request, response);
            return;
        }

        // Check password
        UserDAO userDAO = new UserDAO();
        try {
            if (!userDAO.checkPassword(user.getUserId(), password)) {
                request.setAttribute("error", "Mật khẩu không đúng.");
                request.getRequestDispatcher("deposit.jsp").forward(request, response);
                return;
            }

            // Process withdrawal using addToBalance
            String description = "Rút tiền qua " + bank + " (Số TK: " + accountNumber + ")";
            boolean success = userDAO.addToBalance(user.getUserId(), -withdrawAmount.doubleValue(), "WITHDRAW", description);

            if (success) {
                // Update user object in session
                User updatedUser = userDAO.getUserById(user.getUserId());
                session.setAttribute("user", updatedUser);

                // Update payment history in session
                List<model.Payment> paymentHistory = userDAO.getAllPaymentHistory(user.getUserId());
                session.setAttribute("paymentHistory", paymentHistory);

                // Set success message
                request.setAttribute("success", "Rút tiền thành công: " + new java.text.DecimalFormat("#,###").format(withdrawAmount) + " VND.");
            } else {
                request.setAttribute("error", "Lỗi khi xử lý rút tiền.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", e.getMessage().contains("Số dư không đủ") ? "Không đủ số dư để rút." : "Lỗi khi xử lý rút tiền: " + e.getMessage());
        }

        // Forward back to deposit.jsp
        request.getRequestDispatcher("deposit.jsp").forward(request, response);
    }
}