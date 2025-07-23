<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        /* Header */
        .header {
            background: var(--white);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            padding: 10px 0;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .logo-img {
            width: 200px;
            height: auto;
            border-radius: var(--radius);
            transition: var(--transition);
        }

        .logo-img:hover {
            transform: scale(1.05);
        }
        /* Layout */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 10px 20px 10px;
        }
        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 16px;
            border-radius: var(--radius);
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            gap: 6px;
        }

        .btn i {
            font-size: 0.9rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: var(--white);
            border: 2px solid var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
            transform: translateY(-2px);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background-color: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
        }

        .btn-link {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-link:hover {
            text-decoration: underline;
        }

        .btn-login, .btn-register {
            padding: 8px 16px;
            border-radius: var(--radius);
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-login {
            background-color: transparent;
            color: var(--secondary-color);
            border: 2px solid var(--secondary-color);
        }

        .btn-login:hover {
            background-color: var(--secondary-color);
            color: var(--white);
        }

        .btn-register {
            background-color: var(--secondary-color);
            color: var(--white);
            border: 2px solid var(--secondary-color);
        }

        .btn-register:hover {
            background-color: var(--secondary-hover);
            border-color: var(--secondary-hover);
        }

        .header .btn-logout {
            background-color: transparent;
            color: #dc3545;
            border: 2px solid #dc3545;
        }

        .btn-logout:hover {
            background-color: #dc3545;
            color: var(--white);
        }

        .btn-large {
            padding: 12px 24px;
            font-size: 1.1rem;
        }
        /*Greeting*/
        .greeting {
            font-weight: 600;
            font-size: 1rem;
            margin-right: 10px;
        }
        /* Nav */
        /* Navigation */
        .menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav {
            display: flex;
            gap: 20px;
        }

        .nav-link {
            text-decoration: none;
            color: var(--text-color);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
        }

        .nav-link i {
            font-size: 1.1rem;
        }

        .nav-link.active {
            color: var(--primary-color);
            font-weight: 600;
        }

        .nav-link:hover {
            color: var(--primary-color);
        }
        :root {
          --primary-color: #2caf99;
          --primary-hover: #259a87;
          --secondary-color: #007BFF;
          --secondary-hover: #0056b3;
          --success-color: #28a745;
          --success-hover: #218838;
          --text-color: #333;
          --text-light: #718096;
          --bg-color: #f8fffe;
          --bg-secondary: #e8f5f4;
          --white: #ffffff;
          --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
          --radius: 12px;
          --transition: all 0.3s ease;
        }
        </style>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <header class="header">
                    <div class="container">
                        <div class="header-content">
                            <a href="${pageContext.request.contextPath}/home" class="logo">
                                <img src="${pageContext.request.contextPath}/img/joblink.png" alt="JobLinks" class="logo-img">
                            </a>
                            <div class="menu">
                                <span class="greeting">Xin chào, ${sessionScope.user.fullName}</span>
                                <nav class="nav">
                                    <a href="${pageContext.request.contextPath}/home" class="nav-link active">
                                        <i class="fas fa-home"></i> Trang chủ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/profile" class="nav-link">
                                        <i class="fas fa-user"></i> Hồ sơ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/sendMessage" class="nav-link">
                                        <i class="fas fa-envelope"></i> Nhắn tin
                                    </a>
                                    <a href="${pageContext.request.contextPath}/notifications" class="nav-link">
                                        <i class="fas fa-bell"></i> Thông báo
                                    </a>
                                </nav>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </header>
            </c:when>
            <c:otherwise>
                <header class="header">
                    <div class="container">
                        <div class="header-content">
                            <a href="${pageContext.request.contextPath}/home" class="logo">
                                <img src="${pageContext.request.contextPath}/img/joblink.png" alt="JobLinks" class="logo-img">
                            </a>
                            <div class="menu">
                                <nav class="nav">
                                    <a href="${pageContext.request.contextPath}/home" class="nav-link active">
                                        <i class="fas fa-home"></i> Trang Chủ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/tasks" class="nav-link">
                                        <i class="fas fa-tasks"></i> Danh sách công việc
                                    </a>
                                </nav>
                                <div class="header-actions">
                                    <a href="login.jsp" class="btn btn-login">
                                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                    </a>
                                    <a href="register.jsp" class="btn btn-primary">
                                        <i class="fas fa-user-plus"></i> Đăng ký
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </header>
            </c:otherwise>
        </c:choose>
    </body>
</html>
