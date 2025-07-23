package model;

import java.sql.Timestamp;

public class TaskApplication {
    private int applicationId;
    private int taskId;
    private int workerId;
    private String message;
    private Timestamp appliedAt;
    private String status;
    private String workerName;
    private String workerEmail;
    private String workerPhone;

    // Constructors
    public TaskApplication() {}

    public TaskApplication(int applicationId, int taskId, int workerId, String message, Timestamp appliedAt, String status,
                          String workerName, String workerEmail, String workerPhone) {
        this.applicationId = applicationId;
        this.taskId = taskId;
        this.workerId = workerId;
        this.message = message;
        this.appliedAt = appliedAt;
        this.status = status;
        this.workerName = workerName;
        this.workerEmail = workerEmail;
        this.workerPhone = workerPhone;
    }

    // Getters and Setters
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getWorkerId() { return workerId; }
    public void setWorkerId(int workerId) { this.workerId = workerId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getWorkerName() { return workerName; }
    public void setWorkerName(String workerName) { this.workerName = workerName; }

    public String getWorkerEmail() { return workerEmail; }
    public void setWorkerEmail(String workerEmail) { this.workerEmail = workerEmail; }

    public String getWorkerPhone() { return workerPhone; }
    public void setWorkerPhone(String workerPhone) { this.workerPhone = workerPhone; }
}