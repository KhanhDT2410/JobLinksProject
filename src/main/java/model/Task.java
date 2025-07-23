package model;

import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int userId;
    private String title;
    private String description;
    private int categoryId;
    private String categoryName;
    private String location;
    private Timestamp scheduledTime;
    private double budget;
    private String status;
    private String clientName;
    private Timestamp createdAt;
    private int applicationId;
    private Timestamp appliedAt;
    private String applicationStatus;
    private String applicationMessage;
    private Timestamp boostedAt;
    private Integer applicationCount;
    private int isHidden;
    private int workerId;
    private String workerName;
    private boolean canReview;
    private int acceptedWorkerId;
    private long daysRemaining;
    private boolean isBoosted; // Thêm để lưu trạng thái boost
    private Timestamp boostExpiry; // Thêm để lưu thời gian hết hạn boost

    public Task() {}

    public Task(int applicationId, int taskId, String title, String description, String message, String status) {
        this.applicationId = applicationId;
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.applicationMessage = message;
        this.applicationStatus = status;
    }

    // Getter và Setter cho các thuộc tính
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Timestamp getScheduledTime() { return scheduledTime; }
    public void setScheduledTime(Timestamp scheduledTime) { this.scheduledTime = scheduledTime; }

    public double getBudget() { return budget; }
    public void setBudget(double budget) { this.budget = budget; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    public String getApplicationStatus() { return applicationStatus; }
    public void setApplicationStatus(String applicationStatus) { this.applicationStatus = applicationStatus; }

    public String getApplicationMessage() { return applicationMessage; }
    public void setApplicationMessage(String applicationMessage) { this.applicationMessage = applicationMessage; }

    public Timestamp getBoostedAt() { return boostedAt; }
    public void setBoostedAt(Timestamp boostedAt) { this.boostedAt = boostedAt; }

    public Integer getApplicationCount() { return applicationCount; }
    public void setApplicationCount(Integer applicationCount) { this.applicationCount = applicationCount; }

    public int getIsHidden() { return isHidden; }
    public void setIsHidden(int isHidden) { this.isHidden = isHidden; }

    public int getWorkerId() { return workerId; }
    public void setWorkerId(int workerId) { this.workerId = workerId; }

    public String getWorkerName() { return workerName; }
    public void setWorkerName(String workerName) { this.workerName = workerName; }

    public boolean isCanReview() { return canReview; }
    public void setCanReview(boolean canReview) { this.canReview = canReview; }

    public int getAcceptedWorkerId() { return acceptedWorkerId; }
    public void setAcceptedWorkerId(int acceptedWorkerId) { this.acceptedWorkerId = acceptedWorkerId; }

    public long getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(long daysRemaining) { this.daysRemaining = daysRemaining; }

    public boolean isBoosted() { return isBoosted; }
    public void setBoosted(boolean isBoosted) { this.isBoosted = isBoosted; }

    public Timestamp getBoostExpiry() { return boostExpiry; }
    public void setBoostExpiry(Timestamp boostExpiry) { this.boostExpiry = boostExpiry; }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", location='" + location + '\'' +
                ", scheduledTime=" + scheduledTime +
                ", budget=" + budget +
                ", status='" + status + '\'' +
                ", clientName='" + clientName + '\'' +
                ", createdAt=" + createdAt +
                ", applicationId=" + applicationId +
                ", appliedAt=" + appliedAt +
                ", applicationStatus='" + applicationStatus + '\'' +
                ", applicationMessage='" + applicationMessage + '\'' +
                ", boostedAt=" + boostedAt +
                ", applicationCount=" + applicationCount +
                ", isHidden=" + isHidden +
                ", workerId=" + workerId +
                ", workerName='" + workerName + '\'' +
                ", canReview=" + canReview +
                ", acceptedWorkerId=" + acceptedWorkerId +
                ", daysRemaining=" + daysRemaining +
                ", isBoosted=" + isBoosted +
                ", boostExpiry=" + boostExpiry +
                '}';
    }
}