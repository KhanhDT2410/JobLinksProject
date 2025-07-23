package dao;

import model.User;
import model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {

    private final DBContext dbContext;
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public UserDAO() {
        this.dbContext = new DBContext();
    }

    public boolean addToBalance(int userId, double amount, String paymentType, String description) throws SQLException {
        Connection conn = null;
        PreparedStatement stmtUpdate = null;
        PreparedStatement stmtInsert = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra số dư nếu trừ tiền
            if (amount < 0) {
                String sqlCheck = "SELECT balance FROM users WHERE user_id = ?";
                PreparedStatement stmtCheck = conn.prepareStatement(sqlCheck);
                stmtCheck.setInt(1, userId);
                ResultSet rs = stmtCheck.executeQuery();
                if (rs.next() && rs.getDouble("balance") + amount < 0) {
                    throw new SQLException("Số dư không đủ để thực hiện giao dịch.");
                }
                dbContext.closeResources(stmtCheck, rs);
            }

            // Cập nhật số dư
            String sqlUpdate = "UPDATE users SET balance = balance + ? WHERE user_id = ?";
            stmtUpdate = conn.prepareStatement(sqlUpdate);
            stmtUpdate.setDouble(1, amount);
            stmtUpdate.setInt(2, userId);
            int rowsAffected = stmtUpdate.executeUpdate();

            if (rowsAffected > 0) {
                // Ghi lại lịch sử giao dịch
                String sqlInsert = "INSERT INTO user_transactions (user_id, amount, payment_type, description, created_at, status) VALUES (?, ?, ?, ?, GETDATE(), ?)";
                stmtInsert = conn.prepareStatement(sqlInsert);
                stmtInsert.setInt(1, userId);
                stmtInsert.setDouble(2, Math.abs(amount)); // Lưu số dương
                stmtInsert.setString(3, paymentType); // 'DEPOSIT', 'WITHDRAW', 'REFUND'
                stmtInsert.setString(4, description);
                stmtInsert.setString(5, "SUCCESS");
                stmtInsert.executeUpdate();
            }

            conn.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm số dư", e);
            throw e;
        } finally {
            dbContext.closeResources(stmtUpdate, null);
            dbContext.closeResources(stmtInsert, null);
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<Payment> getPaymentHistory(int userId, int limit) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT TOP (?) transaction_id AS payment_id, user_id, amount, payment_type, description, created_at, status "
                + "FROM user_transactions WHERE user_id = ? ORDER BY created_at DESC";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setInt(2, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentType(rs.getString("payment_type"));
                payment.setDescription(rs.getString("description"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));
                payment.setStatus(rs.getString("status"));
                payments.add(payment);
            }
            return payments;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public List<Payment> getAllPaymentHistory(int userId) throws SQLException {
        return getPaymentHistory(userId, Integer.MAX_VALUE);
    }

    public boolean checkPassword(int userId, String password) throws SQLException {
        String sql = "SELECT password FROM users WHERE user_id = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                return password.equals(storedPassword); // So sánh trực tiếp (không mã hóa)
            }
            return false;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setAddress(rs.getString("address"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setLocked(rs.getInt("locked") == 1);
                user.setBalance(rs.getDouble("balance"));
                user.setVerified(rs.getBoolean("is_verified"));
                user.setOtpCode(rs.getString("otp_code"));
                user.setOtpExpiry(rs.getTimestamp("otp_expiry"));
                return user;
            }
            return null;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public void updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            stmt.executeUpdate();
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("address"),
                        rs.getTimestamp("created_at")
                );
                user.setLocked(rs.getInt("locked") == 1);
                user.setBalance(rs.getDouble("balance"));
                user.setVerified(rs.getBoolean("is_verified"));
                user.setOtpCode(rs.getString("otp_code"));
                user.setOtpExpiry(rs.getTimestamp("otp_expiry"));
                return user;
            }
            return null;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public void insertUser(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, phone, password, role, address, created_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getAddress());
            stmt.executeUpdate();
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public List<User> getAllUser() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setAddress(rs.getString("address"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setLocked(rs.getInt("locked") == 1);
                user.setBalance(rs.getDouble("balance"));
                user.setVerified(rs.getBoolean("is_verified"));
                user.setOtpCode(rs.getString("otp_code"));
                user.setOtpExpiry(rs.getTimestamp("otp_expiry"));
                users.add(user);
            }
            return users;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            return rs.next();
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, password = ?, role = ?, address = ?, locked = ?, balance = ?, is_verified = ?, otp_code = ?, otp_expiry = ? WHERE user_id = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getAddress());
            stmt.setInt(7, user.isLocked() ? 1 : 0);
            stmt.setDouble(8, user.getBalance());
            stmt.setBoolean(9, user.isVerified());
            stmt.setString(10, user.getOtpCode());
            stmt.setTimestamp(11, user.getOtpExpiry());
            stmt.setInt(12, user.getUserId());
            stmt.executeUpdate();
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public void deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public void lockUnlockUser(int userId, boolean lock) throws SQLException {
        String sql = "UPDATE users SET locked = ? WHERE user_id = ?";
        PreparedStatement stmt = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, lock ? 1 : 0);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } finally {
            dbContext.closeResources(stmt, null);
        }
    }

    public int getUserIdByEmail(String email) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } finally {
            dbContext.closeResources(stmt, rs);
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }
    
    public boolean isTransactionProcessed(String txnRef) throws SQLException {
        String sql = "SELECT 1 FROM user_transactions WHERE description LIKE ? AND status = 'SUCCESS'";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + txnRef + "%"); // Tìm kiếm txnRef trong description
            rs = stmt.executeQuery();
            boolean exists = rs.next();
            LOGGER.info("Checked transaction with txnRef: " + txnRef + ", exists: " + exists);
            return exists;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking transaction with txnRef: " + txnRef, e);
            throw e;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    public boolean updateBalance(int userId, double newBalance) throws SQLException {
        String sql = "UPDATE users SET balance = ? WHERE user_id = ?";
        int rowsAffected = dbContext.executeUpdate(sql, newBalance, userId);
        return rowsAffected > 0;
    }

    // Hàm mới: Cập nhật số dư với kiểm tra và ghi lịch sử (không dùng updated_by)
    public boolean updateBalance(int userId, double newBalance, String description) throws SQLException {
        Connection conn = null;
        PreparedStatement stmtUpdate = null;
        PreparedStatement stmtInsert = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra user_id tồn tại
            String sqlCheckUser = "SELECT balance FROM users WHERE user_id = ?";
            PreparedStatement stmtCheck = conn.prepareStatement(sqlCheckUser);
            stmtCheck.setInt(1, userId);
            ResultSet rs = stmtCheck.executeQuery();
            if (!rs.next()) {
                throw new SQLException("Người dùng không tồn tại.");
            }
            double oldBalance = rs.getDouble("balance");
            dbContext.closeResources(stmtCheck, rs);

            // Kiểm tra số dư không âm
            if (newBalance < 0) {
                throw new SQLException("Số dư không thể âm.");
            }

            // Cập nhật số dư
            String sqlUpdate = "UPDATE users SET balance = ? WHERE user_id = ?";
            stmtUpdate = conn.prepareStatement(sqlUpdate);
            stmtUpdate.setDouble(1, newBalance);
            stmtUpdate.setInt(2, userId);
            int rowsAffected = stmtUpdate.executeUpdate();

            if (rowsAffected > 0) {
                // Ghi lịch sử giao dịch
                String sqlInsert = "INSERT INTO user_transactions (user_id, amount, payment_type, description, created_at, status) VALUES (?, ?, ?, ?, GETDATE(), ?)";
                stmtInsert = conn.prepareStatement(sqlInsert);
                stmtInsert.setInt(1, userId);
                stmtInsert.setDouble(2, Math.abs(newBalance - oldBalance));
                stmtInsert.setString(3, "ADMIN_UPDATE");
                stmtInsert.setString(4, description != null ? description : "Cập nhật số dư bởi admin");
                stmtInsert.setString(5, "SUCCESS");
                stmtInsert.executeUpdate();

                LOGGER.log(Level.INFO, "Updated balance for user {0} from {1} to {2}", 
                    new Object[]{userId, oldBalance, newBalance});
            }

            conn.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật số dư cho user " + userId, e);
            throw e;
        } finally {
            dbContext.closeResources(stmtUpdate, null);
            dbContext.closeResources(stmtInsert, null);
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        }
    }

    // Hàm mới: Lấy danh sách user cho admin (tối ưu, chỉ lấy cột cần thiết)
    public List<User> getUsersForAdmin(int offset, int limit) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, balance FROM users WHERE role <> 'admin' " +
                     "ORDER BY user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);
            rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setBalance(rs.getDouble("balance"));
                users.add(user);
            }
            return users;
        } finally {
            dbContext.closeResources(stmt, rs);
        }
    }

    /* --------- BO SUNG HÀM MAP() TÁI SỬ DỤNG ---------- */
    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setAddress(rs.getString("address"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setLocked(rs.getInt("locked") == 1);
        u.setBalance(rs.getDouble("balance"));
        u.setVerified(rs.getBoolean("is_verified"));
        u.setOtpCode(rs.getString("otp_code"));
        u.setOtpExpiry(rs.getTimestamp("otp_expiry"));
        return u;
    }

    /* --------- ĐẾM USER KHÔNG PHẢI ADMIN ---------- */
    public int countNonAdminUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role <> 'admin'";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return (rs.next()) ? rs.getInt(1) : 0;
        } finally {
            dbContext.closeResources(ps, rs);
        }
    }

    /* --------- LẤY USER KHÔNG PHẢI ADMIN THEO PHÂN TRANG ---------- */
    public List<User> getNonAdminUsersPaginated(int offset, int limit) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role <> 'admin' "
                + "ORDER BY user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Connection conn = dbContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } finally {
            dbContext.closeResources(ps, rs);
        }
        return list;
    }
}