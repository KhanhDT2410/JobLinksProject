<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
            margin: 0; /* Đảm bảo không có margin mặc định từ body */
            padding: 0;
        }
        /* Đẩy nội dung xuống dưới header */
        .content-wrapper {
            margin-top: 130px; /* Điều chỉnh dựa trên chiều cao của header (giả sử 80px) */
            padding: 0 15px;
        }
        .container {
            max-width: 1400px;
            margin-top: 0; /* Loại bỏ margin-top mặc định nếu có */
        }
        .comparison-table {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .comparison-table th, .comparison-table td {
            vertical-align: middle;
            text-align: center;
            padding: 12px;
        }
        .comparison-table th {
            background-color: #007bff;
            color: white;
            font-weight: 600;
        }
        .comparison-table td {
            font-size: 0.95rem;
        }
        .btn-remove {
            transition: background-color 0.3s;
        }
        .btn-remove:hover {
            background-color: #dc3545;
            color: white;
        }
        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            display: none;
            z-index: 1000;
        }
        .alert {
            margin-bottom: 20px;
        }
        /* Nếu header dùng position: fixed */
        header {
            position: fixed; /* Giả định header có fixed, nếu không thì bỏ dòng này */
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <jsp:include page="header-layout.jsp" />
    <div class="content-wrapper">
        <div class="container">
            <h2 class="text-center mb-4">${pageTitle}</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${empty tasksToCompare}">
                    <div class="alert alert-info text-center">
                        Không có công việc nào trong danh sách so sánh. 
                        <a href="${pageContext.request.contextPath}/tasks?action=list" class="alert-link">Quay lại danh sách công việc</a>.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bordered comparison-table">
                            <thead>
                                <tr>
                                    <th>Tiêu đề công việc</th>
                                    <th>Ngân sách (VND)</th>
                                    <th>Địa điểm</th>
                                    <th>Danh mục</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian dự kiến</th>
                                    <th>Số lượng ứng tuyển</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${tasksToCompare}">
                                    <tr>
                                        <td><c:out value="${task.title}" /></td>
                                        <td><fmt:formatNumber value="${task.budget}" type="currency" currencySymbol="VND " /></td>
                                        <td><c:out value="${task.location}" /></td>
                                        <td><c:out value="${task.categoryName != null ? task.categoryName : 'Chưa xác định'}" /></td>
                                        <td><c:out value="${task.status}" /></td>
                                        <td><fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy" /></td>
                                        <td><c:out value="${task.applicationCount}" /></td>
                                        <td>
                                            <button class="btn btn-danger btn-sm btn-remove" onclick="removeFromComparison(${task.taskId}, this)">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/tasks?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách công việc
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <button onclick="scrollToTop()" class="btn btn-primary back-to-top">
        <i class="fas fa-arrow-up"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Back to top button
        window.onscroll = function() {
            let button = document.querySelector('.back-to-top');
            if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
                button.style.display = 'block';
            } else {
                button.style.display = 'none';
            }
        };

        function scrollToTop() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger') + ' position-fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.zIndex = '9999';
            notification.style.maxWidth = '400px';
            notification.textContent = message;
            document.body.appendChild(notification);
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 3000);
        }

        function removeFromComparison(taskId, btn) {
            const userId = '<c:out value="${sessionScope.userId}" default="null"/>';
            if (userId === 'null' || !userId) {
                showNotification("Vui lòng đăng nhập để sử dụng chức năng này.", 'error');
                return;
            }
            fetch('${pageContext.request.contextPath}/TaskServlet2', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=removeFromComparison&taskId=' + encodeURIComponent(taskId) + '&userId=' + encodeURIComponent(userId)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('HTTP error, status = ' + response.status + ', response: ' + text);
                    });
                }
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    return response.text().then(text => {
                        throw new Error('Phản hồi không phải JSON: ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    btn.closest('tr').remove();
                    showNotification(data.message, 'success');
                    if (document.querySelectorAll('.comparison-table tbody tr').length === 0) {
                        window.location.reload();
                    }
                } else {
                    showNotification(data.message || 'Thao tác thất bại', 'error');
                }
            })
            .catch(error => {
                console.error('Lỗi AJAX:', error);
                showNotification('Đã xảy ra lỗi: ' + error.message, 'error');
            });
        }
    </script>
</body>
</html>