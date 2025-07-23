package model;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int userId;
    private double amount;
    private String paymentType; // "DEPOSIT", "PAYMENT", "REFUND"
    private String description;
    private Timestamp createdAt;
    private String status; // "SUCCESS", "PENDING", "FAILED"

    public Payment() {}

    public Payment(int paymentId, int userId, double amount, String paymentType, 
                   String description, Timestamp createdAt, String status) {
        this.paymentId = paymentId;
        this.userId = userId;
        this.amount = amount;
        this.paymentType = paymentType;
        this.description = description;
        this.createdAt = createdAt;
        this.status = status;
    }

    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
