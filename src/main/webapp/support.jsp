<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.logging.Logger" %>
<% Logger logger = Logger.getLogger("customerSupport"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ Trợ Khách Hàng - JobLinks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        html { height: 100%; }
        body {
            margin: 0;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #f5f7fa;
            font-family: 'Roboto', sans-serif;
            color: #333;
        }
        .customer-support-page {
            flex: 1 0 auto;
        }
        .customer-support-page .main-content {
            padding: 40px 0;
            margin-top: 120px; /* Phù hợp với chiều cao header giả định */
        }
        .customer-support-page .container {
            margin: 0 auto;
            padding: 0 20px;
        }
        .customer-support-page .page-header {
            background: linear-gradient(90deg, #4e73df, #6a89cc);
            color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .customer-support-page .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .customer-support-page .breadcrumb {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .customer-support-page .support-section {
            background-color: white;
            padding: 2.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 3rem;
        }
        .customer-support-page .section-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 3px solid #4e73df;
        }
        .customer-support-page .form-group {
            margin-bottom: 1.5rem;
        }
        .customer-support-page .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            font-size: 1rem;
            color: #2c3e50;
        }
        .customer-support-page input, 
        .customer-support-page select,
        .customer-support-page textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #b3d7ff;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        .customer-support-page input:focus,
        .customer-support-page select:focus,
        .customer-support-page textarea:focus {
            border-color: #4e73df;
            outline: none;
            box-shadow: 0 0 5px rgba(78, 115, 223, 0.3);
        }
        .customer-support-page textarea {
            height: 140px;
            resize: vertical;
        }
        .customer-support-page .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            font-size: 1rem;
        }
        .customer-support-page .btn-primary {
            background-color: #4e73df;
            color: white;
        }
        .customer-support-page .btn-primary:hover {
            background-color: #3b5bb5;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .customer-support-page .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .customer-support-page .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .customer-support-page .btn-submit {
            background: #28a745;
            color: white;
            padding: 0.75rem 2rem;
            width: 100%;
        }
        .customer-support-page .btn-submit:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .customer-support-page .alert {
            padding: 1.2rem 1.5rem;
            margin-bottom: 2rem;
            border-radius: 6px;
            border-left: 5px solid;
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .customer-support-page .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border-left-color: #e74a3b;
        }
        .customer-support-page .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }
        .customer-support-page .faq-section {
            background-color: #f9fafc;
            padding: 2rem;
            border-radius: 6px;
            border-left: 5px solid #1cc88a;
            margin-bottom: 3rem;
        }
        .customer-support-page .faq-item {
            margin-bottom: 1.5rem;
        }
        .customer-support-page .faq-item strong {
            display: block;
            font-size: 1.1rem;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        .customer-support-page .faq-item p {
            margin: 0;
            color: #333;
            font-size: 1rem;
        }
        .customer-support-page .action-buttons {
            display: flex;
            gap: 1.5rem;
            margin-top: 2.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }
        @media (max-width: 768px) {
            .customer-support-page .main-content {
                padding: 20px 0;
                margin-top: 60px; /* Giảm margin-top trên mobile */
            }
            .customer-support-page .container {
                padding: 0 15px;
            }
            .customer-support-page .page-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
                padding: 1.5rem;
            }
            .customer-support-page .page-header h1 {
                font-size: 1.5rem;
            }
            .customer-support-page .support-section {
                padding: 1.5rem;
            }
            .customer-support-page .section-title {
                font-size: 1.4rem;
            }
            .customer-support-page .faq-section {
                padding: 1.5rem;
            }
            .customer-support-page .btn {
                padding: 0.6rem 1rem;
                font-size: 0.9rem;
            }
            .customer-support-page .action-buttons {
                flex-direction: column;
                gap: 1rem;
            }
        }
        @media (max-width: 576px) {
            .customer-support-page .page-header h1 {
                font-size: 1.3rem;
            }
            .customer-support-page .section-title {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="customer-support-page">
        <%@include file="header-layout.jsp" %>
        <div class="main-content">
            <div class="container">
                <div class="page-header">
                    <h1><i class="fas fa-headset"></i> Hỗ Trợ Khách Hàng</h1>
                    <div class="breadcrumb">
                        <a href="home" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại Trang Chủ
                        </a>
                    </div>
                </div>

                <% 
                    String errorMessage = (String) request.getAttribute("error");
                    String successMessage = (String) request.getAttribute("success");
                    logger.info("Support page accessed. Error: " + errorMessage + ", Success: " + successMessage);
                %>

                <!-- Form gửi yêu cầu hỗ trợ -->
                <div class="support-section">
                    <h2 class="section-title"><i class="fas fa-envelope"></i> Gửi Yêu Cầu Hỗ Trợ</h2>
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${success}
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/submitSupportRequest" method="post">
                        <div class="form-group">
                            <label for="name">Họ và Tên:</label>
                            <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" class="form-control" name="email" value="${user.email}" required>
                        </div>
                        <div class="form-group">
                            <label for="subject">Chủ đề:</label>
                            <select id="subject" name="subject" required>
                                <option value="" disabled selected>Chọn chủ đề</option>
                                <option value="task_issue">Vấn đề về công việc</option>
                                <option value="account_issue">Vấn đề về tài khoản</option>
                                <option value="payment_issue">Vấn đề về thanh toán</option>
                                <option value="other">Khác</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="message">Nội dung yêu cầu:</label>
                            <textarea id="message" name="message" placeholder="Mô tả chi tiết vấn đề của bạn..." required></textarea>
                        </div>
                        <button type="submit" name="action" value="submit" class="btn btn-submit">
                            <i class="fas fa-check"></i> Gửi Yêu Cầu
                        </button>
                    </form>
                </div>

                <!-- FAQ Section -->
                <div class="faq-section">
                    <h2 class="section-title"><i class="fas fa-question-circle"></i> Câu Hỏi Thường Gặp</h2>
                    <div class="faq-item">
                        <strong>Làm thế nào để ứng tuyển công việc?</strong>
                        <p>Đi đến trang chi tiết công việc, điền thông tin vào form ứng tuyển và nhấn "Gửi ứng tuyển".</p>
                    </div>
                    <div class="faq-item">
                        <strong>Tôi có thể chỉnh sửa thông tin tài khoản ở đâu?</strong>
                        <p>Bạn có thể chỉnh sửa thông tin tài khoản trong mục "Hồ sơ" trên trang dashboard.</p>
                    </div>
                    <div class="faq-item">
                        <strong>Làm thế nào để kiểm tra trạng thái yêu cầu hỗ trợ?</strong>
                        <p>Sau khi gửi yêu cầu, bạn sẽ nhận được email xác nhận và cập nhật trạng thái qua email.</p>
                    </div>
                    <div class="faq-item">
                        <strong>Tôi gặp vấn đề về thanh toán, phải làm gì?</strong>
                        <p>Vui lòng gửi yêu cầu hỗ trợ với chủ đề "Vấn đề về thanh toán" và mô tả chi tiết.</p>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="home" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại Trang Chủ
                    </a>
                    <a href="#support-section" class="btn btn-primary" onclick="document.querySelector('.support-section').scrollIntoView({behavior: 'smooth'})">
                        <i class="fas fa-paper-plane"></i> Gửi Yêu Cầu Hỗ Trợ
                    </a>
                </div>
            </div>
        </div>
        <jsp:include page="footer.jsp" />
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>