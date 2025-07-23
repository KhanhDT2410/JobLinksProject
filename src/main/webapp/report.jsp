<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo - JobLinks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f7fa;
            color: #333;
        }
        .report-page {
            padding: 40px 0;
            margin-top: 80px;
        }
        .report-page h2 {
            text-align: center;
            font-weight: 700;
            font-size: 2.5rem;
            color: #2c3e50;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 30px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .report-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .report-tabs .btn {
            flex: 1;
            padding: 10px;
            font-weight: 500;
        }
        .report-form, .report-list, .duplicate-users {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: 500;
            margin-bottom: 5px;
            display: block;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #b3d7ff;
            border-radius: 6px;
        }
        .form-group textarea {
            resize: vertical;
            height: 100px;
        }
        .report-list table {
            width: 100%;
            border-collapse: collapse;
        }
        .report-list th, .report-list td {
            padding: 10px;
            border: 1px solid #e9ecef;
            text-align: left;
        }
        .report-list th {
            background: #4e73df;
            color: white;
        }
        .btn-submit {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
        }
        .btn-submit:hover {
            background: #218838;
        }
        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
        }
        .duplicate-users {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #e9ecef;
        }
        .duplicate-users ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .duplicate-users li {
            padding: 10px;
            border-bottom: 1px solid #e9ecef;
            cursor: pointer;
            transition: background 0.2s;
        }
        .duplicate-users li:hover {
            background: #f0f0f0;
        }
        .duplicate-users li.selected {
            background: #d1e7dd;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="report-page">
        <%@include file="header-layout.jsp" %>
        <div class="container">
            <h2><i class="fas fa-flag"></i> <strong>BÁO CÁO</strong></h2>

            <c:if test="${empty sessionScope.userId}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> Vui lòng đăng nhập để sử dụng chức năng báo cáo!
                    <a href="login.jsp" class="btn btn-primary">Đăng nhập</a>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.userId}">
                <div class="report-tabs">
                    <button class="btn btn-outline-primary" onclick="showSection('user')">Báo cáo người dùng</button>
                    <button class="btn btn-outline-primary" onclick="showSection('both')">Báo cáo người dùng và task</button>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <c:if test="${not empty matchingUsers}">
                    <div class="duplicate-users">
                        <h4>Có nhiều người dùng trùng tên. Vui lòng chọn:</h4>
                        <ul id="userList">
                            <c:forEach var="user" items="${matchingUsers}">
                                <li onclick="selectUser('${user.userId}', '${user.fullName}')">${user.fullName}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <!-- FORM BÁO CÁO -->
                <div class="report-form" id="reportForm">
                    <form action="report" method="post">
                        <input type="hidden" name="action" value="${action}">
                        <input type="hidden" name="taskId" value="${not empty taskId ? taskId : 0}">
                        
                        <!-- NGƯỜI BỊ BÁO CÁO -->
                        <div class="form-group" id="reportedUserSection">
                            <label>Người bị báo cáo</label>
                            <input type="text" name="reportedName" id="reportedName" value="${reportedName}" placeholder="Nhập tên người bị báo cáo" oninput="normalizeName(this); checkDuplicateUsers()">
                            <input type="hidden" name="reportedId" id="reportedId" value="${not empty reportedId && action != 'task' ? reportedId : 0}">
                        </div>

                        <!-- TASK BỊ BÁO CÁO -->
                        <div class="form-group" id="taskSection" style="display: ${action == 'task' || action == 'both' ? 'block' : 'none'}">
                            <label>Task bị báo cáo</label>
                            <input type="text" name="taskTitle" id="taskTitle" value="${not empty taskTitle ? taskTitle : ''}" placeholder="Nhập tiêu đề task" readonly>
                        </div>

                        <div class="form-group">
                            <label>Lý do báo cáo</label>
                            <select name="reportType" required>
                                <option value="">Chọn lý do</option>
                                <option value="spam">Spam</option>
                                <option value="harassment">Quấy rối</option>
                                <option value="inappropriate_content">Nội dung không phù hợp</option>
                                <option value="other">Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Mô tả chi tiết</label>
                            <textarea name="message" placeholder="Nhập lý do chi tiết..." required></textarea>
                        </div>

                        <button type="submit" class="btn-submit">Gửi báo cáo</button>
                    </form>
                </div>

                <!-- DANH SÁCH BÁO CÁO -->
                <div class="report-list">
                    <h3>Danh sách báo cáo của bạn</h3>
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 10%;">ID</th>
                                <th style="width: 15%;">Người bị báo cáo</th>
                                <th style="width: 15%;">Task</th>
                                <th style="width: 10%;">Lý do</th>
                                <th style="width: 40%;">Mô tả</th>
                                <th style="width: 15%;">Thời gian</th>
                                <th style="width: 10%;">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${reports}">
                                <tr>
                                    <td>${report.reportId}</td>
                                    <td>${report.reportedName != null ? report.reportedName : 'Không xác định'}</td>
                                    <td>${report.taskTitle != null ? report.taskTitle : 'N/A'}</td>
                                    <td>${report.reportType}</td>
                                    <td>${report.message != null ? report.message : 'Chưa có mô tả'}</td>
                                    <td><fmt:formatDate value="${report.reportTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>${report.status}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty reports}">
                                <tr>
                                    <td colspan="7" style="text-align: center;">Bạn chưa gửi báo cáo nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
        <jsp:include page="footer.jsp"/>
    </div>

    <!-- SCRIPT XỬ LÝ -->
    <script>
        function showSection(section) {
            const taskSection = document.getElementById('taskSection');
            const reportedUserSection = document.getElementById('reportedUserSection');
            const duplicateUsers = document.querySelector('.duplicate-users');

            taskSection.style.display = (section === 'task' || section === 'both') ? 'block' : 'none';
            reportedUserSection.style.display = (section === 'task') ? 'none' : 'block';
            if (section === 'task') {
                document.querySelector('input[name="reportedId"]').value = '0'; // Đảm bảo không gửi reportedId khi report task
                duplicateUsers.style.display = 'none';
            }

            const form = document.querySelector('#reportForm form');
            form.action = 'report?action=' + section;
            document.querySelector('input[name="taskId"]').value = "${not empty taskId ? taskId : 0}";
            document.querySelector('input[name="reportedId"]').value = (section === 'task') ? '0' : "${not empty reportedId ? reportedId : 0}";
        }

        function normalizeName(input) {
            let value = input.value.trim().replace(/\s+/g, ' ');
            let words = value.split(' ').map(word =>
                word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
            );
            input.value = words.join(' ');
        }

        function selectUser(userId, fullName) {
            document.getElementById('reportedId').value = userId;
            document.getElementById('reportedName').value = fullName;
            document.querySelector('.duplicate-users').style.display = 'none';
            document.querySelectorAll('#userList li').forEach(li => li.classList.remove('selected'));
            event.target.classList.add('selected');
        }

        function checkDuplicateUsers() {
            const reportedName = document.getElementById('reportedName').value;
            if (reportedName && '${action}' !== 'task') {
                // Gửi yêu cầu AJAX để kiểm tra trùng lặp (giả lập)
                // Trong thực tế, bạn cần tích hợp với servlet hoặc API
                // Đây chỉ là ví dụ, bạn cần triển khai backend tương ứng
                fetch('report?checkDuplicate=' + encodeURIComponent(reportedName), {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    const duplicateUsers = document.querySelector('.duplicate-users');
                    const userList = document.getElementById('userList');
                    if (data.length > 1) {
                        userList.innerHTML = '';
                        data.forEach(user => {
                            const li = document.createElement('li');
                            li.setAttribute('onclick', `selectUser('${user.userId}', '${user.fullName}')`);
                            li.textContent = `${user.fullName} (ID: ${user.userId})`;
                            userList.appendChild(li);
                        });
                        duplicateUsers.style.display = 'block';
                    } else {
                        duplicateUsers.style.display = 'none';
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }

        window.onload = function () {
            showSection('${action}');
            if ('${not empty matchingUsers}' === 'true') {
                document.querySelector('.duplicate-users').style.display = 'block';
            }
        };
    </script>
</body>
</html>