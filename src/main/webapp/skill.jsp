<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý kỹ năng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Sử dụng lại CSS từ profile.jsp */
        body {
            background-color: #f0f2f5;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #333;
        }
        .profile-container {
            padding: 40px 0;
        }
        .profile-card {
            background-color: #ffffff;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 140px;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .profile-header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .profile-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        .skills-section {
            margin-top: 20px;
        }
        .skills-section h3 {
            font-size: 1.8rem;
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
        }
        .skill-item {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            padding: 10px 15px;
            margin-bottom: 10px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }
        .skill-item .skill-name {
            font-weight: 500;
            color: #333;
        }
        .skill-item .endorsement-count {
            color: #7f8c8d;
            font-size: 0.95rem;
            margin-left: 10px;
        }
        .skill-item .certificate-images {
            margin-top: 10px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .skill-item .certificate-images img {
            max-width: 100px;
            max-height: 100px;
            border-radius: 5px;
            object-fit: cover;
        }
        .skill-item .btn {
            padding: 5px 15px;
            font-size: 0.9rem;
        }
        .skill-form {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        .skill-form input[type="text"], .skill-form input[type="file"] {
            width: 300px;
            padding: 8px;
            border-radius: 5px;
        }
        .skill-form .btn {
            padding: 8px 20px;
        }
        .btn-group-custom {
            margin-top: 40px;
            text-align: center;
        }
        .btn-group-custom .btn {
            font-size: 1.05rem;
            padding: 12px 25px;
            border-radius: 8px;
            margin: 0 8px;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
            transform: translateY(-2px);
        }
        .btn-outline-secondary {
            color: #7f8c8d;
            border-color: #7f8c8d;
        }
        .btn-outline-secondary:hover {
            background-color: #7f8c8d;
            color: #fff;
        }
        .alert {
            border-radius: 8px;
            font-size: 1.05rem;
        }
    </style>
</head>
<body>
<%@include file="header-layout.jsp" %>

<div class="container profile-container">
    <div class="profile-card">
        <div class="profile-header">
            <h2><i class="fas fa-tools"></i> Quản lý kỹ năng</h2>
            <p>Thêm và quản lý các kỹ năng của bạn</p>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success text-center" role="alert">${message}</div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center" role="alert">${error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

            <div class="skills-section">
                <h3><i class="fas fa-tools"></i> Kỹ năng</h3>
                <c:choose>
                    <c:when test="${empty skillDetails}">
                        <p class="text-center text-muted">Chưa có kỹ năng nào được thêm.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="skill" items="${skillDetails}">
                            <div class="skill-item">
                                <div>
                                    <span class="skill-name">${skill.skillName}</span>
                                    <span class="endorsement-count">(${skill.endorsementCount} xác nhận)</span>
                                </div>
                                <c:if test="${not empty skill.certificateIds}">
                                    <div class="certificate-images">
                                        <c:forEach var="certId" items="${skill.certificateIds}">
                                            <img src="skill?action=getCertificateImage&certificateId=${certId}" alt="Chứng chỉ">
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <c:if test="${sessionScope.user.userId != param.userId}">
                                    <form action="skill" method="POST">
                                        <input type="hidden" name="action" value="requestEndorsement">
                                        <input type="hidden" name="targetUserId" value="${param.userId}">
                                        <input type="hidden" name="skillName" value="${skill.skillName}">
                                        <button type="submit" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-check"></i> Yêu cầu xác nhận kỹ năng
                                        </button>
                                    </form>
                                    <c:forEach var="certId" items="${skill.certificateIds}">
                                        <form action="skill" method="POST">
                                            <input type="hidden" name="action" value="requestEndorsement">
                                            <input type="hidden" name="targetUserId" value="${param.userId}">
                                            <input type="hidden" name="skillName" value="${skill.skillName}">
                                            <input type="hidden" name="certificateId" value="${certId}">
                                            <button type="submit" class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-certificate"></i> Yêu cầu xác nhận chứng chỉ
                                            </button>
                                        </form>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <c:set var="currentUserId" value="${param.userId != null ? param.userId : sessionScope.user.userId}"/>
                <c:if test="${sessionScope.user.userId == currentUserId}">
                    <form action="skill" method="POST" class="skill-form" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="addSkill">
                        <input type="text" name="skillName" class="form-control" placeholder="Thêm kỹ năng" maxlength="100" required>
                        <input type="file" name="certificateImage" class="form-control" accept="image/*">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Thêm kỹ năng
                        </button>
                    </form>
                </c:if>
            </div>
        <div class="btn-group-custom">
            <a href="profile" class="btn btn-outline-secondary">
                <i class="fas fa-user"></i> Quay lại hồ sơ
            </a>
            <a href="tasks" class="btn btn-outline-primary">
                <i class="fas fa-tasks"></i> Danh sách công việc
            </a>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>