<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Công việc</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #1cc88a;
                --danger-color: #e74a3b;
                --warning-color: #f6c23e;
                --light-color: #f8f9fc;
                --dark-color: #5a5c69;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Nunito', sans-serif;
                background-color: #f8f9fc;
                color: #333;
                line-height: 1.6;
            }

            /* Thay thế phần CSS trong jobPoster.jsp từ dòng 85-115 */
            .header {
                background-color: white;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
                padding: 1rem 0;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .header-container {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
            }

            /* Sửa lại CSS cho header content để căn chỉnh đúng */
            .header .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .logo-img {
                height: 40px;
            }

            .logo-text {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-color);
            }

            .menu {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .user-menu {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .user-greeting {
                font-weight: 600;
                color: var(--dark-color);
            }

            .menu-link {
                color: var(--dark-color);
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 5px;
                transition: color 0.3s;
            }

            .menu-link:hover {
                color: var(--primary-color);
            }

            .btn-logout {
                color: var(--danger-color);
            }

            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 0 20px;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .page-title {
                font-size: 1.75rem;
                color: var(--dark-color);
                font-weight: 700;
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
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
            }

            .btn-primary:hover {
                background-color: #2e59d9;
                transform: translateY(-1px);
            }

            .btn-danger {
                background-color: var(--danger-color);
                color: white;
            }

            .btn-danger:hover {
                background-color: #be2617;
            }

            .btn-secondary {
                background-color: var(--secondary-color);
                color: white;
            }

            .btn-secondary:hover {
                background-color: #17a673;
            }

            .card {
                background-color: white;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
                margin-bottom: 30px;
                overflow: hidden;
            }

            .card-header {
                padding: 1rem 1.35rem;
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                font-weight: 700;
                color: var(--dark-color);
            }

            .card-body {
                padding: 1.35rem;
            }

            .task-item {
                padding: 1rem 0;
                border-bottom: 1px solid #e3e6f0;
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

            .task-item:last-child {
                border-bottom: none;
            }

            .task-info {
                flex: 1;
                min-width: 300px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .task-title {
                font-weight: 700;
                color: var(--primary-color);
                margin-bottom: 0.5rem;
            }

            .task-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-top: 10px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 5px;
                color: var(--dark-color);
                font-size: 0.9rem;
            }

            .task-status {
                padding: 0.25rem 0.5rem;
                border-radius: 0.25rem;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
            }

            .status-pending {
                background-color: #f6c23e;
                color: white;
            }
            .status-active {
                background-color: #1cc88a;
                color: white;
            }
            .status-completed {
                background-color: #36b9cc;
                color: white;
            }
            .status-cancelled {
                background-color: #e74a3b;
                color: white;
            }
            .status-hidden {
                background-color: #6c757d;
                color: white;
            } /* Thêm trạng thái cho task ẩn */

            .task-actions {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .alert {
                padding: 1rem;
                border-radius: 0.35rem;
                margin-bottom: 1rem;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .empty-state {
                text-align: center;
                padding: 2rem;
                color: var(--dark-color);
            }

            .empty-state i {
                font-size: 3rem;
                color: #dddfeb;
                margin-bottom: 1rem;
            }

            .footer {
                background-color: white;
                padding: 1.5rem;
                text-align: center;
                color: var(--dark-color);
                font-size: 0.9rem;
                border-top: 1px solid #e3e6f0;
                margin-top: 2rem;
            }

            @media (max-width: 768px) {
                .task-item {
                    flex-direction: column;
                    gap: 15px;
                }
                .task-actions {
                    width: 100%;
                    justify-content: flex-end;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="jobPosterHeader.jsp" %>

        <main class="container">
            <div class="page-header">
                <div>
                    <h1 class="page-title">Quản lý Công việc</h1>
                </div>
                <a href="${pageContext.request.contextPath}/loadJobPoster?view=post" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Đăng công việc mới
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <!-- Danh sách công việc -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-tasks"></i> Danh sách công việc của bạn
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <div class="empty-state">
                                <i class="fas fa-tasks"></i>
                                <h3>Chưa có công việc nào</h3>
                                <p>Bạn chưa đăng công việc nào. Hãy bắt đầu bằng cách đăng công việc mới.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${tasks}">
                                <div class="task-item" id="task-${task.taskId}">
                                    <div class="task-info">
                                        <h3 class="task-title">${task.title}</h3>
                                        <p>${task.description}</p>
                                        <div class="task-meta">
                                            <span class="meta-item"><i class="fas fa-map-marker-alt"></i> ${task.location}</span>
                                            <span class="meta-item"><i class="fas fa-clock"></i> ${task.scheduledTime}</span>
                                            <span class="meta-item"><i class="fas fa-money-bill-wave"></i> ${task.budget} VND</span>
                                            <span class="meta-item">
                                                <span class="task-status status-${task.status.toLowerCase()}">
                                                    ${task.status}
                                                    <c:if test="${task.isHidden == 1}"> (Đã ẩn)</c:if>
                                                    </span>
                                                </span>
                                            </div>
                                            <div class="task-actions">
                                                <a href="${pageContext.request.contextPath}/loadJobPoster?view=edit&taskId=${task.taskId}&title=${fn:escapeXml(task.title)}" class="btn btn-secondary">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <c:choose>
                                                <c:when test="${task.isHidden == 0}">
                                                    <a href="${pageContext.request.contextPath}/loadJobPoster?view=hide&taskId=${task.taskId}&title=${fn:escapeXml(task.title)}" class="btn btn-danger">
                                                        <i class="fas fa-eye-slash"></i> Ẩn
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/unhideTask?taskId=${task.taskId}" class="btn btn-secondary">
                                                        <i class="fas fa-eye"></i> Hiển thị lại
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Trong phần danh sách ứng tuyển -->
                                        <c:if test="${not empty applications[task.taskId] and task.status != 'COMPLETED'}">
                                            <div class="card" style="margin-top: 15px;">
                                                <div class="card-header">
                                                    <i class="fas fa-users"></i> Ứng tuyển (${fn:length(applications[task.taskId])})
                                                </div>
                                                <div class="card-body">
                                                    <c:forEach var="app" items="${applications[task.taskId]}">
                                                        <div class="task-item">
                                                            <div class="task-info">
                                                                <p><strong>Ứng viên:</strong> ${app.workerName}</p>
                                                                <p><strong>Thông điệp:</strong> ${app.message}</p>
                                                                <span class="meta-item"><i class="fas fa-clock"></i> ${app.appliedAt}</span>
                                                                <span class="task-status status-${app.status.toLowerCase()}">${app.status}</span>
                                                            </div>
                                                            <div class="task-actions">
                                                                <c:if test="${app.status == 'pending'}">
                                                                    <a href="${pageContext.request.contextPath}/manageApplication?action=accept&applicationId=${app.applicationId}&taskId=${task.taskId}" class="btn btn-secondary">
                                                                        <i class="fas fa-check"></i> Chấp thuận
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/manageApplication?action=reject&applicationId=${app.applicationId}&taskId=${task.taskId}" class="btn btn-danger">
                                                                        <i class="fas fa-times"></i> Từ chối
                                                                    </a>
                                                                </c:if>
                                                                <a href="${pageContext.request.contextPath}/viewProfile?workerId=${app.workerId}" class="btn btn-primary">
                                                                    <i class="fas fa-eye"></i> Xem hồ sơ
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/sendMessage?receiverId=${app.workerId}" class="btn btn-secondary">
                                                                    <i class="fas fa-comments"></i> Nhắn tin
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <!-- Danh sách công việc cần xác nhận hoàn thành -->
            <!-- Danh sách công việc cần xác nhận hoàn thành -->
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-check-circle"></i> Công việc cần xác nhận hoàn thành
                </div>
                <div class="card-body">
                    <c:set var="hasPendingTasks" value="false"/>
                    <c:forEach var="task" items="${tasksWaitingForPayment}">
                        <c:set var="hasPendingTasks" value="true"/>
                        <div class="task-item" id="task-${task.taskId}">
                            <div class="task-info">
                                <h3 class="task-title">${task.title}</h3>
                                <p>${task.description}</p>
                                <div class="task-meta">
                                    <span class="meta-item"><i class="fas fa-map-marker-alt"></i> ${task.location}</span>
                                    <span class="meta-item"><i class="fas fa-clock"></i> ${task.scheduledTime}</span>
                                    <span class="meta-item"><i class="fas fa-money-bill-wave"></i> ${task.budget} VND</span>
                                    <span class="meta-item">
                                        <span class="task-status status-completed">COMPLETED_BY_WORKER</span>
                                    </span>
                                </div>
                                <div class="task-actions">
                                    <!-- Thay đổi từ link sang form -->
                                    <form action="${pageContext.request.contextPath}/confirmCompletion" 
                                          method="post" 
                                          class="d-inline"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận thanh toán không?');">
                                        <input type="hidden" name="taskId" value="${task.taskId}">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-check"></i> Xác nhận và thanh toán
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${!hasPendingTasks}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>Không có công việc nào cần xác nhận</h3>
                            <p>Hiện tại không có công việc nào được worker xác nhận hoàn thành.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
        <%@include file="jobPosterFooter.jsp" %>
    </body>
</html>