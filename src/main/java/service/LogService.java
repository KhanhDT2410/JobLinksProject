package service;

import dao.LogDAO;
import model.SystemLog;

import java.sql.Timestamp;

public class LogService {

    // Ghi log có cả userId (ưu tiên dùng)
    public static void log(int userId, String username, String action, String target, String description) {
        SystemLog log = new SystemLog(0, userId, username, action, target, description, new Timestamp(System.currentTimeMillis()));
        new LogDAO().insertLog(log);
    }

    // Nếu không có userId (chỉ dành cho TH đặc biệt)
    public static void log(String username, String action, String target, String description) {
        SystemLog log = new SystemLog(0, 0, username, action, target, description, new Timestamp(System.currentTimeMillis()));
        new LogDAO().insertLog(log);
    }
}
