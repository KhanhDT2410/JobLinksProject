<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa công việc</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #3b82f6; /* Softer blue for professional feel */
            --secondary-color: #10b981; /* Vibrant green for accents */
            --danger-color: #ef4444; /* Modern red for errors/cancel */
            --warning-color: #f59e0b; /* Warm yellow for warnings */
            --light-color: #f9fafb; /* Light gray background */
            --dark-color: #1f2a44; /* Darker text for contrast */
            --border-color: #e5e7eb; /* Subtle border color */
            --shadow-color: rgba(0, 0, 0, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--light-color);
            color: var(--dark-color);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .dropdown {
            position: relative;
        }

        .dropdown-toggle {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.5rem;
            color: var(--dark-color);
            transition: color 0.3s;
        }

        .dropdown-toggle:hover {
            color: var(--primary-color);
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            box-shadow: 0 4px 6px var(--shadow-color);
            border-radius: 0.375rem;
            min-width: 200px;
            z-index: 1000;
            animation: slideIn 0.2s ease-out;
        }

        .dropdown-menu.show {
            display: block;
        }

        .dropdown-item {
            display: block;
            padding: 0.75rem 1rem;
            color: var(--dark-color);
            text-decoration: none;
            font-size: 0.95rem;
            transition: background-color 0.3s, color 0.3s;
        }

        .dropdown-item:hover {
            background-color: var(--light-color);
            color: var(--primary-color);
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Main content styles */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 2rem 1rem;
            margin-top: 130px;
        }

        .container1 {
            background-color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 12px var(--shadow-color);
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            transition: transform 0.3s ease;
        }

        .container1:hover {
            transform: translateY(-2px);
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--primary-color) 0%, #60a5fa 100%);
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px var(--shadow-color);
        }

        .page-header h1 {
            font-size: 1.875rem;
            color: white;
            font-weight: 700;
            margin: 0;
            letter-spacing: 0.02em;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
            font-size: 0.95rem;
        }

        input, textarea, select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 0.375rem;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
            background-color: #fff;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .category-display {
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 0.375rem;
            font-size: 1rem;
            background-color: var(--light-color);
            color: var(--dark-color);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.375rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            font-size: 0.95rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .btn-danger:hover {
            background-color: #dc2626;
            transform: translateY(-1px);
        }

        .btn-login {
            background-color: white;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-login:hover {
            background-color: rgba(59, 130, 246, 0.1);
        }

        .error {
            color: var(--danger-color);
            margin-bottom: 1rem;
            text-align: center;
            font-size: 0.9rem;
            background-color: rgba(239, 68, 68, 0.1);
            padding: 0.5rem;
            border-radius: 0.375rem;
        }

        .disabled {
            opacity: 0.6;
            cursor: not-allowed;
            pointer-events: none;
            background-color: #e5e7eb;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }

            .menu, .nav {
                flex-direction: column;
                align-items: center;
            }

            .container1 {
                padding: 1.5rem;
                margin: 0 1rem;
            }

            .page-header h1 {
                font-size: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .btn {
                padding: 0.5rem 1rem;
                font-size: 0.9rem;
            }

            input, textarea, select {
                font-size: 0.95rem;
            }
        }
    </style>
</head>
<body>
    <%@include file="header-layout.jsp" %>
    
    <div class="main-content">
        <div class="container1 container">
            <div class="page-header">
                <h1>Chỉnh sửa công việc</h1>
            </div>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:set var="task" value="${requestScope.task}" />
            <form action="${pageContext.request.contextPath}/editTask" method="post">
                <input type="hidden" name="taskId" value="${task.taskId}">
                <div class="form-group">
                    <label for="title">Tiêu đề (không được vượt quá 10 từ):</label>
                    <input type="text" id="title" name="title" value="${task.title}" 
                        ${taskStatus == 'COMPLETED' ? 'disabled' : ''} required>
                </div>
                <div class="form-group">
                    <label for="description">Mô tả (Vui lòng ghi rõ địa chỉ cụ thể để người làm dễ dàng tiếp cận công việc)(không được vượt quá 20 từ):</label>
                    <textarea id="description" name="description" rows="3" 
                        ${taskStatus == 'COMPLETED' ? 'disabled' : ''} required>${task.description}</textarea>
                </div>
                <div class="form-group">
                    <label for="categoryId">Danh mục:</label>
                    <c:choose>
                        <c:when test="${taskStatus == 'COMPLETED'}">
                            <div class="category-display">
                                <c:forEach var="category" items="${categories}">
                                    <c:if test="${category.categoryId == task.categoryId}">
                                        ${category.name}
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <select id="categoryId" name="categoryId" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}"
                                            <c:if test="${category.categoryId == task.categoryId}">selected</c:if>>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="form-group">
                    <label for="location">Địa điểm:</label>
                    <select id="location" name="location" required ${taskStatus == 'COMPLETED' ? 'disabled' : ''}>
                        <option value="">Chọn địa điểm</option>
                        <option value="Hanoi" ${task.location == 'Hanoi' ? 'selected' : ''}>Hà Nội</option>
                        <option value="HCMC" ${task.location == 'HCMC' ? 'selected' : ''}>Hồ Chí Minh</option>
                        <option value="Danang" ${task.location == 'Danang' ? 'selected' : ''}>Đà Nẵng</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="scheduledTime">Thời gian dự kiến (yyyy-MM-dd'T'HH:mm):</label>
                    <input type="datetime-local" id="scheduledTime" name="scheduledTime" 
                        value="${formattedScheduledTime}" ${taskStatus == 'COMPLETED' ? 'disabled' : ''} required>
                </div>
                <div class="form-group">
                    <label for="budget">Ngân sách (VND)(Công việc vui lòng dưới 10tr đồng nếu có giá trị lớn hơn vui lòng liên hệ CSKH):</label>
                    <input type="number" id="budget" name="budget" step="0.01" value="${task.budget}" 
                        ${taskStatus == 'COMPLETED' ? 'disabled' : ''} required>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" 
                        ${taskStatus == 'COMPLETED' ? 'disabled' : ''}>
                        <i class="fas fa-save"></i> Lưu
                    </button>
                    <a href="${pageContext.request.contextPath}/loadJobPoster" class="btn btn-danger">
                        <i class="fas fa-times"></i> Hủy
                    </a>
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
    </script>
</body>
</html>