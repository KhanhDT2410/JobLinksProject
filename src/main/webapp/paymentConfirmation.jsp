<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Thanh toán</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
            --light-color: #f8f9fc;
            --dark-color: #5a5c69;
            --success-color: #1cc88a;
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
        
        /* Header styles */
        .header {
            background-color: white;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(44, 62, 80, 0.15);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .logo-img {
            height: 40px;
        }

        .menu {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .greeting {
            font-weight: 500;
            color: #2c3e50;
            margin-right: 20px;
        }

        .nav {
            display: flex;
            gap: 15px;
        }

        .nav-link {
            color: #2c3e50;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: color 0.3s;
        }

        .nav-link.active, .nav-link:hover {
            color: #3498db;
        }

        .header-actions, .dropdown {
            margin-left: auto;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-toggle {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.5rem;
            color: #2c3e50;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            border-radius: 0.35rem;
            min-width: 200px;
            z-index: 1000;
        }

        .dropdown-menu.show {
            display: block;
        }

        .dropdown-item {
            display: block;
            padding: 0.5rem 1rem;
            color: #2c3e50;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .dropdown-item:hover {
            background-color: #ecf0f1;
            color: #3498db;
        }
        
        /* Main content styles */
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
            background-color: white;
            padding: 1.5rem;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        
        .page-header h1 {
            font-size: 1.75rem;
            color: var(--dark-color);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Alert styles */
        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 0.35rem;
            position: relative;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .alert-dismissible .btn-close {
            position: absolute;
            top: 0;
            right: 0;
            padding: 1.25rem 1rem;
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
        }
        
        /* Card styles */
        .card {
            background-color: white;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            overflow: hidden;
        }
        
        .card-header {
            background-color: var(--light-color);
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e3e6f0;
        }
        
        .card-header h5 {
            margin: 0;
            font-weight: 600;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        /* Badge styles */
        .badge {
            display: inline-block;
            padding: 0.25em 0.4em;
            font-size: 75%;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.25rem;
        }
        
        .bg-primary {
            background-color: var(--primary-color) !important;
            color: white;
        }
        
        /* Empty state styles */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #adb5bd;
            margin-bottom: 1rem;
        }
        
        .empty-state h5 {
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: #6c757d;
            margin: 0;
        }
        
        /* Table styles */
        .table-responsive {
            overflow-x: auto;
        }
        
        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #212529;
            border-collapse: collapse;
        }
        
        .table th,
        .table td {
            padding: 0.75rem;
            vertical-align: top;
            border-top: 1px solid #dee2e6;
        }
        
        .table thead th {
            vertical-align: bottom;
            border-bottom: 2px solid #dee2e6;
            background-color: var(--light-color);
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(0, 0, 0, 0.075);
        }
        
        /* Button styles */
        .btn {
            display: inline-block;
            font-weight: 400;
            text-align: center;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.35rem;
            text-decoration: none;
            transition: all 0.15s ease-in-out;
        }
        
        .btn-primary {
            color: #fff;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2653d4;
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            color: #fff;
            background-color: #858796;
            border-color: #858796;
        }
        
        .btn-secondary:hover {
            background-color: #717384;
            border-color: #6b6d7d;
        }
        
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            line-height: 1.5;
            border-radius: 0.2rem;
        }
        
        /* Text utilities */
        .text-muted {
            color: #6c757d !important;
        }
        
        .text-success {
            color: var(--success-color) !important;
        }
        
        .text-danger {
            color: var(--danger-color) !important;
        }
        
        .text-primary {
            color: var(--primary-color) !important;
        }
        
        .fw-bold {
            font-weight: 700 !important;
        }
        
        /* Footer styles */
        .footer {
            background-color: #2c3e50;
            color: white;
            padding: 1.5rem;
            text-align: center;
            margin-top: auto;
        }

        .footer .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            box-shadow: none;
            background-color: transparent;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 1.5rem;
        }

        .footer-col h3 {
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }

        .footer-links, .footer-contact {
            list-style: none;
            padding: 0;
        }

        .footer-links li, .footer-contact li {
            margin-bottom: 0.5rem;
        }

        .footer-links a {
            color: white;
            text-decoration: none;
        }

        .footer-links a:hover {
            color: #3498db;
        }

        .social-links a {
            color: white;
            margin: 0 10px;
            font-size: 1.2rem;
            transition: color 0.3s;
        }

        .social-links a:hover {
            color: #3498db;
        }

        .newsletter-form {
            display: flex;
            gap: 10px;
        }

        .form-control {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 0.35rem;
            flex: 1;
        }

        .footer-bottom {
            border-top: 1px solid #34495e;
            padding-top: 1rem;
            margin-top: 1rem;
        }

        .footer-legal a {
            color: white;
            margin: 0 10px;
            text-decoration: none;
        }

        .footer-legal a:hover {
            color: #3498db;
        }

        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #3498db;
            color: white;
            padding: 10px 15px;
            border-radius: 50%;
            text-decoration: none;
            display: none;
        }

        .back-to-top.show {
            display: block;
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .container {
                padding: 0 15px;
            }
        }
    </style>
