<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật hồ sơ người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5; /* Nền xám nhạt hiện đại */
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #333;
        }
        .profile-container {
            padding: 40px 0;
        }
        .profile-card {
            background-color: #ffffff;
            border-radius: 15px; /* Bo tròn góc nhiều hơn */
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); /* Bóng đổ mềm mại hơn */
            margin-top: 50px;
            max-width: 900px; /* Giới hạn chiều rộng để dễ đọc */
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
            color: #2c3e50; /* Màu chữ đậm hơn */
            margin-bottom: 10px;
        }
        .profile-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }
        .form-group-item {
            margin-bottom: 1.5rem; /* Khoảng cách giữa các nhóm form */
        }
        .form-group-item .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 0.5rem;
        }
        .form-group-item .form-control {
            border-radius: 8px; /* Bo tròn input fields */
            padding: 0.75rem 1rem;
            border: 1px solid #ddd;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        .form-group-item .form-control:focus {
            border-color: #88c8f0;
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
        }
        .section-divider {
            border-top: 1px dashed #e0e0e0; /* Đường kẻ phân chia mảnh hơn */
            margin: 40px 0;
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
        .btn-success {
            background-color: #27ae60; /* Màu xanh lá cây đậm hơn */
            border-color: #27ae60;
        }
        .btn-success:hover {
            background-color: #229954;
            border-color: #229954;
            transform: translateY(-2px);
        }
        .btn-primary {
            background-color: #3498db; /* Xanh dương đậm */
            border-color: #3498db;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
            transform: translateY(-2px);
        }
        .btn-secondary-custom {
            background-color: #6c757d; /* Màu xám cho nút quay lại */
            border-color: #6c757d;
            color: #fff;
        }
        .btn-secondary-custom:hover {
            background-color: #5a6268;
            border-color: #5a6268;
            color: #fff;
            transform: translateY(-2px);
        }
        .alert {
            border-radius: 8px;
            font-size: 1.05rem;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%@include file="header-layout.jsp" %>

<div class="container profile-container">
    <div class="profile-card">
        <div class="profile-header">
            <h2><i class="fas fa-user-edit"></i> Cập nhật hồ sơ người dùng</h2>
            <p>Chỉnh sửa thông tin cá nhân và thay đổi mật khẩu của bạn.</p>
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
            <form action="profile" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <h3 class="text-center mb-4" style="color: #34495e;"><i class="fas fa-info-circle"></i> Thông tin cá nhân</h3>
                <div class="form-group-item">
                    <label class="form-label">Họ tên</label>
                    <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                </div>

                <div class="form-group-item">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" value="${user.email}" required>
                </div>

                <div class="form-group-item">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" name="phone" value="${user.phone}" required>
                </div>

                <div class="form-group-item">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" class="form-control" name="address" value="${user.address}">
                </div>

                <div class="form-group-item">
                    <label class="form-label">Ngày tạo</label>
                    <input type="text" class="form-control" value="${user.createdAt}" readonly>
                </div>

                <div class="d-flex justify-content-center mt-4">
                    <button type="submit" class="btn btn-success me-3">
                        <i class="fas fa-save"></i> Lưu thay đổi
                    </button>
                    <a href="profile" class="btn btn-secondary-custom">
                        <i class="fas fa-arrow-left"></i> Quay lại hồ sơ
                    </a>
                </div>
            </form>

            <div class="section-divider"></div>

            <form action="updateProfile" method="post">
                <input type="hidden" name="action" value="changePassword">
                <h3 class="text-center mb-4" style="color: #34495e;"><i class="fas fa-lock"></i> Thay đổi mật khẩu</h3>
                <div class="form-group-item">
                    <label class="form-label">Mật khẩu cũ</label>
                    <input type="password" class="form-control" name="oldPassword" required>
                </div>
                <div class="form-group-item">
                    <label class="form-label">Mật khẩu mới</label>
                    <input type="password" class="form-control" name="newPassword" required>
                </div>
                <div class="form-group-item">
                    <label class="form-label">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
                <div class="d-flex justify-content-center mt-4">
                    <button type="submit" class="btn btn-primary me-3">
                        <i class="fas fa-key"></i> Cập nhật mật khẩu
                    </button>
                    <a href="profile" class="btn btn-secondary-custom">
                        <i class="fas fa-arrow-left"></i> Quay lại hồ sơ
                    </a>
                </div>
            </form>
        </c:if>

        <c:if test="${empty user}">
            <div class="alert alert-info text-center" role="alert">
                <p class="mb-0">Không tìm thấy thông tin người dùng để chỉnh sửa.</p>
                <p>Vui lòng đăng nhập hoặc kiểm tra lại.</p>
            </div>
        </c:if>
    </div>
</div>

<%@include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>