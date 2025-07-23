<%-- 
    Document   : footer
    Created on : Jun 14, 2025, 10:48:11 PM
    Author     : lylua
--%>

<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        /* Footer */
.footer {
    background-color: #2c3e50;
    color: var(--white);
    padding: 60px 0 0;
}

.footer-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

.footer-col {
    margin-bottom: 40px;
}

.footer-title {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 20px;
    position: relative;
    padding-bottom: 10px;
}

.footer-title::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: 0;
    width: 50px;
    height: 2px;
    background-color: var(--primary-color);
}

.footer-links {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-links li {
    margin-bottom: 10px;
}

.footer-links a {
    color: rgba(255, 255, 255, 0.8);
    text-decoration: none;
    transition: var(--transition);
}

.footer-links a:hover {
    color: var(--white);
    padding-left: 5px;
}

.footer-contact {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-contact li {
    margin-bottom: 15px;
    display: flex;
    align-items: flex-start;
    gap: 10px;
}

.footer-contact i {
    color: var(--primary-color);
    margin-top: 3px;
}

.newsletter-form {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.social-links {
    display: flex;
    gap: 15px;
    margin-top: 20px;
}

.social-links a {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    color: var(--white);
    transition: var(--transition);
}

.social-links a:hover {
    background-color: var(--primary-color);
    transform: translateY(-3px);
}

.footer-bottom {
    background-color: rgba(0, 0, 0, 0.2);
    padding: 20px 0;
    margin-top: 40px;
}

.footer-bottom p {
    text-align: center;
    margin: 0;
    font-size: 0.9rem;
    color: rgba(255, 255, 255, 0.7);
}

.footer-legal {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 10px;
}

.footer-legal a {
    color: rgba(255, 255, 255, 0.7);
    text-decoration: none;
    font-size: 0.9rem;
    transition: var(--transition);
}

.footer-legal a:hover {
    color: var(--white);
}
/* Back to Top */
.back-to-top {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 50px;
    height: 50px;
    background-color: var(--primary-color);
    color: var(--white);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    opacity: 0;
    visibility: hidden;
    transition: var(--transition);
    z-index: 999;
}

.back-to-top.show {
    opacity: 1;
    visibility: visible;
}

.back-to-top:hover {
    background-color: var(--primary-hover);
    transform: translateY(-3px);
}

/* Responsive Adjustments */
@media (max-width: 992px) {
    .hero-content {
        grid-template-columns: 1fr;
        gap: 2rem;
    }
    
    .hero-text {
        order: 1;
        text-align: center;
    }
    
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .header-content {
        flex-direction: column;
        gap: 15px;
    }
    
    .menu {
        flex-direction: column;
        gap: 25px;
    }
    
    .nav {
        flex-direction: column;
        gap: 10px;
        text-align: center;
    }
    
    .header-actions {
        justify-content: center;
    }
    
    .hero-title {
        font-size: 2rem;
    }
    
    .cta-actions {
        flex-direction: column;
        align-items: center;
    }
}

@media (max-width: 576px) {
    .stats-grid {
        grid-template-columns: 1fr;
    }
    
    .filter-form {
        grid-template-columns: 1fr;
    }
    
    .tasks-grid, .workers-grid, .reviews-grid {
        grid-template-columns: 1fr;
    }
    
    .footer-grid {
        grid-template-columns: 1fr;
    }
}
        </style>
    </head>
    <body>
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
                    <p>&copy; 2025 JobLinks. Bảo lưu mọi quyền.</p>
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
        </script>
    </body>
</html>
