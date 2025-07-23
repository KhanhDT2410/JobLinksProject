<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CSS for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            margin-top: 20px;
        }
        .search-bar {
            background-color: #ffffff;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .task-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
            position: relative;
            margin-bottom: 20px;
        }
        .task-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        .task-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .task-title-container {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: 200px;
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
            margin-right: 60px;
            padding: 8px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            white-space: nowrap;
            align-self: flex-start;
        }
        .task-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            flex-wrap: wrap;
            align-items: center;
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
            font-size: 0.95rem;
        }
        .task-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
            flex-wrap: wrap;
            gap: 10px;
        }
        .task-footer .btn-group {
            display: flex;
            gap: 10px;
        }
        .task-footer .btn {
            padding: 8px 12px;
            font-size: 0.9rem;
        }
        .task-posted {
            color: #6c757d;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }
        .task-status {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-active {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        .empty-state p {
            font-size: 1.2rem;
            margin-bottom: 20px;
        }
        .pagination-wrapper {
            display: flex;
            justify-content: center;
            margin-top: 40px;
        }
        .pagination .page-link {
            color: #6e8efb;
            border: 1px solid #dee2e6;
            padding: 10px 15px;
        }
        .pagination .page-link:hover {
            color: #5d7ce0;
            background-color: #f8f9fa;
            border-color: #6e8efb;
        }
        .pagination .page-item.active .page-link {
            background-color: #6e8efb;
            border-color: #6e8efb;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
        }
        .bookmark-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            border: none;
            background: transparent;
            font-size: 1.2rem;
            color: #dee2e6;
            transition: color 0.3s ease;
            padding: 5px;
        }
        .bookmark-btn:hover {
            color: #dc3545;
        }
        .bookmark-btn.bookmarked {
            color: #dc3545;
        }
        .report-btn {
            position: absolute;
            top: 15px;
            right: 45px; /* Cách bookmark-btn 30px */
            border: none;
            background: transparent;
            font-size: 1.2rem;
            color: #6c757d;
            transition: color 0.3s ease;
            padding: 5px;
        }
        .report-btn:hover {
            color: #007bff;
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
        .link-custom {
            color: #6e8efb;
            text-decoration: none;
            font-weight: 500;
        }
        .link-custom:hover {
            color: #5d7ce0;
            text-decoration: underline;
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
            margin-top: 40px;
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
        /* New styles for boosted tasks */
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
        }
        @keyframes hotPulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(255, 107, 107, 0.6);
            }
        }
        .task-card.boosted {
            border: 2px solid #ff6b6b;
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.2);
        }
        .task-card.boosted:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 30px rgba(255, 107, 107, 0.3);
        }
        /* Popup styles */
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
        /* Styles for search history */
        .search-history {
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin-top: 10px;
            padding: 10px;
            max-width: 300px;
            position: absolute;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: none;
        }
        .search-history.show {
            display: block;
        }
        .search-history-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 0.9rem;
            color: #2c3e50;
        }
        .search-history-item:hover {
            background-color: #f8f9fa;
        }
        .search-history-item .delete-btn {
            color: #dc3545;
            font-size: 0.8rem;
            background: none;
            border: none;
            cursor: pointer;
        }
        .search-history-item .delete-btn:hover {
            color: #c82333;
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
                <c:choose>
                    <c:when test="${requestScope.currentPage == 'available'}">
                        <a href="${pageContext.request.contextPath}/tasks?action=applied"><i class="fas fa-list"></i> My Applications</a>
                        <a href="${pageContext.request.contextPath}/acceptedTasks"><i class="fas fa-check"></i> Công việc đã nhận</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/tasks"><i class="fas fa-tasks"></i> Danh sách công việc</a>
                        <a href="${pageContext.request.contextPath}/acceptedTasks"><i class="fas fa-check"></i> Công việc đã nhận</a>
                    </c:otherwise>
                </c:choose>
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
        <!-- Page Title -->
        <h1>${requestScope.pageTitle}</h1>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
            <c:remove var="error" scope="request"/>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
            <c:remove var="success" scope="request"/>
        </c:if>

        <!-- Search/Filter Bar -->
        <c:if test="${currentPage == 'available'}">
            <div class="search-bar card">
                <form action="${pageContext.request.contextPath}/tasks?action=list" method="get" class="row g-3 filter-form">
                    <input type="hidden" name="action" value="list"/>
                    <input type="hidden" name="page" value="1"/>
                    <div class="col-md-3 position-relative">
                        <label for="searchKeyword" class="form-label">Từ khóa</label>
                        <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" value="${searchKeyword}" placeholder="Tìm kiếm công việc..." autocomplete="off">
                        <div id="searchHistory" class="search-history"></div>
                    </div>
                    <div class="col-md-3">
                        <label for="location" class="form-label">Địa điểm</label>
                        <select class="form-select" id="location" name="location">
                            <option value="">Tất cả địa điểm</option>
                            <option value="Hanoi" ${location == 'Hanoi' ? 'selected' : ''}>Hà Nội</option>
                            <option value="HCMC" ${location == 'HCMC' ? 'selected' : ''}>Hồ Chí Minh</option>
                            <option value="DaNang" ${location == 'Danang' ? 'selected' : ''}>Đà Nẵng</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="budgetRange" class="form-label">Ngân sách (VND)</label>
                        <div class="slider-container">
                            <input type="range" id="budgetMin" name="budgetMin" min="10000" max="10000000" step="1000"
                                   value="${not empty budgetMin ? budgetMin : 10000}" oninput="updateBudgetRange()">
                            <input type="range" id="budgetMax" name="budgetMax" min="10000" max="10000000" step="1000"
                                   value="${not empty budgetMax ? budgetMax : 10000000}" oninput="updateBudgetRange()">
                            <span id="budgetRangeValue">Từ <fmt:formatNumber value="${not empty budgetMin ? budgetMin : 10000}" type="number" groupingUsed="true"/> đến <fmt:formatNumber value="${not empty budgetMax ? budgetMax : 10000000}" type="number" groupingUsed="true"/> VND</span>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label for="categoryId" class="form-label">Danh mục</label>
                        <select class="form-select" id="categoryId" name="categoryId">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}" ${categoryId == category.categoryId ? 'selected' : ''}>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-1 align-self-end">
                        <button type="submit" class="btn btn-primary w-100 mb-2">
                            <i class="fas fa-filter"></i> Tìm kiếm
                        </button>
                        <button type="button" class="btn btn-secondary w-100" onclick="resetForm()">Reset</button>
                    </div>
                </form>
            </div>
            <a href="${pageContext.request.contextPath}/boostTask" class="link-custom">Quản Lý Boost Task</a>
            <a href="${pageContext.request.contextPath}/TaskServlet2?action=compare" class="link-custom ms-3">Xem danh sách so sánh</a>
        </c:if>

        <!-- Tasks Display -->
        <c:choose>
            <c:when test="${empty tasks}">
                <div class="empty-state">
                    <i class="fas fa-briefcase"></i>
                    <p>Hiện không có công việc nào phù hợp</p>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn btn-primary">Khám phá công việc</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="tasks-grid">
                    <c:forEach var="task" items="${tasks}">
                        <div class="task-card ${task.boosted ? 'boosted' : ''}">
                            <!-- Hot badge for boosted task -->
                            <c:if test="${task.boosted}">
                                <span class="hot-badge">
                                    <i class="fas fa-fire"></i> Hot
                                </span>
                            </c:if>
                            <button type="button" class="bookmark-btn ${bookmarkedTaskIds.contains(task.taskId) ? 'bookmarked' : ''}" 
        onclick="toggleBookmark(${task.taskId}, this)">
    <i class="${bookmarkedTaskIds.contains(task.taskId) ? 'fas fa-heart' : 'far fa-heart'}"></i>
