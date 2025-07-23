<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - JobLinks</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Thêm các style tạm thời để demo */
        .hero {
            background: linear-gradient(135deg, #3498db, #2c3e50);
            color: white;
            padding: 80px 0;
        }
        .task-item, .worker-item, .review-item {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .task-item:hover, .worker-item:hover, .review-item:hover {
            transform: translateY(-5px);
        }
        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .review-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            transition: transform 0.3s;
        }
        .review-card:hover {
            transform: translateY(-5px);
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .reviewer {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .reviewer img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
        .reviewer-name {
            font-weight: 500;
        }
        .review-rating i {
            color: #f1c40f;
        }
        .review-comment {
            margin: 10px 0;
            font-style: italic;
        }
        .review-task {
            color: #555;
            font-size: 0.9em;
        }
        .review-date {
            color: #777;
            font-size: 0.85em;
        }
        .empty-state {
            text-align: center;
            padding: 20px;
            color: #555;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-header h2 {
            font-size: 1.5em;
            font-weight: 500;
        }
        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .task-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            transition: transform 0.3s;
            position: relative;
        }
        .task-card:hover {
            transform: translateY(-5px);
        }
        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        .task-title-container {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            margin-right: 10px;
        }
        .task-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        .task-budget {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            white-space: nowrap;
        }
        .task-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .task-location, .task-category {
            color: #6c757d;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .task-location i {
            color: #e74c3c;
        }
        .task-category i {
            color: #3498db;
        }
        .task-description {
            color: #555;
            line-height: 1.6;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .task-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .task-posted {
            color: #6c757d;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .report-btn {
            font-size: 1.2rem;
            color: #6c757d;
            transition: color 0.3s ease;
            padding: 0;
            border: none;
            background: transparent;
            text-decoration: none;
            cursor: pointer;
        }
        .report-btn:hover {
            color: #007bff;
        }
        .support-popup {
            display: none;
            position: fixed !important;
            top: 20% !important;
            right: 5% !important;
            z-index: 1050 !important;
            background: #fff;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            width: 280px;
        }
        .btn-primary {
            background-color: #6e8efb;
            border: none;
            transition: background-color 0.3s ease;
            padding: 8px 16px;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #5d7ce0;
        }
        .btn-secondary {
            background-color: #6c757d;
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        /* CSS cho hot badge từ HEAD branch */
        .hot-badge {
            position: absolute;
            top: -5px;
            left: -5px;
            background: linear-gradient(45deg, #ff6b6b, #ff8e53);
            color: white;
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.75rem;
            text-transform: uppercase;
            box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
            animation: hotPulse 2s infinite;
            z-index: 10;
            visibility: visible !important;
            opacity: 1 !important;
            display: block !important;
        }
        @keyframes hotPulse {
            0% {
                transform: scale(1);
                box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(255, 107, 107, 0.6);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
            }
        }
        .task-card.boosted {
            position: relative;
            border: 2px solid #ff6b6b;
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.2);
        }
        .task-card.boosted:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(255, 107, 107, 0.3);
        }
        .slider-container {
            margin: 10px 0;
        }
        #budgetRangeValue {
            font-weight: bold;
            color: #4e73df;
            margin-left: 10px;
        }
        input[type="range"] {
            width: 45%;
            display: inline-block;
            margin: 0 5px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <div class="banner">
        <!-- Header -->
        <%@include file="header-layout.jsp"%>

        <!-- Hero Banner -->
        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1 class="hero-title">Tìm kiếm việc làm & Đăng tin tuyển dụng</h1>
                        <p class="hero-subtitle">Kết nối nhà tuyển dụng và người tìm việc một cách nhanh chóng và hiệu quả</p>
                        <div class="hero-actions">
                            <a href="/JobLinks/tasks" class="btn btn-primary btn-large">
                                <i class="fas fa-search"></i> Tìm việc ngay
                            </a>
                            <a href="/JobLinks/loadJobPoster" class="btn btn-primary btn-large">
                                <i class="fas fa-bullhorn"></i> Đăng tuyển dụng
                            </a>
                        </div>
                    </div>
                    <div class="hero-image">
                        <img src="https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="People working">
                    </div>
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <section class="stats">
            <div class="container">
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">1,200+</div>
                        <div class="stat-label">Công việc đang tuyển</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Nhà tuyển dụng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">3,000+</div>
                        <div class="stat-label">Ứng viên</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">95%</div>
                        <div class="stat-label">Hài lòng với dịch vụ</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <!-- Recommended Tasks -->
                <section class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-bullhorn"></i> Công việc đề xuất</h2>
                        <a href="${pageContext.request.contextPath}/tasks" class="btn btn-link">Xem tất cả</a>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="search-filter card">
                        <form action="${pageContext.request.contextPath}/home" method="get" class="filter-form">
                            <div class="form-group">
                                <input type="text" name="search" placeholder="Tìm kiếm công việc..." value="${param.search}" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="location">Địa điểm:</label>
                                <select name="location" class="form-control">
                                    <option value="">Tất cả địa điểm</option>
                                    <option value="Hanoi" ${param.location == 'Hanoi' ? 'selected' : ''}>Hà Nội</option>
                                    <option value="HCMC" ${param.location == 'HCMC' ? 'selected' : ''}>Hồ Chí Minh</option>
                                    <option value="Da Nang" ${param.location == 'Danang' ? 'selected' : ''}>Đà Nẵng</option>
                                </select>
                            </div>
                            <div class="form-group slider-container">
                                <label for="budgetRange">Ngân sách (VND):</label>
                                <input type="range" id="budgetMin" name="budgetMin" min="10000.0" max="10000000.0" step="1000.0"
                                       value="${not empty param.budgetMin ? param.budgetMin : 10000.0}" 
                                       oninput="updateBudgetRange()">
                                <input type="range" id="budgetMax" name="budgetMax" min="10000.0" max="10000000.0" step="1000.0"
                                       value="${not empty param.budgetMax ? param.budgetMax : 10000000.0}" 
                                       oninput="updateBudgetRange()">
                                <span id="budgetRangeValue">Từ ${not empty param.budgetMin ? param.budgetMin : '10,000.0'} đến ${not empty param.budgetMax ? param.budgetMax : '10,000,000.0'} VND</span>
                            </div>
                            <div class="form-group">
                                <select name="categoryId" class="form-control">
                                    <option value="">Tất cả danh mục</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" <c:if test="${param.categoryId == category.categoryId}">selected</c:if>>
                                            ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Lọc
                            </button>
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${empty recommendedTasks}">
                            <div class="empty-state">
                                <i class="fas fa-briefcase"></i>
                                <p>Hiện không có công việc nào phù hợp</p>
                                <a href="${pageContext.request.contextPath}/tasks" class="btn btn-primary">Khám phá công việc</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="tasks-grid">
                                <c:forEach var="task" items="${recommendedTasks}" end="5">
                                    <div class="task-card ${task.boosted ? 'boosted' : ''}">
                                        <!-- Hot badge for boosted task -->
                                        <c:if test="${task.boosted}">
                                            <span class="hot-badge">
                                                <i class="fas fa-fire"></i> Hot
                                            </span>
                                        </c:if>
                                        <div class="task-header">
                                            <div class="task-title-container">
                                                <h3 class="task-title">${task.title}</h3>
                                                <button type="button" class="report-btn" onclick="showReportPopup(${task.taskId}, ${task.userId})">
                                                    <i class="fas fa-flag"></i>
                                                </button>
                                            </div>
                                            <span class="task-budget">
                                                <fmt:formatNumber value="${task.budget}" type="currency" currencyCode="VND"/>
                                            </span>
                                        </div>
                                        <div class="support-popup" id="supportPopup_${task.taskId}">
                                            <h5 class="mb-3"><i class="fas fa-life-ring"></i> Báo cáo</h5>
                                            <ul style="list-style:none; padding:0; margin:0;">
                                                <li class="mb-2">
                                                    <a href="${pageContext.request.contextPath}/report?userId=${task.userId}" class="btn btn-link w-100 text-start">
                                                        <i class="fas fa-user-slash"></i> Report người dùng
                                                    </a>
                                                </li>
                                                <li class="mb-2">
                                                    <a href="${pageContext.request.contextPath}/report?taskId=${task.taskId}&userId=${task.userId}" class="btn btn-link w-100 text-start">
                                                        <i class="fas fa-flag"></i> Report người dùng và task
                                                    </a>
                                                </li>
                                            </ul>
                                            <button class="btn btn-secondary btn-sm mt-3 w-100" onclick="document.getElementById('supportPopup_${task.taskId}').style.display = 'none'">Đóng</button>
                                        </div>
                                        <div class="task-meta">
                                            <span class="task-location"><i class="fas fa-map-marker-alt"></i> ${task.location}</span>
                                            <span class="task-category"><i class="fas fa-tag"></i> ${task.categoryName != null ? task.categoryName : 'Chung'}</span>
                                        </div>
                                        <p class="task-description">
                                            <c:choose>
                                                <c:when test="${not empty task.description}">
                                                    ${task.description}
                                                </c:when>
                                                <c:otherwise>
                                                    Mô tả công việc sẽ được cập nhật sớm...
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div class="task-footer">
                                            <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=${task.taskId}" class="btn btn-primary">
                                                <i class="fas fa-eye"></i> Xem chi tiết
                                            </a>
                                            <span class="task-posted"><i class="far fa-clock"></i>
                                                <c:choose>
                                                    <c:when test="${not empty task.createdAt}">
                                                        ${task.createdAt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Ngày đăng không khả dụng
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Top Workers -->
                <section class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-star"></i> Người làm có kinh nghiệm</h2>
                    </div>
                    <div class="experienced-grid">
                        <div class="person-card">
                            <img src="img/worker1.png" alt="worker" class="worker-img">
                            <h3>Elon Musk</h3>
                            <p>Kinh nghiệm: 15 năm</p>
                            <p>Chuyên ngành: Lập trình Java</p>
                        </div>
                        <div class="person-card">
                            <img src="img/worker2.png" alt="worker" class="worker-img">
                            <h3>Tôi năm nay</h3>
                            <p>Kinh nghiệm: 70 năm</p>
                            <p>Chuyên ngành: Thiết kế Web</p>
                        </div>
                        <div class="person-card">
                            <img src="img/worker3.png" alt="worker" class="worker-img">
                            <h3>Officer Meow</h3>
                            <p>Kinh nghiệm: 7 năm</p>
                            <p>Chuyên ngành: Quản lý dự án</p>
                        </div>
                    </div>
                </section>

                <!-- Recent Reviews -->
                <section class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-comment-alt"></i> Đánh giá gần đây</h2>
                    </div>
                    <div class="reviews-grid">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="review" items="${reviews}" end="5">
                                    <div class="review-card review-item">
                                        <div class="review-header">
                                            <div class="reviewer">
                                                <img src="https://ui-avatars.com/api/?name=${review.reviewerName}&background=random" alt="${review.reviewerName}">
                                                <span class="reviewer-name">${review.reviewerName}</span>
                                            </div>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= review.rating}">
                                                            <i class="fas fa-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="review-content">
                                            <p class="review-comment">"${review.comment}"</p>
                                            <div class="review-task">
                                                <i class="fas fa-briefcase"></i> ${review.taskTitle}
                                            </div>
                                        </div>
                                        <div class="review-date">
                                            <i class="far fa-clock"></i>
                                            <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-comment-alt"></i>
                                    <p>Không có đánh giá nào để hiển thị</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- Call to Action -->
                <section class="cta-section">
                    <div class="cta-content">
                        <h2>Sẵn sàng bắt đầu?</h2>
                        <p>Tham gia ngay để khám phá hàng ngàn cơ hội việc làm hoặc tìm kiếm ứng viên tiềm năng</p>
                        <div class="cta-actions">
                            <c:if test="${empty sessionScope.user}">
                                <a href="register.jsp" class="btn btn-primary btn-large">
                                    <i class="fas fa-user-plus"></i> Đăng ký ngay
                                </a>
                                <a href="login.jsp" class="btn btn-outline btn-large">
                                    <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                </a>
                            </c:if>
                            <c:if test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/tasks" class="btn btn-primary btn-large">
                                    <i class="fas fa-search"></i> Tìm việc ngay
                                </a>
                                <a href="${pageContext.request.contextPath}/loadJobPoster" class="btn btn-outline btn-large">
                                    <i class="fas fa-bullhorn"></i> Đăng tuyển dụng
                                </a>
                            </c:if>
                        </div>
                    </div>
                </section>
            </div>
        </main>

        <!-- Footer -->
        <%@include file="footer.jsp" %>
    </div>     
    <script>
        function updateBudgetRange() {
            var min = document.getElementById('budgetMin').value;
            var max = document.getElementById('budgetMax').value;
            if (parseInt(min) > parseInt(max)) {
                document.getElementById('budgetMin').value = max;
                min = max;
            }
            document.getElementById('budgetRangeValue').innerHTML =
                    'Từ ' + Number(min).toLocaleString('vi-VN') + ' đến ' + Number(max).toLocaleString('vi-VN') + ' VND';
        }

        function showReportPopup(taskId, userId) {
            // Hide all other popups
            document.querySelectorAll('.support-popup').forEach(popup => {
                popup.style.display = 'none';
                popup.style.position = 'fixed';
                popup.style.top = '20%';
                popup.style.right = '5%';
            });
            // Show the specific popup
            const popup = document.getElementById('supportPopup_' + taskId);
            if (popup) {
                popup.style.display = 'block';
                popup.style.position = 'fixed';
                popup.style.top = '20%';
                popup.style.right = '5%';
            }
        }

        // Close popup when clicking outside
        document.addEventListener('click', function (event) {
            const popups = document.querySelectorAll('.support-popup');
            const reportButtons = document.querySelectorAll('.report-btn');
            let isClickInsidePopup = false;
            let isClickOnReportButton = false;

            // Check if click is inside any popup
            popups.forEach(popup => {
                if (popup.contains(event.target)) {
                    isClickInsidePopup = true;
                }
            });

            // Check if click is on any report button
            reportButtons.forEach(button => {
                if (button.contains(event.target)) {
                    isClickOnReportButton = true;
                }
            });

            // If click is outside both popup and report button, hide all popups
            if (!isClickInsidePopup && !isClickOnReportButton) {
                popups.forEach(popup => {
                    popup.style.display = 'none';
                });
            }
        });

        window.addEventListener('DOMContentLoaded', function () {
            updateBudgetRange();
        });
    </script>
</body>
</html>