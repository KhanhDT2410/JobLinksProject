<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
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
        .profile-info-item {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 10px 0;
            border-bottom: 1px dashed #f5f5f5;
        }
        .profile-info-item:last-child {
            border-bottom: none;
        }
        .profile-info-item i {
            color: #3498db;
            font-size: 1.3rem;
            margin-right: 15px;
            width: 30px;
            text-align: center;
        }
        .profile-info-item .label {
            font-weight: 600;
            color: #555;
            width: 150px;
            flex-shrink: 0;
        }
        .profile-info-item .value {
            color: #666;
            flex-grow: 1;
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
        .btn-warning {
            background-color: #f39c12;
            border-color: #f39c12;
        }
        .btn-warning:hover {
            background-color: #e67e22;
            border-color: #e67e22;
            transform: translateY(-2px);
        }
        .btn-outline-primary {
            color: #3498db;
            border-color: #3498db;
        }
        .btn-outline-primary:hover {
            background-color: #3498db;
            color: #fff;
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
        .skills-section {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eee;
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
    </style>
    <script>
        function startOtpTimer(expiryStr) {
            if (!expiryStr) {
                document.querySelector('.otp-timer').innerHTML = "Chưa yêu cầu mã OTP.";
                return;
            }
            const expiry = new Date(expiryStr).getTime();
            const timerDiv = document.querySelector('.otp-timer');
            if (!timerDiv) return;

            const interval = setInterval(() => {
                const now = new Date().getTime();
                const distance = expiry - now;

                if (distance <= 0) {
                    clearInterval(interval);
                    timerDiv.innerHTML = "Mã OTP đã hết hạn.";
                    return;
                }

                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                timerDiv.innerHTML = `Mã OTP hết hạn sau: ${minutes}m ${seconds}s`;
            }, 1000);
        }

        window.onload = function() {
            const expiryStr = "${user.otpExpiry}";
            startOtpTimer(expiryStr);
        };
    </script>
</head>
<body>
<%@include file="header-layout.jsp" %>

<div class="container profile-container">
    <div class="profile-card">
        <div class="profile-header">
            <h2><i class="fas fa-user-circle"></i> Hồ sơ người dùng</h2>
            <p>Thông tin chi tiết về tài khoản của bạn.</p>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success text-center" role="alert">${message}</div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center" role="alert">${error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <c:if test="${not empty user}">
            <div class="profile-info">
                <div class="profile-info-item">
                    <i class="fas fa-signature"></i>
                    <span class="label">Họ tên:</span>
                    <span class="value">${user.fullName}</span>
                </div>

                <div class="profile-info-item">
                    <i class="fas fa-envelope"></i>
                    <span class="label">Email:</span>
                    <span class="value">${user.email}</span>
                </div>

                <div class="profile-info-item">
                    <i class="fas fa-phone-alt"></i>
                    <span class="label">Số điện thoại:</span>
                    <span class="value">${user.phone}</span>
                </div>

                <div class="profile-info-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="label">Địa chỉ:</span>
                    <span class="value">${user.address}</span>
                </div>

                <div class="profile-info-item">
                    <i class="fas fa-calendar-alt"></i>
                    <span class="label">Ngày tạo:</span>
                    <span class="value">${user.createdAt}</span>
                </div>
            </div>
            <div class="btn-group-custom">
                    <a href="skill" class="btn btn-warning">
        <i class="fas fa-tools"></i> Quản lý kỹ năng
    </a>
                <a href="editProfile.jsp" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Chỉnh sửa hồ sơ / Mật khẩu
                </a>
                <a href="tasks" class="btn btn-outline-primary">
                    <i class="fas fa-tasks"></i> Danh sách công việc
                </a>
                <a href="notifications" class="btn btn-outline-secondary">
                    <i class="fas fa-bell"></i> Thông báo
                </a>
            </div>
        </c:if>

        <c:if test="${empty user}">
            <div class="alert alert-info text-center" role="alert">
                <p class="mb-0">Không tìm thấy thông tin người dùng.</p>
                <p>Vui lòng đăng nhập hoặc kiểm tra lại.</p>
            </div>
        </c:if>
            
        <div class="section-divider"></div>
        <h3 class="profile-title mb-4 text-center">Trạng thái xác thực tài khoản</h3>
        <c:choose>
            <c:when test="${user.verified}">
                <div class="alert alert-success text-center">
                    Tài khoản đã được xác minh với email ${user.email}.
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning text-center">
                    Tài khoản của bạn chưa được xác minh. Vui lòng xác minh email ${user.email} để sử dụng đầy đủ chức năng.
                </div>
                <form action="profile" method="post" class="text-center mb-3">
                    <input type="hidden" name="action" value="sendOtp">
                    <button type="submit" class="btn btn-warning">Gửi mã OTP đến email ${user.email}</button>
                </form>
                <form action="profile" method="post" class="text-center">
                    <input type="hidden" name="action" value="verifyOtp">
                    <div class="mb-3">
                        <input type="text" name="otp" class="form-control w-50 mx-auto" placeholder="Nhập mã OTP" required>
                    </div>
                    <div class="otp-timer">
                        Chưa yêu cầu mã OTP.
                    </div>
                    <button type="submit" class="btn btn-success mt-2">Xác minh tài khoản</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>