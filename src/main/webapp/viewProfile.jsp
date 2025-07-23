<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem Hồ Sơ Ứng Viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f8f9fc;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 0.35rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-info {
            margin-bottom: 15px;
        }
        .profile-info label {
            font-weight: 600;
            color: #5a5c69;
            margin-right: 10px;
        }
        .profile-info span {
            color: #333;
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
        }
        .btn-primary {
            background-color: #4e73df;
            color: white;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
        }
        .reviews-section {
            margin-top: 30px;
        }
        .reviews-section h3 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #5a5c69;
        }
        .review-item {
            border-bottom: 1px solid #e3e6f0;
            padding: 15px 0;
        }
        .review-item:last-child {
            border-bottom: none;
        }
        .star-rating {
            color: #f1c40f;
            margin-bottom: 10px;
        }
        .review-comment {
            font-style: italic;
            color: #5a5c69;
        }
        .review-meta {
            font-size: 0.9rem;
            color: #858796;
        }
        .avg-rating {
            font-size: 1.2rem;
            font-weight: 600;
            color: #4e73df;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="profile-header">
            <h2><i class="fas fa-user"></i> Thông Tin Ứng Viên</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="profile-info">
            <label>Họ và tên:</label>
            <span>${workerName}</span>
        </div>
        <div class="profile-info">
            <label>Email:</label>
            <span>${workerEmail}</span>
        </div>
        <div class="profile-info">
            <label>Số điện thoại:</label>
            <span>${workerPhone}</span>
        </div>
        <div class="profile-info">
            <label>Địa chỉ:</label>
            <span>${workerAddress}</span>
        </div>

        <!-- Hiển thị điểm trung bình và số lượng đánh giá -->
        <div class="reviews-section">
            <h3><i class="fas fa-star"></i> Đánh Giá (${reviewCount} đánh giá)</h3>
            <div class="avg-rating">
                Điểm trung bình: 
                <c:choose>
                    <c:when test="${avgRating != 'Chưa có đánh giá' && avgRating != 'Lỗi khi tính điểm trung bình'}">
                        ${avgRating}/5 <i class="fas fa-star"></i>
                    </c:when>
                    <c:otherwise>
                        ${avgRating}
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Danh sách đánh giá -->
            <c:forEach var="review" items="${reviews}">
                <div class="review-item">
                    <div class="star-rating">
                        <c:forEach begin="1" end="${review.rating}">
                            <i class="fas fa-star"></i>
                        </c:forEach>
                        <c:forEach begin="${review.rating + 1}" end="5">
                            <i class="far fa-star"></i>
                        </c:forEach>
                    </div>
                    <div class="review-comment">"${review.comment}"</div>
                    <div class="review-meta">
                        Đánh giá cho công việc: ${review.taskTitle} - 
                        <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </div>
            </c:forEach>
        </div>

        <a href="${pageContext.request.contextPath}/loadJobPoster" class="btn btn-primary">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>
</body>
</html>