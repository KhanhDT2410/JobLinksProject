<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh sách người dùng - Admin</title>

    <!-- SB‑Admin‑2 assets -->
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        body { font-size: 1.1rem; }
        .h1,.h2,.h3,.h4,.h5,.h6,h1,h2,h3,h4,h5,h6 { font-size: 1.25em; }
        .sidebar .nav-item .nav-link,
        .navbar .nav-link, .navbar .dropdown-toggle,
        .form-control, .btn { font-size: 1.1rem; }
        .card .h5 { font-size: 1.4rem; }
    </style>
</head>

<body id="page-top">
<div id="wrapper">

    <%-- Sidebar --%>
    <jsp:include page="admin_include/admin-sidebar.jsp"/>

    <div id="content-wrapper" class="d-flex flex-column" style="margin-left:240px;">
        <div id="content">

            <%-- Topbar --%>
            <jsp:include page="admin_include/admin-header.jsp"/>

            <div class="container-fluid">
                <!-- Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Danh sách người dùng</h1>
                </div>

                <!-- User Table -->
                <div class="card shadow mb-4">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" width="100%" cellspacing="0">
                                <thead class="thead-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Xác minh OTP</th>
                                    <th>Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.userId}</td>
                                        <td>${user.fullName}</td>
                                        <td>${user.email}</td>
                                        <td>${user.role}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.locked}">
                                                    <span class="badge bg-danger">Khóa</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.verified}">
                                                    <span class="badge bg-success">Đã xác minh</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">Chưa xác minh</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a class="btn btn-sm btn-primary"
                                               href="AdminManageUserServlet?action=edit&id=${user.userId}">Edit</a>
                                            <a class="btn btn-sm btn-danger"
                                               href="AdminManageUserServlet?action=delete&id=${user.userId}"
                                               onclick="return confirm('Bạn chắc chắn muốn xóa?');">Delete</a>
                                            <c:choose>
                                                <c:when test="${user.locked}">
                                                    <a class="btn btn-sm btn-warning"
                                                       href="AdminManageUserServlet?action=unlock&id=${user.userId}">Mở khóa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="btn btn-sm btn-secondary"
                                                       href="AdminManageUserServlet?action=lock&id=${user.userId}">Khóa</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="User pagination">
                            <ul class="pagination justify-content-center">
                                <li class="page-item <c:if test='${currentPage==1}'>disabled</c:if>">
                                    <a class="page-link"
                                       href="AdminManageUserServlet?page=${currentPage-1}">&laquo;</a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item <c:if test='${i==currentPage}'>active</c:if>">
                                        <a class="page-link" href="AdminManageUserServlet?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item <c:if test='${currentPage==totalPages}'>disabled</c:if>">
                                    <a class="page-link"
                                       href="AdminManageUserServlet?page=${currentPage+1}">&raquo;</a>
                                </li>
                            </ul>
                        </nav>

                    </div>
                </div>
            </div> <!-- /.container-fluid -->

        </div> <!-- /#content -->
    </div> <!-- /#content-wrapper -->
</div> <!-- /#wrapper -->

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
</body>
</html>