</head>
<body>
    <%@include file="jobPosterHeader.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1>
                    <i class="fas fa-credit-card"></i>
                    Xác nhận Thanh toán
                </h1>
                <a href="${pageContext.request.contextPath}/loadJobPoster" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i>Quay lại
                </a>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible" role="alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${sessionScope.error}
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none'">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible" role="alert">
                    <i class="fas fa-check-circle"></i>
                    ${sessionScope.success}
                    <button type="button" class="btn-close" onclick="this.parentElement.style.display='none'">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
                        <!-- Thông báo đánh giá -->
            <div class="alert alert-info" style="background-color: #fff3cd; color: #856404; border-color: #ffeeba;">
                <i class="fas fa-info-circle"></i>
                <span>Bạn có thể đánh giá worker sau khi đã thanh toán tại phần Xem Task đã hoàn thành ở danh mục!</span>
            </div>

            <!-- Tasks Waiting for Payment Card -->
            <div class="card">
                <div class="card-header">
                    <h5>
                        <i class="fas fa-tasks"></i>
                        Công việc đã hoàn thành chờ xác nhận thanh toán
                        <span class="badge bg-primary">${tasksWaitingForPayment.size()}</span>
                    </h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty tasksWaitingForPayment}">
                            <div class="empty-state">
                                <i class="fas fa-clipboard-check"></i>
                                <h5>Không có công việc nào chờ xác nhận thanh toán</h5>
                                <p>Các công việc đã hoàn thành sẽ hiển thị ở đây để bạn xác nhận thanh toán.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-briefcase me-1"></i>Tiêu đề công việc</th>
                                            <th><i class="fas fa-file-text me-1"></i>Mô tả</th>
                                            <th><i class="fas fa-map-marker-alt me-1"></i>Vị trí</th>
                                            <th><i class="fas fa-dollar-sign me-1"></i>Ngân sách</th>
                                            <th><i class="fas fa-user me-1"></i>Worker</th>
                                            <th><i class="fas fa-clock me-1"></i>Thời gian tạo</th>
                                            <th><i class="fas fa-cogs me-1"></i>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="task" items="${tasksWaitingForPayment}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold">${task.title}</div>
                                                    <small class="text-muted">ID: ${task.taskId}</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${task.description.length() > 50}">
                                                            <span title="${task.description}">
                                                                ${task.description.substring(0, 50)}...
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${task.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                                    ${task.location}
                                                </td>
                                                <td>
                                                    <div class="fw-bold text-success">
                                                        <fmt:formatNumber value="${task.budget}" type="currency" currencySymbol="" maxFractionDigits="0"/>
                                                        <small class="text-muted d-block">VND</small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-user text-primary me-2"></i>
                                                        ${task.workerName}
                                                    </div>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy"/>
                                                    <small class="text-muted d-block">
                                                        <fmt:formatDate value="${task.createdAt}" pattern="HH:mm"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/confirmCompletion" method="post" class="d-inline"
                                                          onsubmit="return confirmPayment();">
                                                        <input type="hidden" name="taskId" value="${task.taskId}">
                                                        <button type="submit" class="btn btn-primary btn-sm">
                                                            <i class="fas fa-check me-1"></i> Xác nhận Thanh toán
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <%@include file="jobPosterFooter.jsp" %>

    <!-- Back to top button -->
    <a href="#" id="backToTop" class="back-to-top">
        <i class="fas fa-chevron-up"></i>
    </a>

    <script>
        // Dropdown functionality - Wait for all includes to load
        window.addEventListener('load', function() {
            // Try to find dropdown elements multiple times in case they load late
            let attempts = 0;
            const maxAttempts = 10;
            
            function initDropdown() {
                const dropdownButton = document.getElementById('dropdownMenuButton');
                const dropdownMenu = document.getElementById('dropdownMenu');
                
                if (dropdownButton && dropdownMenu) {
                    // Remove any existing event listeners to prevent duplicates
                    dropdownButton.removeEventListener('click', toggleDropdown);
                    dropdownButton.addEventListener('click', toggleDropdown);

                    document.removeEventListener('click', closeDropdownOnClickOutside);
                    document.addEventListener('click', closeDropdownOnClickOutside);
                    
                    console.log('Dropdown initialized successfully');
                    return true;
                } else {
                    attempts++;
                    if (attempts < maxAttempts) {
                        setTimeout(initDropdown, 100);
                    } else {
                        console.log('Dropdown elements not found after', maxAttempts, 'attempts');
                    }
                    return false;
                }
            }
            
            function toggleDropdown(event) {
                event.preventDefault();
                event.stopPropagation();
                const dropdownMenu = document.getElementById('dropdownMenu');
                if (dropdownMenu) {
                    dropdownMenu.classList.toggle('show');
                }
            }
            
            function closeDropdownOnClickOutside(event) {
                const dropdown = document.querySelector('.dropdown');
                const dropdownMenu = document.getElementById('dropdownMenu');
                if (dropdown && dropdownMenu && !dropdown.contains(event.target)) {
                    dropdownMenu.classList.remove('show');
                }
            }
            
            // Start trying to initialize dropdown
            initDropdown();

            // Back to top functionality
            const backToTop = document.getElementById('backToTop');
            if (backToTop) {
                window.addEventListener('scroll', function() {
                    if (window.pageYOffset > 300) {
                        backToTop.classList.add('show');
                    } else {
                        backToTop.classList.remove('show');
                    }
                });

                backToTop.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                });
            }
        });
        
        // Alternative approach - try to initialize when DOM changes
        if (window.MutationObserver) {
            const observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.type === 'childList') {
                        const dropdownButton = document.getElementById('dropdownMenuButton');
                        if (dropdownButton && !dropdownButton.hasAttribute('data-initialized')) {
                            dropdownButton.setAttribute('data-initialized', 'true');
                            dropdownButton.addEventListener('click', function(event) {
                                event.preventDefault();
                                event.stopPropagation();
                                const dropdownMenu = document.getElementById('dropdownMenu');
                                if (dropdownMenu) {
                                    dropdownMenu.classList.toggle('show');
                                }
                            });
                        }
                    }
                });
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        }
        
        // Enhanced confirmation dialog
        function confirmPayment() {
            return confirm('⚠️ Xác nhận thanh toán\n\nBạn có chắc chắn muốn xác nhận thanh toán cho công việc này không?\n\nHành động này không thể hoàn tác.');
        }
        
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.style.display = 'none';
                    }, 300);
                }, 5000);
            });
        });
        
        // Add loading state to payment buttons
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('form[action*="confirmCompletion"]');
            forms.forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    const button = form.querySelector('button[type="submit"]');
                    if (button && confirmPayment()) {
                        button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Đang xử lý...';
                        button.disabled = true;
                    }
                });
            });
        });
    </script>
</body>
</html>