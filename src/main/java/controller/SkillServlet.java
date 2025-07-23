package controller;

import dao.SkillDAO;
import model.EndorsementRequest;
import model.Skill;
import model.User;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class SkillServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            SkillDAO skillDAO = new SkillDAO();
            User user = (User) request.getSession().getAttribute("user");
            
            if ("adminView".equals(action)) {
                if (user == null || !"admin".equals(user.getRole())) {
                    response.sendRedirect("login");
                    return;
                }
                List<EndorsementRequest> requests = skillDAO.getPendingEndorsementRequests();
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("adminSkills.jsp").forward(request, response);
            } else if ("getCertificateImage".equals(action)) {
                String certificateIdStr = request.getParameter("certificateId");
                if (certificateIdStr == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                int certificateId = Integer.parseInt(certificateIdStr);
                byte[] imageData = skillDAO.getCertificateImage(certificateId);
                if (imageData != null) {
                    response.setContentType("image/jpeg");
                    response.getOutputStream().write(imageData);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                int userId;
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null && !userIdStr.isEmpty()) {
                    userId = Integer.parseInt(userIdStr);
                } else if (user != null) {
                    userId = user.getUserId();
                    System.out.println("Using session userId: " + userId); // Debug log
                } else {
                    response.sendRedirect("login");
                    return;
                }
                List<Skill> skills = skillDAO.getUserSkills(userId);
                System.out.println("Skills retrieved for userId " + userId + ": " + skills.size()); // Debug log
                request.setAttribute("skillDetails", skills);
                // Forward to skill.jsp instead of profile.jsp for /skill request
                request.getRequestDispatcher("skill.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid user ID format", e);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
            int userId = user.getUserId();
            String action = request.getParameter("action");
            SkillDAO skillDAO = new SkillDAO();
            
            if ("addSkill".equals(action)) {
                String skillName = request.getParameter("skillName");
                Part filePart = request.getPart("certificateImage");
                if (skillName != null && !skillName.trim().isEmpty() && skillName.length() <= 100) {
                    if (skillDAO.countCertificates(userId) >= 5 && filePart != null && filePart.getSize() > 0) {
                        request.setAttribute("error", "Bạn chỉ có thể tải lên tối đa 5 ảnh chứng chỉ.");
                        List<Skill> skills = skillDAO.getUserSkills(userId);
                        request.setAttribute("skillDetails", skills);
                        request.getRequestDispatcher("skill.jsp").forward(request, response);
                        return;
                    }
                    if (!skillName.matches("^[a-zA-Z0-9\\s]+$")) {
                        request.setAttribute("error", "Kỹ năng chỉ chứa chữ và số.");
                        List<Skill> skills = skillDAO.getUserSkills(userId);
                        request.setAttribute("skillDetails", skills);
                        request.getRequestDispatcher("skill.jsp").forward(request, response);
                        return;
                    }
                    skillDAO.addSkill(userId, skillName.trim());
                    if (filePart != null && filePart.getSize() > 0) {
                        try (InputStream fileContent = filePart.getInputStream()) {
                            byte[] imageBytes = fileContent.readAllBytes();
                            skillDAO.addCertificate(userId, skillName.trim(), imageBytes);
                        }
                    }
                    request.setAttribute("message", "Thêm kỹ năng thành công.");
                    skillDAO.notifyUser(userId, "Bạn đã thêm kỹ năng: " + skillName);
                } else {
                    request.setAttribute("error", "Tên kỹ năng không hợp lệ.");
                }
            } else if ("requestEndorsement".equals(action)) {
                int targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
                String skillName = request.getParameter("skillName");
                int certificateId = request.getParameter("certificateId") != null 
                    ? Integer.parseInt(request.getParameter("certificateId")) : 0;
                if (userId != targetUserId) {
                    skillDAO.createEndorsementRequest(targetUserId, skillName, certificateId, userId);
                    request.setAttribute("message", "Gửi yêu cầu xác nhận thành công.");
                    skillDAO.notifyUser(targetUserId, "Bạn có yêu cầu xác nhận kỹ năng: " + skillName + " từ người dùng ID " + userId);
                } else {
                    request.setAttribute("error", "Bạn không thể tự xác nhận kỹ năng.");
                }
            } else if ("approveRequest".equals(action) && "admin".equals(user.getRole())) {
                int requestId = Integer.parseInt(request.getParameter("requestId"));
                String status = request.getParameter("status");
                String adminNote = request.getParameter("adminNote");
                if ("APPROVED".equals(status) || "REJECTED".equals(status)) {
                    skillDAO.updateEndorsementRequest(requestId, status, adminNote);
                    request.setAttribute("message", "Cập nhật trạng thái yêu cầu thành công.");
                    int targetUserId = skillDAO.getUserIdFromRequest(requestId);
                    if (targetUserId > 0) {
                        skillDAO.notifyUser(targetUserId, "Yêu cầu xác nhận của bạn đã được " + status.toLowerCase());
                    }
                }
            }
            response.sendRedirect("adminView".equals(action) ? "skill?action=adminView" : "skill?userId=" + userId);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles skill management and certificate endorsement requests in JobLinks";
    }
}