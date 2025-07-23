<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ứng Tuyển Công Việc - JobLinks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        /* Bố cục flexbox để footer bám dính */
        html {
            height: 100%;
        }
        body {
            margin: 0;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        .apply-container {
            max-width: 800px; /* Tăng từ 600px để hộp to hơn */
            margin: 50px auto;
            padding: 30px; /* Tăng padding để thoáng hơn */
            background: #e6f3ff; /* Nền xanh nhạt, đồng bộ với boosttask.jsp */
            border-radius: 12px; /* Bo góc mềm mại hơn */
            box-shadow: 0 4px 15px rgba(0,0,0,0.15); /* Bóng đậm hơn */
            flex: 1 0 auto;
            margin-top: 140px;
        }
        h1 {
            font-size: 28px; /* Tăng kích thước tiêu đề */
            margin-bottom: 25px;
            text-align: center;
            color: #333; /* Màu chữ xám đậm */
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 20px; /* Tăng khoảng cách giữa các phần tử */
        }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 16px; /* Tăng kích thước font nhãn */
            color: #333;
        }
        textarea {
            width: 100%;
            height: 150px; /* Tăng chiều cao textarea */
            padding: 12px;
            border: 1px solid #b3d7ff; /* Viền xanh nhạt */
            border-radius: 6px;
            font-size: 15px; /* Tăng kích thước font */
            resize: vertical; /* Chỉ cho phép kéo dãn chiều cao */
        }
        .btn-submit {
            background: #28a745;
            color: white;
            padding: 12px 30px; /* Tăng kích thước nút */
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease; /* Hiệu ứng hover */
        }
        .btn-submit:hover {
            background: #218838;
            transform: translateY(-2px); /* Hiệu ứng nâng nhẹ */
        }
        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: #3498db;
            text-decoration: none;
            font-size: 15px; /* Tăng kích thước font */
            font-weight: 500;
        }
        .back-link:hover {
            text-decoration: underline;
            color: #2c80b9; /* Màu hover đậm hơn */
        }
        .alert {
            padding: 15px; /* Tăng padding */
            margin-bottom: 20px;
            border-radius: 6px;
            font-size: 15px; /* Tăng kích thước font */
            border: 1px solid transparent; /* Thêm viền nhẹ */
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }
        
    </style>
</head>
<body>
    <!-- Header -->
    <%@include file="header-layout.jsp" %>

    <div class="apply-container">
        <h1>Ứng Tuyển Công Việc</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Đã gửi đơn ứng tuyển thành công
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/applyTask" method="post">
            <input type="hidden" name="task_id" value="${param.task_id}"/>
            <div class="form-group">
                <label for="message">Tin nhắn ứng tuyển:</label>
                <textarea id="message" name="message" required></textarea>
            </div>
            <button type="submit" name="action" value="apply" class="btn-submit">
                <i class="fas fa-check"></i> Gửi ứng tuyển
            </button>
        </form>

        <a href="${pageContext.request.contextPath}/tasks" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách công việc
        </a>
    </div>

    <!-- Footer -->
    <%@include file="footer.jsp" %>
</body>
</html>
