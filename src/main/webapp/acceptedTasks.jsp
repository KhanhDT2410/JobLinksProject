
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Công việc đã nhận</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Cập nhật bố cục để footer bám dính */
        html {
            height: 100%;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; /* Bỏ margin mặc định */
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            flex: 1 0 auto; /* Nội dung chính mở rộng để đẩy footer xuống */
            margin-top: 20px;
        }
        .table-responsive {
            margin-top: 20px;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-primary {
            background-color: #6e8efb;
            border: none;
        }
        .btn-primary:hover {
            background-color: #5d7ce0;
        }
        .btn-success {
            background-color: #28a745;
            border: none;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .link-custom {
            color: #6e8efb;
            text-decoration: none;
            font-weight: 500;
        }
        .link-custom:hover {
            color: #5d7ce0;
            text-decoration: underline;
        }
        .back {
            padding: 10px 20px;
            background: #483C4F;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .back:hover {
            background: #5a4d66;
        }
        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
            width: 100%;
        }
        .nav-item {
            flex: 1;
            text-align: center;
            min-width: 0;
        }
        .nav-extra {
            margin-left: 10px;
        }
        .user-greeting {
            font-weight: bold;
        }
        .user-balance {
            font-weight: bold;
            color: #28a745;
        }
        
        /* Header Styles */
        .header {
            background: linear-gradient(90deg, #007bff, #00c4ff);
            color: white;
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        .header-logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }
        .header-nav {
            display: flex;
            gap: 20px;
        }
        .header-nav a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.3s ease;
        }
        .header-nav a:hover {
            opacity: 0.8;
        }
        .header-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .header-user-greeting {
            font-weight: bold;
        }
        .header-user-balance {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.9rem;
        }
        .header-btn {
            padding: 8px 16px;
            border-radius: 20px;
            border: none;
            color: white;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        .header-btn-login {
            background-color: #28a745;
        }
        .header-btn-login:hover {
            background-color: #218838;
        }
        .header-btn-register {
            background-color: #ffc107;
            color: #333;
        }
        .header-btn-register:hover {
            background-color: #e0a800;
        }
        .header-btn-logout {
            background-color: #dc3545;
        }
        .header-btn-logout:hover {
            background-color: #c82333;
        }
        
        /* Footer Styles */
        .footer {
            background: linear-gradient(90deg, #e3f2fd, #bbdefb);
            color: #333;
            padding: 40px 0;
            flex-shrink: 0; /* Footer không bị co lại */
            width: 100%;
        }
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .footer-section h3 {
            font-size: 1.2rem;
            margin-bottom: 15px;
            color: #007bff;
        }
        .footer-section p, .footer-section li {
            font-size: 0.9rem;
            line-height: 1.6;
        }
        .footer-links {
            list-style: none;
            padding: 0;
        }
        .footer-links a {
            color: #333;
            text-decoration: none;
        }
        .footer-links a:hover {
            color: #007bff;
        }
        .footer-social a {
            color: #333;
            font-size: 1.2rem;
            margin-right: 10px;
            transition: color 0.3s ease;
        }
        .footer-social a:hover {
            color: #007bff;
        }
        .footer-bottom {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #90caf9;
        }
        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border-radius: 50%;
            display: none;
            transition: background-color 0.3s ease;
        }
        .back-to-top:hover {
            background-color: #0056b3;
        }
        .back-to-top.show {
            display: block;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/home" class="header-logo">
                JobLinks
            </a>
            <nav class="header-nav">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/tasks"><i class="fas fa-tasks"></i> Danh sách công việc</a>
                <a href="${pageContext.request.contextPath}/acceptedTasks"><i class="fas fa-check"></i> Công việc đã nhận</a>
                <a href="${pageContext.request.contextPath}/DepositServlet"><i class="fas fa-wallet"></i> Nạp tiền</a>
                <a href="${pageContext.request.contextPath}/boostTask"><i class="fas fa-rocket"></i> Quản Lý Boost Task</a>
            </nav>
            <div class="header-user">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="header-user-greeting">Xin chào, <c:out value="${userName}" default="Khách"/></span>
                        <span class="header-user-balance">
                            Số dư: <fmt:formatNumber value="${userBalance}" type="currency" currencyCode="VND"/>
                        </span>
                        <a href="${pageContext.request.contextPath}/logout" class="header-btn header-btn-logout">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="header-btn header-btn-login">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </a>
                        <a href="register.jsp" class="header-btn header-btn-register">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <div class="container">
        <!-- Thanh điều hướng cũ (có thể giữ lại hoặc xóa đi vì đã có header) -->
        <div class="nav">
            <div class="nav-item">
                <button onclick="window.location.href='${pageContext.request.contextPath}/home'" class="back">
                    <i class="fas fa-home"></i> Trở về trang chính
                </button>
            </div>
            <div class="nav-item">
                <span class="user-greeting">Xin chào, <c:out value="${userName}" default="Khách"/></span>
            </div>
            <div class="nav-item">
                <span class="user-balance">
                    Số dư: <fmt:formatNumber value="${userBalance}" type="currency" currencyCode="VND"/>
                </span>
            </div>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/tasks" class="link-custom">Available Tasks</a>
                <a href="${pageContext.request.contextPath}/tasks?action=applied" class="link-custom nav-extra">My Applications</a>
                <a href="${pageContext.request.contextPath}/DepositServlet" class="link-custom nav-extra">Nạp tiền</a>
            </div>
        </div>

        <!-- Tiêu đề trang -->
        <h1>Công việc đã nhận</h1>

        <!-- Thông báo lỗi/thành công từ session -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">${sessionScope.error}</div>
            <% session.removeAttribute("error"); %>
        </c:if>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">${sessionScope.success}</div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <!-- Bảng công việc đã nhận -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Tiêu đề</th>
                        <th>Vị trí</th>
                        <th>Ngân sách</th>
                        <th>Thời gian tạo</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                    <tbody>
                        <c:forEach var="task" items="${acceptedTasks}">
                            <tr>
                                <td>${task.title}</td>
                                <td>${task.location}</td>
                                <td><fmt:formatNumber value="${task.budget}" type="currency" currencyCode="VND"/></td>
                                <td>${task.createdAt}</td>
                                <td>${task.status}</td>
                                <td>
                                    <c:if test="${task.status == 'IN_PROGRESS'}">
                                        <button type="button" class="btn btn-success btn-sm" onclick="completeTask(${task.taskId})">
                                            <i class="fas fa-check"></i> Xác nhận hoàn thành
                                        </button>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/acceptedTasks?action=details&taskId=${task.taskId}" class="btn btn-primary btn-sm">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
            </table>
        </div>

        <c:if test="${empty acceptedTasks}">
            <p class="text-center mt-3">Bạn chưa nhận công việc nào.</p>
        </c:if>

        <!-- Danh sách thông báo -->
        <c:if test="${not empty notifications}">
            <div class="card mt-4">
                <div class="card-header">Thông báo</div>
                <div class="card-body">
                    <c:forEach var="notification" items="${notifications}">
                        <div class="alert alert-info mb-2">
                            ${notification.message} <small class="text-muted">(${notification.createdAt})</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>JobLinks</h3>
                <p>Kết nối công việc, xây dựng tương lai. Tìm kiếm và ứng tuyển công việc dễ dàng với JobLinks.</p>
            </div>
            <div class="footer-section">
                <h3>Liên kết</h3>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/tasks">Công việc</a></li>
                    <li><a href="about.jsp">Về chúng tôi</a></li>
                    <li><a href="help.jsp">Hỗ trợ</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Liên hệ</h3>
                <ul class="footer-links">
                    <li><i class="fas fa-envelope"></i> support@joblinks.vn</li>
                    <li><i class="fas fa-phone"></i> (+84) 987 654 321</li>
                    <li><i class="fas fa-map-marker-alt"></i> Hà Nội, Việt Nam</li>
                </ul>
            </div>
            <div class="footer-section">
                <h3>Kết nối với chúng tôi</h3>
                <div class="footer-social">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2025 JobLinks. All rights reserved.</p>
        </div>
    </footer>

    <!-- Back to Top Button -->
    <a href="#" class="back-to-top" id="backToTop">
        <i class="fas fa-arrow-up"></i>
    </a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Back to top button
window.addEventListener('scroll', function() {
    var backToTop = document.getElementById('backToTop');
    if (window.pageYOffset > 300) {
        backToTop.classList.add('show');
    } else {
        backToTop.classList.remove('show');
    }
});
document.getElementById('backToTop').addEventListener('click', function(e) {
    e.preventDefault();
    window.scrollTo({top: 0, behavior: 'smooth'});
});

function completeTask(taskId) {
    if (!confirm('Bạn có chắc chắn muốn xác nhận hoàn thành công việc này?')) {
        return;
    }
    
    // Disable button để tránh click nhiều lần
    const button = event.target.closest('button');
    const originalText = button.innerHTML;
    button.disabled = true;
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    
    fetch('${pageContext.request.contextPath}/acceptedTasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=complete&taskId=' + taskId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Hiển thị thông báo thành công
            showAlert('success', data.message);
            // Reload trang để cập nhật trạng thái
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        } else {
            showAlert('danger', data.message);
            // Khôi phục button
            button.disabled = false;
            button.innerHTML = originalText;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('danger', 'Có lỗi xảy ra. Vui lòng thử lại.');
        // Khôi phục button
        button.disabled = false;
        button.innerHTML = originalText;
    });
}

function showAlert(type, message) {
    // Xóa alert cũ nếu có
    const oldAlert = document.querySelector('.dynamic-alert');
    if (oldAlert) {
        oldAlert.remove();
    }
    
    // Tạo alert mới
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} dynamic-alert`;
    alertDiv.innerHTML = message;
    
    // Thêm vào đầu container
    const container = document.querySelector('.container');
    container.insertBefore(alertDiv, container.firstChild);
    
    // Tự động ẩn sau 5 giây
    setTimeout(() => {
        alertDiv.remove();
    }, 5000);
}
</script>
</body>
</html>
