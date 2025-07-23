package dao;

import java.sql.PreparedStatement;
import model.Skill;
import model.EndorsementRequest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SkillDAO extends DBContext {
    public void addSkill(int userId, String skillName) throws SQLException {
        String sql = "INSERT INTO user_skills (user_id, skill_name) VALUES (?, ?)";
        executeUpdate(sql, userId, skillName);
    }
    
    public void addCertificate(int userId, String skillName, byte[] imageData) throws SQLException {
        String sql = "INSERT INTO skill_certificates (user_id, skill_name, certificate_image) VALUES (?, ?, ?)";
        executeUpdate(sql, userId, skillName, imageData);
    }
    
    public int countCertificates(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM skill_certificates WHERE user_id = ?";
        ResultSet rs = getData(sql, userId);
        return rs.next() ? rs.getInt(1) : 0;
    }
    
public List<Skill> getUserSkills(int userId) throws SQLException {
    List<Skill> skills = new ArrayList<>();
    Map<String, Skill> skillMap = new HashMap<>();
    
    // Phương án đơn giản: chỉ lấy từ skill_certificates
    String sql = "SELECT DISTINCT sc.skill_name, sc.certificate_id " +
                 "FROM skill_certificates sc " +
                 "WHERE sc.user_id = ? " +
                 "ORDER BY sc.skill_name";
    
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            String skillName = rs.getString("skill_name");
            int certificateId = rs.getInt("certificate_id");
            
            Skill skill = skillMap.get(skillName);
            if (skill == null) {
                skill = new Skill();
                skill.setSkillName(skillName);
                // Tính endorsement count riêng
                skill.setEndorsementCount(getApprovedEndorsementCount(userId, skillName));
                skill.setCertificateIds(new ArrayList<>());
                skillMap.put(skillName, skill);
            }
            
            if (certificateId > 0) {
                skill.getCertificateIds().add(certificateId);
            }
        }
    }
    
    skills.addAll(skillMap.values());
    return skills;
}
    
    public List<Integer> getCertificateIds(int userId, String skillName) throws SQLException {
        String sql = "SELECT certificate_id FROM skill_certificates WHERE user_id = ? AND skill_name = ?";
        ResultSet rs = getData(sql, userId, skillName);
        List<Integer> certificateIds = new ArrayList<>();
        while (rs.next()) {
            certificateIds.add(rs.getInt("certificate_id"));
        }
        return certificateIds;
    }
    
    public byte[] getCertificateImage(int certificateId) throws SQLException {
        String sql = "SELECT certificate_image FROM skill_certificates WHERE certificate_id = ?";
        ResultSet rs = getData(sql, certificateId);
        return rs.next() ? rs.getBytes("certificate_image") : null;
    }
    
    public void createEndorsementRequest(int userId, String skillName, int certificateId, int endorserId) throws SQLException {
        String sql = "INSERT INTO skill_endorsement_requests (user_id, skill_name, certificate_id, endorser_id) VALUES (?, ?, ?, ?)";
        executeUpdate(sql, userId, skillName, certificateId == 0 ? null : certificateId, endorserId);
    }
    
    public int getApprovedEndorsementCount(int userId, String skillName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM skill_endorsement_requests WHERE user_id = ? AND skill_name = ? AND request_status = 'APPROVED'";
        ResultSet rs = getData(sql, userId, skillName);
        return rs.next() ? rs.getInt(1) : 0;
    }
    
    public List<EndorsementRequest> getPendingEndorsementRequests() throws SQLException {
        String sql = "SELECT * FROM skill_endorsement_requests WHERE request_status = 'PENDING' ORDER BY request_time";
        ResultSet rs = getData(sql);
        List<EndorsementRequest> requests = new ArrayList<>();
        while (rs.next()) {
            EndorsementRequest req = new EndorsementRequest();
            req.setRequestId(rs.getInt("request_id"));
            req.setUserId(rs.getInt("user_id"));
            req.setSkillName(rs.getString("skill_name"));
            req.setEndorserId(rs.getInt("endorser_id"));
            req.setRequestStatus(rs.getString("request_status"));
            req.setRequestTime(rs.getTimestamp("request_time"));
            req.setAdminNote(rs.getString("admin_note"));
            requests.add(req);
        }
        return requests;
    }
    
    public void updateEndorsementRequest(int requestId, String status, String adminNote) throws SQLException {
        String sql = "UPDATE skill_endorsement_requests SET request_status = ?, admin_note = ? WHERE request_id = ?";
        executeUpdate(sql, status, adminNote, requestId);
    }
    
    public void notifyUser(int userId, String message) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, 0, GETDATE())";
        executeUpdate(sql, userId, message);
    }
    
    public int getUserIdFromRequest(int requestId) throws SQLException {
        String sql = "SELECT user_id FROM skill_endorsement_requests WHERE request_id = ?";
        ResultSet rs = getData(sql, requestId);
        return rs.next() ? rs.getInt("user_id") : 0;
    }
}