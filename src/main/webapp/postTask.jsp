<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng công việc mới</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 0;
        }
        
        .container {
            background-color: white;
            padding: 2rem;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            width: 100%;
            max-width: 500px;
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
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        input, textarea, select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #e3e6f0;
            border-radius: 0.25rem;
            font-size: 1rem;
            box-sizing: border-box;
        }
        
        textarea {
            resize: vertical;
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
            margin-right: 10px;
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
            transform: translateY(-1px);
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #be2617;
        }
        
        .btn-login {
            background-color: #ffffff;
            border: 1px solid #3498db;
            color: #3498db;
        }

        .btn-login:hover {
            background-color: #e9ecef;
        }
        
        .error {
            color: var(--danger-color);
            margin-bottom: 10px;
            text-align: center;
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
    </style>
</head>
<body>
    <%@include file="jobPosterHeader.jsp" %>
    
    <div class="main-content">
        <div class="container">
            <div class="page-header">
                <h1>Đăng công việc mới</h1>
            </div>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/postTask" method="post">
                <div class="form-group">
                    <label for="title">Tiêu đề (không được vượt quá 10 từ):</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-group">
                    <label for="description">Mô tả (Vui lòng ghi rõ địa chỉ cụ thể để người làm dễ dàng tiếp cận công việc)(không được vượt quá 20 từ):</label>
                    <textarea id="description" name="description" rows="3" required></textarea>
                </div>
                <div class="form-group">
                    <label for="categoryId">Danh mục:</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">Chọn danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}">${category.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="location">Địa điểm:</label>
                    <select id="location" name="location" required>
                        <option value="">Chọn địa điểm</option>
                        <option value="Hanoi">Hà Nội</option>
                        <option value="HCMC">Hồ Chí Minh</option>
                        <option value="Danang">Đà Nẵng</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="scheduledTime">Thời gian dự kiến (yyyy-MM-dd'T'HH:mm):</label>
                    <input type="datetime-local" id="scheduledTime" name="scheduledTime" required>
                </div>
                <div class="form-group">
                    <label for="budget">Ngân sách (VND)(Công việc vui lòng dưới 10tr đồng nếu có giá trị lớn hơn vui lòng liên hệ CSKH):</label>
                    <input type="number" id="budget" name="budget" step="0.01" required>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Đăng công việc
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/loadJobPoster'">
                        <i class="fas fa-arrow-left"></i> Trở lại
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <%@include file="jobPosterFooter.jsp" %>

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