package model;

import java.util.List;

public class Skill {
    private int skillId;
    private int userId;
    private String skillName;
    private int endorsementCount;
    private List<Integer> certificateIds;

    // Constructors
    public Skill() {}

    public Skill(int skillId, int userId, String skillName, int endorsementCount) {
        this.skillId = skillId;
        this.userId = userId;
        this.skillName = skillName;
        this.endorsementCount = endorsementCount;
    }

    // Getters and Setters
    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
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

    public int getEndorsementCount() {
        return endorsementCount;
    }

    public void setEndorsementCount(int endorsementCount) {
        this.endorsementCount = endorsementCount;
    }

    public List<Integer> getCertificateIds() {
        return certificateIds;
    }

    public void setCertificateIds(List<Integer> certificateIds) {
        this.certificateIds = certificateIds;
    }

    @Override
    public String toString() {
        return "Skill{" +
                "skillId=" + skillId +
                ", userId=" + userId +
                ", skillName='" + skillName + '\'' +
                ", endorsementCount=" + endorsementCount +
                ", certificateIds=" + certificateIds +
                '}';
    }
}