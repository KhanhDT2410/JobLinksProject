<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thông báo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .shadow {
            display: block;
            margin-top: 170px;
        }
        .action-btn {
            margin-right: 5px;
        }
    </style>
</head>

<body>
<div class="container">

    <%@include file="header-layout.jsp" %>

    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Danh sách thông báo</h4>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover table-striped mb-0">
                <thead class="table-light">
                    <tr class="text-center">
                        <th>Nội dung</th>
                        <th>Ngày gửi</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="notification" items="${notifications}">
                    <tr class="text-center align-middle">
                        <td class="text-center">${notification.message}</td>
                        <td>${notification.createdAt}</td>
                        <td>
                            <span class="badge ${notification.read ? 'bg-success' : 'bg-warning text-dark'}">
                                ${notification.read ? 'Đã đọc' : 'Chưa đọc'}
                            </span>
                        </td>
                        <td>
                            <div class="d-flex justify-content-center">
                                <c:if test="${not notification.read}">
                                    <form action="notifications" method="post" class="me-1">
                                        <input type="hidden" name="action" value="markAsRead" />
                                        <input type="hidden" name="notificationId" value="${notification.notificationId}" />
                                        <button type="submit" class="btn btn-sm btn-outline-primary action-btn">Đã đọc</button>
                                    </form>
                                </c:if>
                                <form action="notifications" method="post">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="notificationId" value="${notification.notificationId}" />
                                    <button type="submit" class="btn btn-sm btn-outline-danger action-btn">Xóa</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
</body>
</html>
