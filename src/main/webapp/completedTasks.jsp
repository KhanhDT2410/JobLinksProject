<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Đã Hoàn Thành</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #1cc88a;
--danger-color: #e74a3b;
            --warning-color: #f6c23e;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
            --info-color: #36b9cc;
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
            padding: 2rem 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-title {
            font-size: 1.75rem;
            color: var(--dark-color);
            font-weight: 700;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .breadcrumb a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: var(--dark-color);
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
            font-size: 0.9rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #2e59d9;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #17a673;
        }

        .btn-info {
            background-color: var(--info-color);
            color: white;
        }

        .btn-info:hover {
            background-color: #2c9faf;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 1.35rem;
        }

        .task-item {
            padding: 1.5rem 0;
            border-bottom: 1px solid #e3e6f0;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .task-item:last-child {
            border-bottom: none;
        }

        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
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
            font-size: 1.1rem;
        }

        .task-description {
            color: var(--dark-color);
            margin-bottom: 1rem;
            line-height: 1.5;
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
            padding: 0.25rem 0.5rem;
            background-color: #f8f9fc;
            border-radius: 0.25rem;
        }

        .meta-item i {
            color: var(--primary-color);
        }

        .meta-item.review-deadline {
            background-color: #fff3cd;
            color: #856404;
        }

        .meta-item.review-deadline.expired {
            background-color: #f8d7da;
            color: #721c24;
        }

        .task-status {
            padding: 0.35rem 0.75rem;
            border-radius: 0.25rem;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-completed {
            background-color: var(--info-color);
            color: white;
        }

        .task-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.35rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--dark-color);
        }

        .empty-state i {
            font-size: 4rem;
            color: #dddfeb;
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }

        .empty-state p {
            font-size: 1rem;
            color: #858796;
        }

        .applications-section {
            margin-top: 1.5rem;
            border-top: 1px solid #e3e6f0;
            padding-top: 1.5rem;
        }

        .applications-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            color: var(--dark-color);
            font-weight: 600;
        }

        .application-item {
            background-color: #f8f9fc;
            border-radius: 0.35rem;
            padding: 1rem;
            margin-bottom: 1rem;
            border-left: 4px solid var(--primary-color);
        }

        .application-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .worker-name {
            font-weight: 600;
            color: var(--dark-color);
        }

        .application-message {
            margin: 0.5rem 0;
            color: var(--dark-color);
            font-style: italic;
        }

        .application-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            font-size: 0.85rem;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal.show {
            display: flex;
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background: white;
            padding: 2rem;
            width: 90%;
            max-width: 500px;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.2);
            position: relative;
            animation: slideIn 0.3s ease-in-out;
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .modal-title {
            font-size: 1.5rem;
            color: var(--dark-color);
            font-weight: 700;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--dark-color);
            padding: 0.5rem;
            border-radius: 50%;
            transition: background-color 0.3s;
        }

        .modal-close:hover {
            background-color: #f8f9fc;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .form-textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e3e6f0;
            border-radius: 0.35rem;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
            font-size: 0.9rem;
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .star-rating {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .star-rating i {
            font-size: 1.5rem;
            color: #dddfeb;
            cursor: pointer;
            transition: color 0.3s;
        }

        .star-rating i:hover,
        .star-rating i.active {
            color: var(--warning-color);
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
        }

        .loading {
            pointer-events: none;
            opacity: 0.6;
        }

        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .task-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .task-actions {
                width: 100%;
                justify-content: flex-start;
            }

            .modal-content {
                width: 95%;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <%@include file="jobPosterHeader.jsp" %>

    <div class="main-content">
        <div class="container">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <span class="breadcrumb-separator">/</span>
                <span>Task Đã Hoàn Thành</span>
            </div>

            <div class="page-header">
                <h1 class="page-title">
                    <i class="fas fa-check-circle"></i> Task Đã Hoàn Thành
                </h1>
            </div>

<c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${param.error}</span>
                <button type="button" class="alert-close" onclick="this.parentElement.style.display='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </c:if>

        <!-- Thông báo thành công -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible auto-hide">
                <i class="fas fa-check-circle"></i>
                <span>${param.success}</span>
                <button type="button" class="alert-close" onclick="this.parentElement.style.display='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </c:if>

        <!-- Thông báo cảnh báo -->
        <div class="alert alert-warning">
            <i class="fas fa-info-circle"></i>
            <span>Lưu ý: Bạn chỉ có 7 ngày sau khi công việc hoàn thành để gửi đánh giá.</span>
        </div>

            <div class="card">
                <div class="card-header">
                    <i class="fas fa-list-check"></i>
                    <span>Danh sách Task Đã Hoàn Thành</span>
                    <c:if test="${not empty completedTasks}">
                        <span style="margin-left: auto; background-color: var(--info-color); color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.8rem;">
                            ${fn:length(completedTasks)} task
                        </span>
                    </c:if>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty completedTasks}">
                            <div class="empty-state">
                                <i class="fas fa-check-circle"></i>
                                <h3>Chưa có task nào hoàn thành</h3>
                                <p>Bạn chưa hoàn thành bất kỳ công việc nào. Hãy tạo và hoàn thành các task để xem chúng ở đây.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${completedTasks}">
                                <div class="task-item">
                                    <div class="task-header">
                                        <div class="task-info">
                                            <h3 class="task-title">
                                                <i class="fas fa-briefcase"></i> ${task.title}
                                            </h3>
                                            <div class="task-description">${task.description}</div>
                                            
                                            <div class="task-meta">
                                                <div class="meta-item">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <span>${task.location}</span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="fas fa-clock"></i>
                                                    <span><fmt:formatDate value="${task.scheduledTime}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                </div>
                                                <div class="meta-item">
                                                    <i class="fas fa-money-bill-wave"></i>
                                                    <span><fmt:formatNumber value="${task.budget}" type="currency" currencySymbol="₫"/></span>
                                                </div>
                                                <span class="task-status status-completed">
                                                    <i class="fas fa-check"></i> Hoàn thành
                                                </span>
                                                <c:if test="${task.canReview && task.acceptedWorkerId != 0}">
                                                    <div class="meta-item review-deadline ${task.daysRemaining < 0 ? 'expired' : ''}">
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span>
                                                            <c:choose>
                                                                <c:when test="${task.daysRemaining >= 0}">
                                                                    Còn ${task.daysRemaining} ngày để gửi đánh giá
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Đã hết hạn đánh giá
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <div class="task-actions">
                                                <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=${task.taskId}" class="btn btn-primary">
                                                    <i class="fas fa-eye"></i> Xem chi tiết
                                                </a>
                                            <c:if test="${task.canReview && task.acceptedWorkerId != 0 && task.daysRemaining >= 0}">
                                                <button class="btn btn-primary review-btn" 
                                                        data-task-id="${task.taskId}" 
                                                        data-worker-id="${task.acceptedWorkerId}">
                                                    <i class="fas fa-star"></i> Đánh giá
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>

                                    <c:if test="${not empty applications[task.taskId]}">
                                        <div class="applications-section">
                                            <div class="applications-header">
                                                <i class="fas fa-users"></i>
                                                <span>Danh sách ứng tuyển (${fn:length(applications[task.taskId])})</span>
                                            </div>
                                            
                                            <c:forEach var="app" items="${applications[task.taskId]}">
                                                <div class="application-item">
                                                    <div class="application-header">
                                                        <div class="worker-name">
                                                            <i class="fas fa-user"></i> ${app.workerName}
                                                        </div>
                                                        <span class="task-status status-${app.status.toLowerCase()}">
                                                            ${app.status}
                                                        </span>
                                                    </div>
                                                    
                                                    <c:if test="${not empty app.message}">
                                                        <div class="application-message">
                                                            <i class="fas fa-quote-left"></i> "${app.message}"
                                                        </div>
                                                    </c:if>
                                                    
                                                    <div class="application-meta">
                                                        <div class="meta-item">
                                                            <i class="fas fa-calendar-alt"></i>
                                                            <span>Ứng tuyển lúc: <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal đánh giá -->
    <div id="reviewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Đánh giá công việc</h3>
                <button type="button" class="modal-close" onclick="closeReviewModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="reviewForm" method="post" action="${pageContext.request.contextPath}/submitReview">
                <input type="hidden" name="task_id" id="taskIdInput">
                <input type="hidden" name="reviewee_id" id="revieweeIdInput">
                <input type="hidden" name="rating" id="ratingInput" value="0">
                
                <div class="form-group">
                    <label class="form-label">Điểm đánh giá:</label>
                    <div class="star-rating" id="starRating">
                        <i class="fas fa-star" data-value="1"></i>
                        <i class="fas fa-star" data-value="2"></i>
                        <i class="fas fa-star" data-value="3"></i>
                        <i class="fas fa-star" data-value="4"></i>
                        <i class="fas fa-star" data-value="5"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Bình luận:</label>
                    <textarea name="comment" class="form-textarea" rows="4" placeholder="Nhập bình luận của bạn..." required></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeReviewModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>

    <%@include file="jobPosterFooter.jsp" %>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Review modal functionality
            const reviewModal = document.getElementById('reviewModal');
            const reviewForm = document.getElementById('reviewForm');
            const reviewBtns = document.querySelectorAll('.review-btn');
            const starRating = document.getElementById('starRating');
            const ratingInput = document.getElementById('ratingInput');
            const viewDetailBtns = document.querySelectorAll('.view-detail-btn');

            // Add loading state to view detail buttons
            viewDetailBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    this.classList.add('loading');
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...';
                });
            });

            // Review button click handlers
            reviewBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const taskId = this.dataset.taskId;
                    const workerId = this.dataset.workerId;
                    openReviewModal(taskId, workerId);
                });
            });

            // Star rating functionality
            if (starRating) {
                const stars = starRating.querySelectorAll('i');
                stars.forEach((star, index) => {
                    star.addEventListener('click', function() {
                        const rating = this.dataset.value;
                        ratingInput.value = rating;
                        updateStarRating(rating);
                    });

                    star.addEventListener('mouseenter', function() {
                        const rating = this.dataset.value;
                        updateStarRating(rating);
                    });
                });

                starRating.addEventListener('mouseleave', function() {
                    const currentRating = ratingInput.value;
                    updateStarRating(currentRating);
                });
            }

            function updateStarRating(rating) {
                const stars = starRating.querySelectorAll('i');
                stars.forEach((star, index) => {
                    if (index < rating) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });
            }

            // Modal close on background click
            reviewModal.addEventListener('click', function(e) {
                if (e.target === reviewModal) {
                    closeReviewModal();
                }
            });

            // Form submission
