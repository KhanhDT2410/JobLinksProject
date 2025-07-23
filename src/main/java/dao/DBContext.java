package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    protected Connection connection;
    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    public DBContext() {
        try {
            String user = "sa";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=JobLinks;encrypt=false";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            LOGGER.info("Kết nối cơ sở dữ liệu thành công");
        } catch (ClassNotFoundException | SQLException ex) {
            LOGGER.log(Level.SEVERE, "Không thể kết nối đến cơ sở dữ liệu", ex);
            throw new RuntimeException("Không thể kết nối đến cơ sở dữ liệu: " + ex.getMessage());
        }
    }

    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                String user = "sa";
                String pass = "123";
                String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=JobLinks;encrypt=false";
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connection = DriverManager.getConnection(url, user, pass);
                LOGGER.info("K?t n?i CSDL (getConnection) th�nh c�ng");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            LOGGER.log(Level.SEVERE, "Kh�ng th? k?t n?i l?i CSDL", ex);
            throw new RuntimeException("Kh�ng th? k?t n?i l?i CSDL: " + ex.getMessage());
        }
        return connection;
    }

    // Thêm phương thức getData từ DBContext thứ nhất
    public ResultSet getData(String sql, Object... params) throws SQLException {
        LOGGER.info("Thực thi truy vấn: " + sql);
        if (params.length > 0) {
            StringBuilder paramLog = new StringBuilder("Tham số: ");
            for (int i = 0; i < params.length; i++) {
                paramLog.append("[").append(i).append("]=").append(params[i]);
                if (i < params.length - 1) {
                    paramLog.append(", ");
                }
            }
            LOGGER.info(paramLog.toString());
        }

        // Luôn lấy connection đảm bảo đang mở
        Connection conn = getConnection();
        if (conn == null || conn.isClosed()) {
            throw new SQLException("Kh�ng th? m? connection t?i CSDL!");
        }

        PreparedStatement pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }

        ResultSet rs = pstmt.executeQuery();
        LOGGER.info("Truy vấn đã được thực thi thành công");
        return rs;
    }

    // Thêm phương thức executeUpdate
    public int executeUpdate(String sql, Object... params) {
        int rowsAffected = 0;
        LOGGER.info("Thực thi cập nhật: " + sql);

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            rowsAffected = pstmt.executeUpdate();
            LOGGER.info("Cập nhật thành công, số dòng ảnh hưởng: " + rowsAffected);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thực thi cập nhật", ex);
        }
        return rowsAffected;
    }

    // Thêm phương thức queryExists
    public boolean queryExists(String sql, Object... params) throws SQLException {
        LOGGER.info("Kiểm tra tồn tại với truy vấn: " + sql);

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                boolean exists = rs.next() && rs.getInt(1) > 0;
                LOGGER.info("Kết quả kiểm tra tồn tại: " + exists);
                return exists;
            }
        }
    }

    // Thêm phương thức kiểm tra kết nối
    public boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra trạng thái kết nối", ex);
            return false;
        }
    }

    // Thêm phương thức đóng kết nối
    public void close() {
        if (connection != null) {
            try {
                connection.close();
                LOGGER.info("Kết nối cơ sở dữ liệu đã được đóng");
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Lỗi khi đóng kết nối", ex);
            }
        }
    }

    // Phương thức đóng tài nguyên
    public void closeResources(PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đóng tài nguyên", ex);
        }
    }

    // Phương thức test query
    public void testQuery() {
        String sql = "SELECT COUNT(*) as total FROM users";
        ResultSet rs = null;
        try {
            rs = getData(sql);
            if (rs.next()) {
                int count = rs.getInt("total");
                LOGGER.info("Tổng số người dùng trong cơ sở dữ liệu: " + count);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi kiểm tra truy vấn", e);
        } finally {
            closeResources(null, rs);
        }
    }

    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        if (dbContext.isConnected()) {
            System.out.println("Kết nối cơ sở dữ liệu thành công!");
            dbContext.testQuery();
        } else {
            System.out.println("Kết nối cơ sở dữ liệu thất bại.");
        }
        dbContext.close();
    }
}
