<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="header">
    <div class="container">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <img src="${pageContext.request.contextPath}/img/joblink.png" alt="JobLinks" class="logo-img">
            </a>
            <div class="menu">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
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
                        <div class="dropdown">
                            <button class="btn btn-secondary dropdown-toggle" id="dropdownMenuButton">
                                <i class="fas fa-bars"></i>
                            </button>
                            <div class="dropdown-menu" id="dropdownMenu">
                                <a href="${pageContext.request.contextPath}/completedTasks" class="dropdown-item">
                                    <i class="fas fa-check-circle"></i> Xem Task Hoàn Thành
                                </a>
                                <a href="${pageContext.request.contextPath}/loadHiddenTasks" class="dropdown-item">
                                    <i class="fas fa-eye-slash"></i> Xem công việc đã ẩn
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item btn-logout">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <nav class="nav">
                            <a href="${pageContext.request.contextPath}/home" class="nav-link active">
                                <i class="fas fa-home"></i> Trang Chủ
                            </a>
                            <a href="${pageContext.request.contextPath}/tasks" class="nav-link">
                                <i class="fas fa-tasks"></i> Danh sách công việc
                            </a>
                            <a href="help.jsp" class="nav-link">
                                <i class="fas fa-question-circle"></i> Trợ Giúp
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
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<style>
    .header {
        background-color: white;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(44, 62, 80, 0.15);
        padding: 1rem 0;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    /* FIX: Thêm CSS cho header-content để căn chỉnh đúng */
    .header-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
    }

    .logo {
        display: flex;
        align-items: center;
        text-decoration: none;
    }

    .logo-img {
        height: 40px;
        width: auto;
        display: block;
    }

    .menu {
        display: flex;
        align-items: center;
        gap: 20px;
        flex: 1;
        justify-content: flex-end;
    }

    .greeting {
        font-weight: 500;
        color: #2c3e50;
        margin-right: 20px;
        white-space: nowrap;
    }

    .nav {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .nav-link {
        color: #2c3e50;
        text-decoration: none;
        font-weight: 500;
        padding: 0.5rem 1rem;
        transition: color 0.3s;
        display: flex;
        align-items: center;
        gap: 5px;
        white-space: nowrap;
    }

    .nav-link.active, .nav-link:hover {
        color: #3498db;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .dropdown {
        position: relative;
        display: inline-block;
    }

    .btn {
        padding: 0.5rem 1rem;
        border-radius: 0.35rem;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        transition: all 0.3s;
        cursor: pointer;
        border: none;
        white-space: nowrap;
    }

    .btn-primary {
        background-color: #3498db;
        color: white;
    }

    .btn-primary:hover {
        background-color: #2980b9;
    }

    .btn-login {
        background-color: #ffffff;
        border: 1px solid #3498db;
        color: #3498db;
    }

    .btn-login:hover {
        background-color: #e9ecef;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
    }

    .dropdown-toggle {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 1.5rem;
        color: #2c3e50;
        padding: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        background-color: white;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        border-radius: 0.35rem;
        min-width: 200px;
        z-index: 1000;
        top: 100%;
        margin-top: 0.5rem;
    }

    .dropdown-menu.show {
        display: block;
    }

    .dropdown-item {
        display: block;
        padding: 0.75rem 1rem;
        color: #2c3e50;
        text-decoration: none;
        font-size: 0.9rem;
        transition: background-color 0.3s;
    }

    .dropdown-item:hover {
        background-color: #ecf0f1;
        color: #3498db;
    }

    /* Responsive design */
    @media (max-width: 768px) {
        .header-content {
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .menu {
            order: 3;
            width: 100%;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .nav {
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .greeting {
            order: 2;
            margin-right: 0;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropdownButton = document.getElementById('dropdownMenuButton');
        const dropdownMenu = document.getElementById('dropdownMenu');
        
        if (dropdownButton && dropdownMenu) {
            dropdownButton.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!dropdownButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
                    dropdownMenu.classList.remove('show');
                }
            });
        }
    });
</script>