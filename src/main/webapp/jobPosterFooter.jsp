<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <h3 class="footer-title">Về JobLinks</h3>
                <p>JobLinks là nền tảng kết nối nhà tuyển dụng và người tìm việc uy tín hàng đầu Việt Nam.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h3 class="footer-title">Liên kết nhanh</h3>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/tasks">Công việc</a></li>
                    <li><a href="#">Nhà tuyển dụng</a></li>
                    <li><a href="#">Ứng viên</a></li>
                    <li><a href="help.jsp">Trợ giúp</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h3 class="footer-title">Thông tin liên hệ</h3>
                <ul class="footer-contact">
                    <li><i class="fas fa-map-marker-alt"></i> VIETNAM</li>
                    <li><i class="fas fa-phone"></i> 0 1234 5678</li>
                    <li><i class="fas fa-envelope"></i> info@joblinks.vn</li>
                </ul>
            </div>
            <div class="footer-col">
                <h3 class="footer-title">Đăng ký nhận bản tin</h3>
                <form class="newsletter-form">
                    <input type="email" placeholder="Email của bạn" class="form-control">
                    <button type="submit" class="btn btn-primary">Đăng ký</button>
                </form>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2025 JobLinks. Bảo lưu mọi quyền.</p>
            <div class="footer-legal">
                <a href="#">Điều khoản sử dụng</a>
                <a href="#">Chính sách bảo mật</a>
            </div>
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<a href="#" class="back-to-top" id="backToTop">
    <i class="fas fa-arrow-up"></i>
</a>

<style>
    .footer {
        background-color: #2c3e50;
        color: white;
        padding: 1.5rem;
        text-align: center;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
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

    .btn-primary {
        background-color: #3498db;
        color: white;
        border: none;
        padding: 0.5rem 1rem;
        border-radius: 0.35rem;
        cursor: pointer;
    }

    .btn-primary:hover {
        background-color: #2980b9;
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

<script>
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
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
</script>
