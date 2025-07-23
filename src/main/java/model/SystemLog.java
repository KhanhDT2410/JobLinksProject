package model;

import java.sql.Timestamp;

public class SystemLog {
    private int logId;
    private int userId;
    private String email;
    private String action;
    private String target;
    private String description;
    private Timestamp timestamp;

    public SystemLog() {
    }

    public SystemLog(int logId, int userId, String email, String action, String target, String description, Timestamp timestamp) {
        this.logId = logId;
        this.userId = userId;
        this.email = email;
        this.action = action;
        this.target = target;
        this.description = description;
        this.timestamp = timestamp;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
}