reviewForm.addEventListener('submit', function(e) {
    const taskId = document.getElementById('taskIdInput').value;
    const revieweeId = document.getElementById('revieweeIdInput').value;
    const rating = document.getElementById('ratingInput').value;
    const comment = document.querySelector('textarea[name="comment"]').value;
    
    console.log('Form data:', {
        task_id: taskId,
        reviewee_id: revieweeId,
        rating: rating,
        comment: comment
    });
    
    if (!taskId || !revieweeId || rating === '0') {
        e.preventDefault();
        alert('Vui lòng điền đầy đủ thông tin!');
        return;
    }
    
    const submitBtn = this.querySelector('button[type="submit"]');
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';
    submitBtn.disabled = true;
});

            // Keyboard navigation
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && reviewModal.classList.contains('show')) {
                    closeReviewModal();
                }
            });
        });

        function openReviewModal(taskId, workerId) {
            const modal = document.getElementById('reviewModal');
            const taskIdInput = document.getElementById('taskIdInput');
            const revieweeIdInput = document.getElementById('revieweeIdInput');
            const ratingInput = document.getElementById('ratingInput');
            const starRating = document.getElementById('starRating');
            const form = document.getElementById('reviewForm');

            // Reset form
            form.reset();
            ratingInput.value = '0';
            
            // Clear star rating
            const stars = starRating.querySelectorAll('i');
            stars.forEach(star => star.classList.remove('active'));
            
            // Set values
            taskIdInput.value = taskId;
            revieweeIdInput.value = workerId;
            
            // Show modal
            modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeReviewModal() {
            const modal = document.getElementById('reviewModal');
            modal.classList.remove('show');
            document.body.style.overflow = '';
        }
    </script>
</body>
</html>