<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Task" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ page import="model.TaskApplication" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<% Logger logger = Logger.getLogger("taskDetailsWithApply"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết và Ứng Tuyển Công Việc - JobLinks</title>
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
        background-color: #f5f7fa; /* Nền sáng cho toàn trang */
        font-family: 'Roboto', sans-serif;
        color: #333;
    }
    .task-details-page {
        flex: 1 0 auto;
    }
    .task-details-page .main-content {
        padding: 40px 0;
        margin-top: 100px;
    }
    .task-details-page .container {
        margin: 0 auto;
        padding: 0 30px; /* Tăng padding trái/phải */
        max-width: 1200px; /* Giới hạn chiều rộng */
    }
    .task-details-page .page-header {
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
    .task-details-page .page-header h1 {
        font-size: 2rem;
        font-weight: 700;
        margin: 0;
        text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .task-details-page .breadcrumb {
        display: flex;
        gap: 15px;
        align-items: center;
    }
    .task-details-page .task-details,
    .task-details-page .applications-section,
    .task-details-page .recommended-tasks-section {
        padding: 2.5rem;
        border-radius: 8px;
        margin-bottom: 3rem;
        margin-left: 15px; /* Khoảng cách trái */
        margin-right: 15px; /* Khoảng cách phải */
    }
    .task-details-page .task-title {
        font-size: 1.75rem;
        font-weight: 700;
        color: #1a3c34; /* Màu chữ đậm, rõ */
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 3px solid #4e73df;
    }
    .task-details-page .task-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 2rem; /* Tăng khoảng cách giữa các box con */
        margin-bottom: 2rem;
    }
    .task-details-page .task-info {
        padding: 1.5rem;
        background-color: #ffffff; /* Nền trắng */
        border-radius: 6px;
        border: 1px solid #d1d3e2; /* Viền sáng */
        box-shadow: 0 2px 8px rgba(0,0,0,0.06); /* Bóng nhẹ */
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .task-details-page .task-info:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    }
    .task-details-page .task-info strong {
        color: #1a3c34; /* Màu đậm, rõ */
        font-weight: 700;
        margin-bottom: 0.5rem;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .task-details-page .task-info-value {
        color: #333;
        font-size: 1.1rem;
    }
    .task-details-page .task-description,
    .task-details-page .apply-section {
        background-color: #ffffff; /* Nền trắng */
        padding: 2rem;
        border-radius: 6px;
        border: 1px solid #d1d3e2; /* Viền sáng */
        box-shadow: 0 2px 8px rgba(0,0,0,0.06); /* Bóng nhẹ */
        margin-bottom: 2rem;
    }
    .task-details-page .task-description strong,
    .task-details-page .apply-section strong {
        color: #1a3c34;
        font-weight: 700;
        margin-bottom: 1rem;
        font-size: 1.1rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: block;
    }
    .task-details-page .applications-section h3 {
        font-size: 1.5rem;
        font-weight: 700;
        color: #1a3c34;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 3px solid #4e73df;
    }
    .task-details-page .application-card {
        background-color: #ffffff; /* Nền trắng */
        border: 1px solid #d1d3e2; /* Viền sáng */
        border-radius: 6px;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06); /* Bóng nhẹ */
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .task-details-page .application-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    }
    .task-details-page .application-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 2rem; /* Tăng khoảng cách */
        margin-bottom: 1.5rem;
    }
    .task-details-page .application-info strong {
        color: #1a3c34;
        font-weight: 700;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.5rem;
    }
    .task-details-page .application-message {
        grid-column: 1 / -1;
        background-color: #ffffff;
        padding: 1.2rem;
        border-radius: 6px;
        border: 1px solid #d1d3e2;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .task-details-page .status-badge {
        padding: 0.4rem 1rem;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .task-details-page .status-pending {
        background-color: #fff3cd;
        color: #856404;
    }
    .task-details-page .status-accepted {
        background-color: #d4edda;
        color: #155724;
    }
    .task-details-page .status-rejected {
        background-color: #f8d7da;
        color: #721c24;
    }
    .task-details-page .badge-boosted {
        background: linear-gradient(45deg, rgb(255, 107, 107), rgb(255, 142, 83));
        color: white;
        padding: 0.4rem 0.8rem;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }
    .task-details-page .task-actions {
        display: flex;
        gap: 1rem;
        margin-top: 1.5rem;
        padding-top: 1.2rem;
        border-top: 1px solid #d1d3e2;
    }
    .task-details-page .btn {
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
    .task-details-page .btn-primary {
        background-color: #4e73df;
        color: white;
    }
    .task-details-page .btn-primary:hover {
        background-color: #3b5bb5;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .task-details-page .btn-secondary {
        background-color: #6c757d;
        color: white;
    }
    .task-details-page .btn-secondary:hover {
        background-color: #5a6268;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .task-details-page .btn-accept {
        background-color: #28a745;
        color: white;
    }
    .task-details-page .btn-accept:hover {
        background-color: #218838;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .task-details-page .btn-reject {
        background-color: #e74a3b;
        color: white;
    }
    .task-details-page .btn-reject:hover {
        background-color: #c0392b;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .task-details-page .btn-disabled {
        background-color: #e9ecef;
        color: #6c757d;
        cursor: not-allowed;
        pointer-events: none;
    }
    .task-details-page .alert {
        padding: 1.2rem 1.5rem;
        margin-bottom: 2rem;
        border-radius: 6px;
        border-left: 5px solid;
        font-size: 1rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .task-details-page .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        border-left-color: #e74a3b;
    }
    .task-details-page .alert-success {
        background-color: #d4edda;
        color: #155724;
        border-left-color: #28a745;
    }
    .task-details-page .no-applications {
        text-align: center;
        padding: 2.5rem;
        color: #6c757d;
        font-style: italic;
        background-color: #ffffff;
        border-radius: 6px;
        border: 1px solid #d1d3e2;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .task-details-page .action-buttons {
        display: flex;
        gap: 1.5rem;
        margin-top: 2.5rem;
        flex-wrap: wrap;
        justify-content: center;
    }
    .task-details-page .form-group {
        margin-bottom: 1.5rem;
    }
    .task-details-page .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 0.5rem;
        font-size: 1rem;
        color: #1a3c34;
    }
    .task-details-page textarea {
        width: 100%;
        height: 140px;
        padding: 0.75rem;
        border: 1px solid #b3d7ff;
        border-radius: 6px;
        font-size: 1rem;
        resize: vertical;
        transition: border-color 0.3s ease;
    }
    .task-details-page textarea:focus {
        border-color: #4e73df;
        outline: none;
        box-shadow: 0 0 5px rgba(78, 115, 223, 0.3);
    }
    .task-details-page .btn-submit {
        background: #28a745;
        color: white;
        padding: 0.75rem 2rem;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 1rem;
        transition: background-color 0.3s ease, transform 0.2s ease;
        width: 100%;
    }
    .task-details-page .btn-submit:hover {
        background: #218838;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .task-details-page .back-link {
        display: inline-block;
        margin-top: 1.5rem;
        color: #4e73df;
        text-decoration: none;
        font-size: 1rem;
        font-weight: 500;
        transition: color 0.3s ease;
    }
    .task-details-page .back-link:hover {
        color: #3b5bb5;
        text-decoration: underline;
    }
    @media (max-width: 768px) {
        .task-details-page .main-content {
            padding: 20px 0;
            margin-top: 80px;
        }
        .task-details-page .container {
            padding: 0 15px;
        }
        .task-details-page .page-header {
            flex-direction: column;
            gap: 1rem;
            text-align: center;
            padding: 1.5rem;
        }
        .task-details-page .page-header h1 {
            font-size: 1.5rem;
        }
        .task-details-page .task-details,
        .task-details-page .applications-section,
        .task-details-page .recommended-tasks-section {
            padding: 1.5rem;
            margin-left: 10px; 
            margin-right: 10px;
        }
        .task-details-page .task-title {
            font-size: 1.4rem;
        }
        .task-details-page .task-info-grid {
            grid-template-columns: 1fr;
            gap: 1.5rem;
        }
        .task-details-page .application-info-grid {
            grid-template-columns: 1fr;
            gap: 1.5rem;
        }
        .task-details-page .task-description,
        .task-details-page .apply-section {
            padding: 1.5rem;
        }
        .task-details-page .btn {
            padding: 0.6rem 1rem;
            font-size: 0.9rem;
        }
</style>
</head>
<body>
    <div class="task-details-page">
        <%@include file="header-layout.jsp" %>
        <div class="main-content">
            <div class="container">
                <div class="page-header">
                    <h1><i class="fas fa-info-circle"></i> Ứng Tuyển Công Việc</h1>
                    <div class="breadcrumb">
                        <a href="tasks" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại Danh Sách
                        </a>
                    </div>
                </div>

                <% 
                    Task task = (Task) request.getAttribute("task");
                    String errorMessage = (String) request.getAttribute("error");
                    Boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
                    Integer userId = (Integer) session.getAttribute("userId");
                    List<TaskApplication> applications = (List<TaskApplication>) request.getAttribute("applications");
                    logger.info("Task from request attribute: " + (task != null ? task.getTitle() : "null"));
                %>

                <% if (errorMessage != null || task == null) { %>
                    <div class="alert alert-error">
                        <h2><i class="fas fa-exclamation-triangle"></i> Lỗi!</h2>
                        <p>Đã xảy ra lỗi khi xử lý yêu cầu của bạn.</p>
                        <p><strong>Thông báo lỗi:</strong> <%= errorMessage != null ? errorMessage : "Công việc không tồn tại." %></p>
                        <div style="margin-top: 1rem;">
                            <a href="tasks" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại Danh Sách Công Việc
                            </a>
                        </div>
                    </div>
                <% } else { %>
                    <div class="task-details">
                        <div class="d-flex justify-content-between align-items-center task-title mb-3">
                            <div>
                                <i class="fas fa-briefcase"></i>
                                <%= task.getTitle() != null ? task.getTitle() : "Không có tiêu đề" %>
                            </div>
                            <button class="btn btn-outline-primary btn-sm" id="supportBtn">
                                <i class="fas fa-headset"></i> Hỗ trợ khách hàng
                            </button>
                        </div>
                            <script>
                                document.getElementById("supportBtn").addEventListener("click", function () {
                                    const popup = document.getElementById("supportPopup");
                                    popup.style.display = popup.style.display === "none" ? "block" : "none";
                                });
                            </script>

                            <!-- Popup hỗ trợ khách hàng -->
                        <div id="supportPopup" style="display:none; position:fixed; top:20%; right:5%; z-index:1050; background:#fff; border:1px solid #ccc; padding:20px; border-radius:8px; box-shadow:0 4px 12px rgba(0,0,0,0.2); width:280px;">
                            <h5 class="mb-3"><i class="fas fa-life-ring"></i> Báo cáo</h5>
                            <ul style="list-style:none; padding:0; margin:0;">
                                <li class="mb-2">
                                    <a href="${pageContext.request.contextPath}/report?userId=<%= task.getUserId() %>" class="btn btn-link w-100 text-start">
                                        <i class="fas fa-user-slash"></i> Report người dùng
                                    </a>
                                </li>
                                <li class="mb-2">
                                    <a href="${pageContext.request.contextPath}/report?taskId=<%= task.getTaskId() %>&userId=<%= task.getUserId() %>" class="btn btn-link w-100 text-start">
                                        <i class="fas fa-flag"></i> Report người dùng và task
                                    </a>
                                </li>
                            </ul>
                            <button class="btn btn-secondary btn-sm mt-3 w-100" onclick="document.getElementById('supportPopup').style.display='none'">Đóng</button>
                        </div>

                        
                        <div class="task-info-grid">
                            <div class="task-info">
                                <strong><i class="fas fa-user"></i> Khách hàng</strong>
                                <span class="task-info-value"><%= task.getClientName() != null ? task.getClientName() : "Không xác định" %></span>
                            </div>
                            
                            <% if (task.getCategoryName() != null) { %>
                            <div class="task-info">
                                <strong><i class="fas fa-tags"></i> Danh mục</strong>
                                <span class="task-info-value"><%= task.getCategoryName() %></span>
                            </div>
                            <% } %>
                            
                            <div class="task-info">
                                <strong><i class="fas fa-map-marker-alt"></i> Địa điểm</strong>
                                <span class="task-info-value"><%= task.getLocation() != null ? task.getLocation() : "Không xác định" %></span>
                            </div>
                            
                            <% if (task.getScheduledTime() != null) { %>
                            <div class="task-info">
                                <strong><i class="fas fa-clock"></i> Thời gian dự kiến</strong>
                                <span class="task-info-value"><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(task.getScheduledTime()) %></span>
                            </div>
                            <% } %>
                            
                            <div class="task-info">
                                <strong><i class="fas fa-dollar-sign"></i> Ngân sách</strong>
                                <span class="task-info-value"><%= String.format("%.2f", task.getBudget()) %> VNĐ</span>
                            </div>
                            
                            <div class="task-info">
                                <strong><i class="fas fa-info-circle"></i> Trạng thái</strong>
                                <span class="task-info-value">
                                    <span class="status-badge status-<%= task.getStatus() != null ? task.getStatus().toLowerCase() : "pending" %>">
                                        <%= task.getStatus() != null ? task.getStatus() : "N/A" %>
                                    </span>
                                </span>
                            </div>
                            
                            <% if (hasApplied != null && hasApplied) { %>
                            <div class="task-info">
                                <strong><i class="fas fa-check-circle"></i> Trạng thái ứng tuyển</strong>
                                <span class="task-info-value">
                                    <span class="status-badge status-accepted">Đã ứng tuyển</span>
                                </span>
                            </div>
                            <% } %>
                        </div>
                        
                        <div class="task-description">
                            <strong><i class="fas fa-file-text"></i> Mô tả công việc</strong>
                            <div class="task-info-value">
                                <%= task.getDescription() != null ? task.getDescription().replace("\n", "<br>") : "Không có mô tả" %>
                            </div>
                        </div>

                        <!-- Form ứng tuyển -->
                        <% 
                            boolean isTaskOwner = userId != null && task.getUserId() == userId.intValue();
                            if (hasApplied == null || !hasApplied) {
                                if (!isTaskOwner) { %>
                                    <div class="apply-section">
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
                                        <form action="${pageContext.request.contextPath}/tasks" method="post">
    <input type="hidden" name="task_id" value="<%= task.getTaskId() %>"/>
    <input type="hidden" name="action" value="apply"/>
    <div class="form-group">
        <label for="message">Tin nhắn ứng tuyển:</label>
        <textarea id="message" name="message" placeholder="Viết lời nhắn ứng tuyển của bạn..." required></textarea>
    </div>
    <button type="submit" class="btn btn-submit">
        <i class="fas fa-check"></i> Gửi ứng tuyển
    </button>
</form>
                                    </div>
                                <% }
                            }
                        %>
                    </div>

                    <div class="action-buttons">
                        <a href="tasks" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại Danh Sách Công Việc
                        </a>
                        <% if (hasApplied == null || !hasApplied) {
                            if (isTaskOwner) { %>
                                <span class="btn btn-disabled" title="Bạn không thể ứng tuyển cho công việc của chính mình">
                                    <i class="fas fa-ban"></i> Ứng Tuyển Ngay
                                </span>
                            <% } %>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>
            <!-- Thêm vào sau phần task-details hoặc trước footer -->
<% if (task != null) { %>
<div class="recommended-tasks-section">
    <h3 class="mt-5 mb-4"><i class="fas fa-star"></i> Công Việc Được Đề Xuất</h3>
    <c:if test="${empty recommendedTasks}">
        <div class="no-applications">
            <i class="fas fa-info-circle"></i> Không có công việc được đề xuất nào.
        </div>
    </c:if>
    <c:if test="${not empty recommendedTasks}">
        <div class="task-info-grid">
            <c:forEach var="recTask" items="${recommendedTasks}">
    <div class="task-info">
        <div class="d-flex justify-content-between align-items-center">
            <strong><i class="fas fa-briefcase"></i> <c:out value="${recTask.title}" /></strong>
            <c:if test="${recTask.boosted}">
                <span class="badge badge-boosted"><i class="fas fa-fire"></i> HOT</span>
            </c:if>
        </div>
                    <div class="task-info-value">
                        <p><strong>Ngân sách:</strong> <fmt:formatNumber value="${recTask.budget}" type="currency" currencySymbol="VNĐ" /></p>
                        <p><strong>Địa điểm:</strong> <c:out value="${recTask.location != null ? recTask.location : 'Không xác định'}" /></p>
                        <p><strong>Danh mục:</strong> <c:out value="${recTask.categoryName != null ? recTask.categoryName : 'Không xác định'}" /></p>
                        <a href="${pageContext.request.contextPath}/tasks?action=details&taskId=${recTask.taskId}" class="btn btn-primary btn-sm mt-2">
                            <i class="fas fa-info-circle"></i> Xem chi tiết
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<% } %>
        <jsp:include page="footer.jsp" />
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</body>
</html>