</button>
                            <button type="button" class="report-btn" onclick="showReportPopup(${task.taskId}, ${task.userId})">
                                <i class="fas fa-flag"></i>
                            </button>
                            <div class="task-header">
                                <div class="task-title-container">
                                    <h3 class="task-title">${task.title}</h3>
                                </div>
                                <span class="task-budget">
                                    <fmt:formatNumber value="${task.budget}" type="currency" currencyCode="VND"/>
                                </span>
                            </div>
                            <div class="task-meta">
                                <span class="task-location">
                                    <i class="fas fa-map-marker-alt"></i> ${task.location}
                                </span>
                                <span class="task-category">
                                    <i class="fas fa-tag"></i> ${task.categoryName != null ? task.categoryName : 'Chung'}
                                </span>
                                <span class="task-status status-${task.status.toLowerCase()}">
                                    ${task.status}
                                </span>
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
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=${task.taskId}" class="btn btn-primary">
                                        <i class="fas fa-eye"></i> Xem chi tiết
                                    </a>
                                    <button type="button" class="btn btn-primary btn-sm ms-2" onclick="addToComparison(${task.taskId}, this)">
                                        <i class="fas fa-plus"></i> Thêm vào so sánh
                                    </button>
                                </div>
                                <span class="task-posted">
                                    <i class="far fa-clock"></i> 
                                    <c:choose>
                                        <c:when test="${not empty task.createdAt}">
                                            <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            Ngày đăng không khả dụng
                                        </c:otherwise>
                                    </c:choose>
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
                                <button class="btn btn-secondary btn-sm mt-3 w-100" onclick="document.getElementById('supportPopup_${task.taskId}').style.display='none'">Đóng</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-wrapper">
                        <nav aria-label="Task pagination">
                            <ul class="pagination">
                                <c:if test="${currentPageNum > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/tasks?action=list&page=${currentPageNum - 1}&searchKeyword=${searchKeyword}&location=${location}&budgetMin=${budgetMin}&budgetMax=${budgetMax}&categoryId=${categoryId}">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </li>
                                </c:if>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPageNum}">
                                            <li class="page-item active">
                                                <span class="page-link">${i}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/tasks?action=list&page=${i}&searchKeyword=${searchKeyword}&location=${location}&budgetMin=${budgetMin}&budgetMax=${budgetMax}&categoryId=${categoryId}">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPageNum < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/tasks?action=list&page=${currentPageNum + 1}&searchKeyword=${searchKeyword}&location=${location}&budgetMin=${budgetMin}&budgetMax=${budgetMax}&categoryId=${categoryId}">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
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

    <!-- Bootstrap JS -->
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

        function resetForm() {
            document.getElementById("searchKeyword").value = "";
            document.getElementById("location").value = "";
            document.getElementById("budgetMin").value = "10000";
            document.getElementById("budgetMax").value = "10000000";
            document.getElementById("categoryId").value = "";
            updateBudgetRange();
            document.querySelector("form").submit();
        }

        function toggleBookmark(taskId, btn) {
            const userId = '<c:out value="${sessionScope.userId}" default="null"/>';
            if (userId === 'null' || !userId) {
                alert("Vui lòng đăng nhập để sử dụng chức năng này.");
                return;
            }
            console.log("Toggle Bookmark - taskId:", taskId, "userId:", userId);
            const isBookmarked = btn.classList.contains('bookmarked');
            const action = isBookmarked ? 'unbookmark' : 'bookmark';
            fetch('${pageContext.request.contextPath}/tasks', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=' + encodeURIComponent(action) + '&taskId=' + encodeURIComponent(taskId) + '&userId=' + encodeURIComponent(userId)
            })
            .then(response => {
                console.log("Response status:", response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log("Response data:", data);
                if (data.success) {
                    btn.classList.toggle('bookmarked');
                    const icon = btn.querySelector('i');
                    if (isBookmarked) {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                    } else {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                    }
                    showNotification(data.message, 'success');
                } else {
                    showNotification('Thao tác thất bại: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Lỗi:', error);
                showNotification('Đã xảy ra lỗi khi thực hiện thao tác.', 'error');
            });
        }

        function addToComparison(taskId, btn) {
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
                body: 'action=addToComparison&taskId=' + encodeURIComponent(taskId) + '&userId=' + encodeURIComponent(userId)
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
                    showNotification(data.message, 'success');
                    btn.disabled = true;
                    btn.innerHTML = '<i class="fas fa-check"></i> Đã thêm';
                } else {
                    showNotification(data.message || 'Thao tác thất bại', 'error');
                }
            })
            .catch(error => {
                console.error('Lỗi AJAX:', error);
                showNotification('Đã xảy ra lỗi: ' + error.message, 'error');
            });
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-' + (type === 'success' ? 'success' : 'danger') + ' position-fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.zIndex = '9999';
            notification.textContent = message;
            document.body.appendChild(notification);
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 3000);
        }

        function showReportPopup(taskId, userId) {
            document.querySelectorAll('.support-popup').forEach(popup => {
                popup.style.display = 'none';
                popup.style.position = 'fixed';
                popup.style.top = '20%';
                popup.style.right = '5%';
            });
            const popup = document.getElementById('supportPopup_' + taskId);
            if (popup) {
                popup.style.display = 'block';
                popup.style.position = 'fixed';
                popup.style.top = '20%';
                popup.style.right = '5%';
            }
        }

        document.addEventListener('click', function(event) {
            const popups = document.querySelectorAll('.support-popup');
            const reportButtons = document.querySelectorAll('.report-btn');
            let isClickInsidePopup = false;
            let isClickOnReportButton = false;

            popups.forEach(popup => {
                if (popup.contains(event.target)) {
                    isClickInsidePopup = true;
                }
            });

            reportButtons.forEach(button => {
                if (button.contains(event.target)) {
                    isClickOnReportButton = true;
                }
            });

            if (!isClickInsidePopup && !isClickOnReportButton) {
                popups.forEach(popup => {
                    popup.style.display = 'none';
                });
            }
        });

        // Search history functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('searchKeyword');
            const searchForm = document.querySelector('.filter-form');
            const searchHistoryDiv = document.getElementById('searchHistory');

            // Load search history from localStorage
            function loadSearchHistory() {
                const history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
                console.log('Loading search history:', history); // Debug log
                if (history.length > 0) {
                    searchHistoryDiv.innerHTML = '';
                    history.slice(0, 5).forEach((item, index) => {
                        const div = document.createElement('div');
                        div.className = 'search-history-item';
                        const span = document.createElement('span');
                        span.textContent = item;
                        span.onclick = () => applySearch(item); // Safer event attachment
                        const button = document.createElement('button');
                        button.className = 'delete-btn';
                        button.innerHTML = '<i class="fas fa-times"></i>';
                        button.onclick = (e) => { e.stopPropagation(); deleteSearch(index); }; // Safer event attachment with stopPropagation
                        div.appendChild(span);
                        div.appendChild(button);
                        searchHistoryDiv.appendChild(div);
                    });
                    searchHistoryDiv.classList.add('show');
                } else {
                    searchHistoryDiv.classList.remove('show');
                }
            }

            // Save search term to localStorage
            function saveSearch(term) {
                if (!term.trim()) return;
                let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
                history = [term, ...history.filter(item => item !== term)].slice(0, 5);
                localStorage.setItem('searchHistory', JSON.stringify(history));
                loadSearchHistory();
            }

            // Apply search term from history
            window.applySearch = function(term) {
                searchInput.value = term;
                searchForm.submit();
            };

            // Delete search term from history
            window.deleteSearch = function(index) {
                let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
                history.splice(index, 1);
                localStorage.setItem('searchHistory', JSON.stringify(history));
                loadSearchHistory();
            };

            // Show/hide search history on input focus
            searchInput.addEventListener('focus', () => {
                loadSearchHistory();
            });

            // Hide search history when clicking outside
            document.addEventListener('click', (e) => {
                if (!searchInput.contains(e.target) && !searchHistoryDiv.contains(e.target)) {
                    searchHistoryDiv.classList.remove('show');
                }
            });

            // Save search term on form submit
            searchForm.addEventListener('submit', (e) => {
                e.preventDefault(); // Prevent default form submission
                const term = searchInput.value;
                saveSearch(term);
                searchForm.submit(); // Submit form after saving
            });

            // Initial load
            loadSearchHistory();
        });

        window.addEventListener('DOMContentLoaded', function() {
            updateBudgetRange();
        });
    </script>
</body>
</html>