package model;

import java.sql.Timestamp;

public class Report {
    private int reportId;
    private int reporterId;
    private int reportedId;
    private String taskTitle;
    private String reportType;
    private String message;
    private Timestamp reportTime;
    private String status;
    private String reportedName;

    public Report() {
    }

    public Report(int reportId, int reporterId, int reportedId, String taskTitle, String reportType, String message, Timestamp reportTime, String status) {
        this.reportId = reportId;
        this.reporterId = reporterId;
        this.reportedId = reportedId;
        this.taskTitle = taskTitle;
        this.reportType = reportType;
        this.message = message;
        this.reportTime = reportTime;
        this.status = status;
    }

    // Getters và Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }
    public int getReportedId() { return reportedId; }
    public void setReportedId(int reportedId) { this.reportedId = reportedId; }
    public String getTaskTitle() { return taskTitle; }
    public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }
    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Timestamp getReportTime() { return reportTime; }
    public void setReportTime(Timestamp reportTime) { this.reportTime = reportTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getReportedName() { return reportedName != null ? reportedName : "Không xác định"; }
    public void setReportedName(String reportedName) { this.reportedName = reportedName; }

    @Override
    public String toString() {
        return "Report{" +
                "reportId=" + reportId +
                ", reporterId=" + reporterId +
                ", reportedId=" + reportedId +
                ", taskTitle='" + taskTitle + '\'' +
                ", reportType='" + reportType + '\'' +
                ", message='" + message + '\'' +
                ", reportTime=" + reportTime +
                ", status='" + status + '\'' +
                ", reportedName='" + reportedName + '\'' +
                '}';
    }
}