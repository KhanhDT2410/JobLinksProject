<%@ page import="model.Task" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Theo dõi công việc - JobLinks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        html {
            height: 100%;
        }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            flex: 1 0 auto;
        }
        .section-title {
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin: 30px 0 15px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
        }
        .task-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .task-card {
            position: relative;
            background: #f9f9f9;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
            transition: transform 0.2s;
        }
        .task-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .task-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .task-info {
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }
        .task-info strong {
            color: #222;
        }
        .task-actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            color: white;
            text-align: center;
        }
        .btn-view {
            background-color: #007bff;
        }
        .btn-cancel {
            background-color: #dc3545;
        }
        .btn-view-applications {
            background-color: #28a745;
        }
        .btn-add-task {
            background-color: #007bff;
        }
        .btn-delete {
            background-color: #ff4444;
        }
        .delete-icon {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ff4444;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 12px;
            line-height: 1;
        }
        .delete-icon:hover {
            background: #cc0000;
        }
        .empty-state {
            text-align: center;
            padding: 20px;
            color: #666;
        }
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }
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
        .footer {
            background: linear-gradient(90deg, #e3f2fd, #bbdefb);
            color: #333;
            padding: 40px 0;
            flex-shrink: 0;
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
    <header class="header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/home" class="header-logo">
                JobLinks
            </a>
            <nav class="header-nav">
               
                <a href="${pageContext.request.contextPath}/tasks"><i class="fas fa-tasks"></i> Danh sách công việc</a>
                <a href="${pageContext.request.contextPath}/acceptedTasks"><i class="fas fa-check"></i> Công việc đã nhận</a>
                <a href="${pageContext.request.contextPath}/DepositServlet"><i class="fas fa-wallet"></i> Nạp tiền</a>
                <a href="${pageContext.request.contextPath}/boostTask"><i class="fas fa-rocket"></i> Quản Lý Boost Task</a>
            </nav>
            <div class="header-user">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="header-user-greeting">Xin chào, <c:out value="${sessionScope.email}" default="Khách"/></span>
                        <c:if test="${not empty sessionScope.user.balance}">
                            <span class="header-user-balance">
                                Số dư: <fmt:formatNumber value="${sessionScope.user.balance}" type="currency" currencyCode="VND"/>
                            </span>
                        </c:if>
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
        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
            <div class="alert alert-error"><%= error %></div>
        <%
            }
            if (success != null) {
        %>
            <div class="alert alert-success"><%= success %></div>
        <%
            }
        %>

        <div class="section-title">Công việc tôi đã ứng tuyển</div>
        <% List<Task> tasks = (List<Task>) request.getAttribute("tasks"); %>
        <% if (tasks == null || tasks.isEmpty()) { %>
            <div class="empty-state">
                <p>Bạn chưa ứng tuyển công việc nào.</p>
            </div>
        <% } else { %>
            <div class="task-grid">
                <% for (Task task : tasks) { %>
                    <div class="task-card" id="task-card-<%= task.getApplicationId() %>">
                        <% if ("cancelled".equalsIgnoreCase(task.getApplicationStatus())) { %>
                            <button type="button" class="delete-icon" onclick="deleteApplication(<%= task.getApplicationId() %>)">X</button>
                        <% } %>
                        <div class="task-title"><%= task.getTitle() != null ? task.getTitle() : "Không có tiêu đề" %></div>
                        <div class="task-info"><strong>Mô tả:</strong> <%= task.getDescription() != null ? task.getDescription() : "Không có mô tả" %></div>
                        <div class="task-info"><strong>Trạng thái ứng tuyển:</strong> <span id="status-<%= task.getApplicationId() %>"><%= task.getApplicationStatus() != null ? task.getApplicationStatus() : "Chưa rõ" %></span></div>
                        <div class="task-info"><strong>Ngày ứng tuyển:</strong> <%= task.getAppliedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(task.getAppliedAt()) : "Chưa rõ" %></div>
                        <div class="task-actions">
                            <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=<%= task.getTaskId() %>" class="btn btn-view">Xem chi tiết</a>
                            <% if ("pending".equalsIgnoreCase(task.getApplicationStatus())) { %>
                                <button type="button" class="btn btn-cancel" onclick="cancelApplication(<%= task.getApplicationId() %>)">Hủy ứng tuyển</button>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <div class="section-title">Công việc tôi đã đăng</div>
        <% List<Task> postedTasks = (List<Task>) request.getAttribute("postedTasks"); %>
        <% if (postedTasks == null || postedTasks.isEmpty()) { %>
            <div class="empty-state">
                <p>Bạn chưa đăng công việc nào.</p>
                <p><a href="tasks" class="btn btn-add-task">Đăng công việc mới</a></p>
            </div>
        <% } else { %>
            <div class="task-grid">
                <% for (Task task : postedTasks) { %>
                    <div class="task-card">
                        <div class="task-title"><%= task.getTitle() != null ? task.getTitle() : "Không có tiêu đề" %></div>
                        <div class="task-info"><strong>Trạng thái:</strong> <%= task.getStatus() != null ? task.getStatus() : "Chưa rõ" %></div>
                        <% if (task.getCategoryName() != null) { %>
                            <div class="task-info"><strong>Danh mục:</strong> <%= task.getCategoryName() %></div>
                        <% } %>
                        <div class="task-info"><strong>Ngày đăng:</strong> <%= task.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(task.getCreatedAt()) : "Chưa rõ" %></div>
                        <div class="task-info"><strong>Số lượng ứng tuyển:</strong> <%= task.getApplicationCount() != null ? task.getApplicationCount() : 0 %></strong></div>
                        <div class="task-actions">
                            <% if (task.getApplicationCount() != null && task.getApplicationCount() > 0) { %>
                                <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=<%= task.getTaskId() %>" class="btn btn-view-applications">Xem ứng tuyển</a>
                            <% } %>
                            <% if ("cancelled".equalsIgnoreCase(task.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/tasks" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteTask">
                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                    <button type="submit" class="btn btn-delete" onclick="return confirm('Bạn có chắc muốn xóa công việc này không?')">Xóa</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

<div class="section-title">Công việc đã thích</div>
<% List<Task> bookmarkedTasks = (List<Task>) request.getAttribute("bookmarkedTasks"); %>
<% if (bookmarkedTasks == null || bookmarkedTasks.isEmpty()) { %>
    <div class="empty-state">
        <p>Bạn chưa thích công việc nào.</p>
    </div>
<% } else { %>
    <div class="task-grid">
        <% for (Task task : bookmarkedTasks) { %>
            <div class="task-card">
                <button class="delete-icon" onclick="unbookmarkTask(<%= task.getTaskId() %>)">X</button>
                <div class="task-title"><%= task.getTitle() != null ? task.getTitle() : "Không có tiêu đề" %></div>
                <div class="task-info"><strong>Mô tả:</strong> <%= task.getDescription() != null ? task.getDescription() : "Không có mô tả" %></div>
                <div class="task-info"><strong>Trạng thái:</strong> <%= task.getStatus() != null ? task.getStatus() : "Chưa rõ" %></div>
                <div class="task-info"><strong>Ngày đăng:</strong> <%= task.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(task.getCreatedAt()) : "Chưa rõ" %></div>
                <div class="task-actions">
                    <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=<%= task.getTaskId() %>" class="btn btn-view">Xem chi tiết</a>
                </div>
            </div>
        <% } %>
    </div>
<% } %>
    </div>

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

    <a href="#" class="back-to-top" id="backToTop">
        <i class="fas fa-arrow-up"></i>
    </a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function để hủy ứng tuyển
        function cancelApplication(applicationId) {
            if (confirm('Bạn có chắc muốn hủy ứng tuyển này không?')) {
                fetch('${pageContext.request.contextPath}/tasks', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&application_id=' + applicationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Hiển thị thông báo thành công
                        showAlert('success', data.message);
                        
                        // Cập nhật trạng thái trên giao diện
                        const statusElement = document.getElementById('status-' + applicationId);
                        if (statusElement) {
                            statusElement.textContent = 'cancelled';
                        }
                        
                        // Thay đổi nút "Hủy ứng tuyển" thành nút "X" để xóa
                        const taskCard = document.getElementById('task-card-' + applicationId);
                        if (taskCard) {
                            const cancelButton = taskCard.querySelector('.btn-cancel');
                            if (cancelButton) {
                                cancelButton.remove();
                            }
                            
                            // Thêm nút X để xóa
                            const deleteButton = document.createElement('button');
                            deleteButton.type = 'button';
                            deleteButton.className = 'delete-icon';
                            deleteButton.textContent = 'X';
                            deleteButton.onclick = function() { deleteApplication(applicationId); };
                            taskCard.insertBefore(deleteButton, taskCard.firstChild);
                        }
                    } else {
                        showAlert('error', data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('error', 'Đã có lỗi xảy ra khi hủy ứng tuyển.');
                });
            }
        }

        // Function để xóa ứng tuyển đã hủy
        function deleteApplication(applicationId) {
            if (confirm('Bạn có chắc muốn xóa ứng tuyển này không?')) {
                fetch('${pageContext.request.contextPath}/tasks', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&application_id=' + applicationId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Hiển thị thông báo thành công
                        showAlert('success', data.message);
                        
                        // Xóa task card khỏi giao diện
                        const taskCard = document.getElementById('task-card-' + applicationId);
                        if (taskCard) {
                            taskCard.remove();
                        }
                    } else {
                        showAlert('error', data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('error', 'Đã có lỗi xảy ra khi xóa ứng tuyển.');
                });
            }
        }

        function unbookmarkTask(taskId) {
            if (confirm('Bạn có chắc muốn bỏ thích công việc này không?')) {
                fetch('${pageContext.request.contextPath}/tasks', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=unbookmark&taskId=' + taskId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Tải lại trang sau khi bỏ thích thành công
                        window.location.reload();
                    } else {
                        alert('Có lỗi xảy ra: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Đã có lỗi xảy ra khi bỏ thích công việc.');
                });
            }
        }

        // Function để hiển thị alert động
        function showAlert(type, message) {
            // Tạo alert element
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type}`;
            alertDiv.textContent = message;
            
            // Thêm alert vào đầu container
            const container = document.querySelector('.container');
            container.insertBefore(alertDiv, container.firstChild);
            
            // Tự động ẩn alert sau 5 giây
            setTimeout(() => {
                alertDiv.style.opacity = '0';
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        alertDiv.parentNode.removeChild(alertDiv);
                    }
                }, 300);
            }, 1000);
        }

        // Ẩn alert có sẵn sau 5 giây
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.opacity = '0';
                setTimeout(() => alert.style.display = 'none', 300);
            });
        }, 1000);

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
    </script>
</body>
</html>