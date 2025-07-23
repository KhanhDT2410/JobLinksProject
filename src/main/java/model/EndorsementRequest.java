package model;

import java.sql.Timestamp;

public class EndorsementRequest {
    private int requestId;
    private int userId;
    private String skillName;
    private int endorserId;
    private String requestStatus;
    private Timestamp requestTime;
    private String adminNote;

    public EndorsementRequest() {
    }

    public EndorsementRequest(int requestId, int userId, String skillName, int endorserId, 
                            String requestStatus, Timestamp requestTime, String adminNote) {
        this.requestId = requestId;
        this.userId = userId;
        this.skillName = skillName;
        this.endorserId = endorserId;
        this.requestStatus = requestStatus;
        this.requestTime = requestTime;
        this.adminNote = adminNote;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public int getEndorserId() {
        return endorserId;
    }

    public void setEndorserId(int endorserId) {
        this.endorserId = endorserId;
    }

    public String getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(String requestStatus) {
        this.requestStatus = requestStatus;
    }

    public Timestamp getRequestTime() {
        return requestTime;
    }

    public void setRequestTime(Timestamp requestTime) {
        this.requestTime = requestTime;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }
}