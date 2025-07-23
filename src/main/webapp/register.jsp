<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #8e9efc, #b388f8);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .form-container h2 {
            font-weight: 700;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .btn-primary {
            background-color: #7089ff;
            border: none;
        }

        .btn-primary:hover {
            background-color: #4f6df7;
        }

        .text-small {
            font-size: 0.9rem;
        }

        .form-footer {
            margin-top: 15px;
            text-align: center;
        }

        .form-footer a {
            text-decoration: none;
            color: #4f6df7;
            font-weight: 500;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }
        .form-label {
            font-weight: 600;
        }

    </style>
</head>
<body>
    <div class="form-container">
        <h2 class="text-center">Đăng ký</h2>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
            <c:remove var="error" scope="request"/>
        </c:if>
        <c:if test="${not empty registerSuccess}">
            <div class="alert alert-success">${registerSuccess}</div>
            <c:remove var="registerSuccess" scope="request"/>
        </c:if>
        <form action="register" method="post">
            <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <input type="text" class="form-control" name="fullname" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" class="form-control" name="phone" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Địa chỉ</label>
                <input type="text" class="form-control" name="address">
            </div>
            <button type="submit" class="btn btn-primary w-100">Đăng ký</button>
        </form>
        <div class="form-footer text-small mt-3">
            <p>Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
            <a href="home.jsp">Home</a>
        </div>
    </div>
</body>
</html>
