<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận ẩn công việc</title>
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 0;
            margin-top: 130px;
        }
        
        .container1 {
            background-color: white;
            padding: 2rem;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 0 20px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        
        .page-header h1 {
            font-size: 1.5rem;
            color: var(--dark-color);
            font-weight: 700;
        }
        
        .task-details {
            background-color: #f8f9fc;
            padding: 1.5rem;
            border-radius: 0.35rem;
            border-left: 4px solid var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 0.75rem;
            align-items: flex-start;
        }
        
        .detail-row:last-child {
            margin-bottom: 0;
        }
        
        .detail-label {
            font-weight: 600;
            color: var(--dark-color);
            min-width: 120px;
            margin-right: 1rem;
        }
        
        .detail-value {
            flex: 1;
            color: #333;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-assigned {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .warning-message {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 1rem;
            border-radius: 0.35rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .warning-message i {
            font-size: 1.2rem;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.35rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            margin-right: 10px;
            font-size: 0.875rem;
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
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #545b62;
            transform: translateY(-1px);
        }
        
        .error {
            color: var(--danger-color);
            margin-bottom: 1rem;
            text-align: center;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 0.75rem;
            border-radius: 0.35rem;
        }
        
        .form-actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
    </style>
</head>
<body>
    <%@include file="header-layout.jsp" %>
    
    <div class="main-content">
        <div class="container1 container">
            <div class="page-header">
                <h1><i class="fas fa-eye-slash"></i> Xác nhận ẩn công việc</h1>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>
            
            <c:set var="task" value="${requestScope.task}" />
            
            <div class="task-details">
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-heading"></i> Tiêu đề:</div>
                    <div class="detail-value">${task.title}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-align-left"></i> Mô tả:</div>
                    <div class="detail-value">${task.description}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-map-marker-alt"></i> Địa điểm:</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${task.location == 'Hanoi'}">Hà Nội</c:when>
                            <c:when test="${task.location == 'HCMC'}">Hồ Chí Minh</c:when>
                            <c:when test="${task.location == 'Danang'}">Đà Nẵng</c:when>
                            <c:otherwise>${task.location}</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-clock"></i> Thời gian:</div>
                    <div class="detail-value">${task.scheduledTime}</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-money-bill-wave"></i> Ngân sách:</div>
                    <div class="detail-value">${task.budget} VND</div>
                </div>
                
                <div class="detail-row">
                    <div class="detail-label"><i class="fas fa-info-circle"></i> Trạng thái:</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${task.status == 'pending'}">
                                <span class="status-badge status-pending">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${task.status == 'assigned'}">
                                <span class="status-badge status-assigned">Đã giao</span>
                            </c:when>
                            <c:when test="${task.status == 'completed'}">
                                <span class="status-badge status-completed">Hoàn thành</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">Không xác định</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="warning-message">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>Lưu ý:</strong> Bạn có chắc chắn muốn ẩn công việc này không? 
                    Công việc sẽ không hiển thị trong danh sách của bạn nữa và ứng viên sẽ không thế ứng tuyển.
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/hideTask" method="post">
                <input type="hidden" name="taskId" value="${task.taskId}" />
                <div class="form-actions">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-eye-slash"></i> Xác nhận ẩn
                    </button>
                    <button type="button" class="btn btn-secondary" 
                            onclick="window.location.href='${pageContext.request.contextPath}/loadJobPoster'">
                        <i class="fas fa-times"></i> Hủy bỏ
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <%@include file="footer.jsp" %>

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

        // Confirmation dialog for hide action
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!confirm('Bạn có thực sự muốn ẩn công việc này? Hành động này không thể hoàn tác.')) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>