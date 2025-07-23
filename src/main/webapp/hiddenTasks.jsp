<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Công việc đã ẩn - JobLinks</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #2c3e50;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header styles được include từ jobPosterHeader.jsp */
        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Main content styles */
        .main-content {
            flex: 1;
            padding: 2rem 0;
            min-height: calc(100vh - 200px);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid #dc3545;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: #dc3545;
        }

        .tasks-section {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tasks-stats {
            background: #e3f2fd;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: #1976d2;
        }

        .no-tasks {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .no-tasks i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #dee2e6;
        }

        .task-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .task-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e9ecef;
        }

        .task-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .task-id {
            background: #f8f9fa;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #6c757d;
            font-weight: 500;
        }

        .task-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-label {
            font-weight: 600;
            color: #495057;
            min-width: 100px;
        }

        .detail-value {
            color: #2c3e50;
        }

        .budget-value {
            color: #28a745;
            font-weight: 600;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-hidden {
            background: #ffeaa7;
            color: #d63031;
        }

        .task-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .actions-section {
            text-align: center;
            padding: 2rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            
            .page-header h1 {
                font-size: 2rem;
            }
            
            .task-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .task-details {
                grid-template-columns: 1fr;
            }
            
            .btn {
                padding: 0.5rem 1rem;
                font-size: 0.85rem;
            }
        }

        /* Animation cho page load */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <%@include file="jobPosterHeader.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header fade-in">
                <h1><i class="fas fa-eye-slash"></i> Công việc đã ẩn</h1>
                <p>Quản lý các công việc đã được ẩn khỏi danh sách chính</p>
            </div>

            <!-- Error Display -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger fade-in">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Lỗi:</strong> ${error}
                </div>
            </c:if>

            <!-- Tasks Section -->
            <div class="tasks-section fade-in">
                <h2 class="section-title">
                    <i class="fas fa-list"></i>
                    Danh sách Công việc Đã Ẩn
                </h2>
                
                <c:choose>
                    <c:when test="${empty tasks}">
                        <div class="no-tasks">
                            <i class="fas fa-inbox"></i>
                            <h3>Không có công việc nào đã ẩn</h3>
                            <p>Tất cả công việc của bạn đang được hiển thị công khai</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="tasks-stats">
                            <div class="stats-number">${tasks.size()}</div>
                            <div>công việc đã ẩn</div>
                        </div>
                        
                        <div class="tasks-list">
                            <c:forEach var="task" items="${tasks}" varStatus="status">
                                <div class="task-item fade-in" style="animation-delay: ${status.index * 0.1}s">
                                    <div class="task-header">
                                        <div>
                                            <h3 class="task-title">
                                                <i class="fas fa-briefcase"></i>
                                                ${task.title}
                                            </h3>
                                            <span class="task-id">ID: ${task.taskId}</span>
                                        </div>
                                        <span class="status-badge status-hidden">
                                            <i class="fas fa-eye-slash"></i>
                                            Đã ẩn
                                        </span>
                                    </div>
                                    
                                    <div class="task-details">
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-align-left"></i>
                                                Mô tả:
                                            </span>
                                            <span class="detail-value">${task.description}</span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-tags"></i>
                                                Danh mục:
                                            </span>
                                            <span class="detail-value">${task.categoryName}</span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-user"></i>
                                                Khách hàng:
                                            </span>
                                            <span class="detail-value">${task.clientName}</span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-map-marker-alt"></i>
                                                Địa điểm:
                                            </span>
                                            <span class="detail-value">${task.location}</span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-dollar-sign"></i>
                                                Ngân sách:
                                            </span>
                                            <span class="detail-value budget-value">
                                                <fmt:formatNumber value="${task.budget}" type="currency" currencySymbol="₫"/>
                                            </span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-clock"></i>
                                                Thời gian:
                                            </span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${task.scheduledTime}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-info-circle"></i>
                                                Trạng thái:
                                            </span>
                                            <span class="detail-value">${task.status}</span>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <span class="detail-label">
                                                <i class="fas fa-calendar-plus"></i>
                                                Ngày tạo:
                                            </span>
                                            <span class="detail-value">
                                                <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="task-actions">
                                        <form method="post" action="${pageContext.request.contextPath}/unhideTask" style="display: inline;">
                                            <input type="hidden" name="taskId" value="${task.taskId}">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-eye"></i>
                                                Hiện lại
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Actions Section -->
            <div class="actions-section">
                <a href="${pageContext.request.contextPath}/loadJobPoster" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        </div>
    </div>
    
    <%@include file="jobPosterFooter.jsp" %>
</body>
</html>