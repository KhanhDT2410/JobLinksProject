<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Boost Task</title>
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
        .container1 {
            max-width: 1200px;
            flex: 1 0 auto;
        }
        .middle {
            margin-top: 140px;
        }
        .user-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            color: white;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .user-info-card .balance {
            font-size: 1.5rem;
            font-weight: bold;
            color: #fff3cd;
        }
        .table {
            margin-top: 20px;
            background-color: #e6f3ff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .table th, .table td {
            padding: 12px;
            text-align: left;
            color: #333;
            vertical-align: middle;
        }
        .table th {
            background-color: #d1e7ff;
        }
        .table tr:nth-child(even) {
            background-color: #f0f8ff;
        }
        .error {
            color: #dc3545;
            font-weight: bold;
        }
        .success {
            color: #28a745;
            font-weight: bold;
        }
        .btn-boost {
            background-color: #6e8efb;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-boost:hover {
            background-color: #5d7ce0;
            transform: translateY(-1px);
        }
        .btn-boost:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
            transform: none;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-boosted {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-normal {
            background-color: #f8f9fa;
            color: #6c757d;
            border: 1px solid #dee2e6;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        .no-js-warning {
            display: none;
            color: #dc3545;
            font-weight: bold;
            margin-top: 10px;
        }
        .no-tasks {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 40px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-top: 20px;
        }
        .modal-content {
            background-color: #e6f3ff;
            border-radius: 8px;
        }
        .modal-header {
            background-color: #d1e7ff;
            border-bottom: 1px solid #b3d7ff;
        }
        .modal-title {
            color: #333;
        }
        .modal-body {
            color: #333;
            font-size: 1rem;
        }
        .modal-body strong {
            color: #1a5f9f;
        }
        .modal-footer {
            border-top: 1px solid #b3d7ff;
        }
        .modal-footer .btn-primary {
            background-color: #6e8efb;
            border: none;
        }
        .modal-footer .btn-primary:hover {
            background-color: #5d7ce0;
        }
        .modal-footer .btn-secondary {
            background-color: #6c757d;
            border: none;
        }
        .modal-footer .btn-secondary:hover {
            background-color: #5a6268;
        }
        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.9rem;
            }
            .btn-boost {
                padding: 4px 8px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <%@include file="header-layout.jsp" %>

    <div class="container1 container">
        <div class="middle">
            <h1 class="text-center mb-4">
                <i class="fas fa-rocket me-2"></i>Quản Lý Boost Task
            </h1>
            
            <!-- User Info Card -->
            <c:if test="${not empty userName}">
                <div class="user-info-card">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h5 class="mb-1"><i class="fas fa-user me-2"></i>Chào mừng, ${userName}!</h5>
                            <p class="mb-0">Quản lý và đẩy các task đang chờ (PENDING) lên đầu danh sách</p>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <div class="balance">
                                <i class="fas fa-wallet me-2"></i>
                                <fmt:formatNumber value="${userBalance}" type="currency" currencyCode="VND"/>
                            </div>
                            <small>Số dư hiện tại</small>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Tasks Table -->
            <c:choose>
                <c:when test="${not empty userTasks}">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th><i class="fas fa-hashtag me-1"></i>ID</th>
                                    <th><i class="fas fa-tasks me-1"></i>Tiêu đề</th>
                                    <th><i class="fas fa-info-circle me-1"></i>Trạng thái</th>
                                    <th><i class="fas fa-calendar-plus me-1"></i>Thời gian tạo</th>
                                    <th><i class="fas fa-rocket me-1"></i>Trạng thái Boost</th>
                                    <th><i class="fas fa-clock me-1"></i>Thời gian hết hạn boost</th>
                                    <th><i class="fas fa-cogs me-1"></i>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${userTasks}">
                                    <tr>
                                        <td><strong>${task.taskId}</strong></td>
                                        <td>
                                            <c:out value="${task.title}"/>
                                            <c:if test="${task.boosted}">
                                                <i class="fas fa-star text-warning ms-2" title="Task đã được boost"></i>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="status-badge status-pending">
                                                <i class="fas fa-hourglass-half me-1"></i>PENDING
                                            </span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.boosted}">
                                                    <span class="status-badge status-boosted">
                                                        <i class="fas fa-rocket me-1"></i>Đã boost
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-normal">
                                                        <i class="fas fa-circle me-1"></i>Chưa boost
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty task.boostExpiry}">
                                                    <fmt:formatDate value="${task.boostExpiry}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.boosted}">
                                                    <button type="button" class="btn-boost" disabled>
                                                        <i class="fas fa-check me-1"></i>Đã boost
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <form id="boostForm-${task.taskId}" action="${pageContext.request.contextPath}/boostTask" method="post" onsubmit="return false;">
                                                        <input type="hidden" name="taskId" value="${task.taskId}"/>
                                                        <input type="hidden" name="action" value="boost"/>
                                                        <button type="button" class="btn-boost" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#confirmBoostModal" 
                                                                data-task-id="${task.taskId}" 
                                                                data-task-title="${task.title}"
                                                                data-user-balance="${userBalance}">
                                                            <i class="fas fa-rocket me-1"></i>Đẩy lên đầu
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Summary Info -->
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body text-center">
                                    <h5 class="card-title text-primary">
                                        <i class="fas fa-list me-2"></i>Tổng số task (PENDING)
                                    </h5>
                                    <h3 class="text-dark">${userTasks.size()}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body text-center">
                                    <h5 class="card-title text-success">
                                        <i class="fas fa-rocket me-2"></i>Task đã boost
                                    </h5>
                                    <h3 class="text-dark">
                                        <c:set var="boostedCount" value="0"/>
                                        <c:forEach var="task" items="${userTasks}">
                                            <c:if test="${task.boosted}">
                                                <c:set var="boostedCount" value="${boostedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${boostedCount}
                                    </h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-tasks">
                        <i class="fas fa-inbox fs-1 mb-3 text-muted"></i>
                        <h4>Chưa có công việc nào đang chờ</h4>
                        <p>Bạn chưa có công việc nào ở trạng thái PENDING để boost. Hãy tạo task mới trước!</p>
                        <a href="${pageContext.request.contextPath}/createTask" class="btn btn-primary mt-3">
                            <i class="fas fa-plus me-2"></i>Tạo Task Mới
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Confirmation Modal -->
            <div class="modal fade" id="confirmBoostModal" tabindex="-1" aria-labelledby="confirmBoostModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="confirmBoostModalLabel">
                                <i class="fas fa-rocket me-2"></i>Xác nhận đẩy task
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <p>Bạn có chắc chắn muốn đẩy task <strong id="modalTaskTitle"></strong> (ID: <strong id="modalTaskId"></strong>) lên đầu không?</p>
                            </div>
                            <div class="row">
                                <div class="col-6">
                                    <div class="card bg-light">
                                        <div class="card-body text-center">
                                            <h6 class="card-title">Phí boost</h6>
                                            <h5 class="text-danger">
                                                <fmt:formatNumber value="50000" type="currency" currencyCode="VND"/>
                                            </h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="card bg-light">
                                        <div class="card-body text-center">
                                            <h6 class="card-title">Số dư hiện tại</h6>
                                            <h5 class="text-primary" id="modalUserBalance">
                                                <fmt:formatNumber value="${userBalance}" type="currency" currencyCode="VND"/>
                                            </h5>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="alert alert-info mt-3" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                Task sẽ được đẩy lên đầu danh sách và được ưu tiên hiển thị.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Hủy
                            </button>
                            <button type="button" class="btn btn-primary" id="confirmBoostButton">
                                <i class="fas fa-rocket me-1"></i>Xác nhận Boost
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- JavaScript Warning -->
            <noscript>
                <div class="alert alert-warning mt-3">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    JavaScript bị vô hiệu hóa. Vui lòng bật JavaScript để sử dụng chức năng xác nhận đẩy task.
                </div>
            </noscript>
        </div>
    </div>

    <!-- Footer -->
    <%@include file="footer.jsp" %>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('confirmBoostModal').addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const taskId = button.getAttribute('data-task-id');
            const taskTitle = button.getAttribute('data-task-title');
            const userBalance = parseFloat(button.getAttribute('data-user-balance') || 0);
            const boostFee = 50000;
            
            document.getElementById('modalTaskId').textContent = taskId;
            document.getElementById('modalTaskTitle').textContent = taskTitle;
            
            const confirmButton = document.getElementById('confirmBoostButton');
            confirmButton.setAttribute('data-form-id', 'boostForm-' + taskId);
            
            if (userBalance < boostFee) {
                confirmButton.disabled = true;
                confirmButton.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i>Số dư không đủ';
                confirmButton.classList.remove('btn-primary');
                confirmButton.classList.add('btn-danger');
                
                const alertHtml = `
                    <div class="alert alert-danger mt-3" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Số dư không đủ để boost task này. Vui lòng nạp thêm tiền.
                    </div>
                `;
                const existingAlert = document.querySelector('#confirmBoostModal .alert-danger');
                if (!existingAlert) {
                    document.querySelector('#confirmBoostModal .modal-body').insertAdjacentHTML('beforeend', alertHtml);
                }
            } else {
                confirmButton.disabled = false;
                confirmButton.innerHTML = '<i class="fas fa-rocket me-1"></i>Xác nhận Boost';
                confirmButton.classList.remove('btn-danger');
                confirmButton.classList.add('btn-primary');
                
                const existingAlert = document.querySelector('#confirmBoostModal .alert-danger');
                if (existingAlert) {
                    existingAlert.remove();
                }
            }
        });

        document.getElementById('confirmBoostButton').addEventListener('click', function () {
            if (this.disabled) return;
            
            const formId = this.getAttribute('data-form-id');
            const form = document.getElementById(formId);
            if (form) {
                this.disabled = true;
                this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                form.onsubmit = null;
                form.submit();
            } else {
                console.error('Form not found: ' + formId);
                alert('Có lỗi xảy ra. Vui lòng thử lại.');
            }
        });
        
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert:not(.alert-info)');
            alerts.forEach(function(alert) {
                if (alert.querySelector('.btn-close')) {
                    const bootstrapAlert = new bootstrap.Alert(alert);
                    bootstrapAlert.close();
                }
            });
        }, 5000);
    </script>
</body>
</html>