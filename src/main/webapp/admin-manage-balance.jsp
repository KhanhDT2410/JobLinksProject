<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý số dư người dùng</title>
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
    <style>
        body {
            font-size: 1.1rem;
        }
        .h1, .h2, .h3, .h4, .h5, .h6,
        h1, h2, h3, h4, h5, h6 {
            font-size: 1.25em;
        }
        .sidebar .nav-item .nav-link {
            font-size: 1.1rem;
        }
        .card .card-body .text-xs {
            font-size: 1rem !important;
        }
        .card .h5 {
            font-size: 1.4rem;
        }
        .navbar .nav-link,
        .navbar .dropdown-toggle {
            font-size: 1.1rem;
        }
        .form-control {
            font-size: 1.1rem;
        }
        .btn {
            font-size: 1.1rem;
        }
    </style>
</head>
<body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/admin_include/admin-sidebar.jsp" />

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">
            <!-- Main Content -->
            <div id="content">
                <!-- Header / Topbar -->
                <jsp:include page="/admin_include/admin-header.jsp" />

                <!-- Begin Page Content -->
                <div class="container-fluid">
                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Quản lý số dư người dùng</h1>
                    </div>

                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Số dư</th>
                                            <th>Mô tả</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>${user.fullName}</td>
                                                <td>${user.email}</td>
                                                <td>${user.balance}</td>
                                                <td>
                                                    <form action="manageBalance" method="post" class="form-inline">
                                                        <input type="hidden" name="userId" value="${user.userId}">
                                                        <input type="text" name="description" class="form-control" placeholder="Lý do cập nhật">
                                                </td>
                                                <td>
                                                    <input type="number" name="newBalance" step="0.01" min="0" value="${user.balance}"
                                                           class="form-control mr-2" required>
                                                    <button type="submit" class="btn btn-primary btn-sm">
                                                        Cập nhật
                                                    </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Phân trang -->
                    <div class="d-flex justify-content-center">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="manageBalance?page=${currentPage - 1}">Trước</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="manageBalance?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="manageBalance?page=${currentPage + 1}">Sau</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>

                    <!-- Thông báo hoặc lỗi -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${message}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">×</span>
                            </button>
                        </div>
                    </c:if>
                </div> <!-- End container-fluid -->
            </div> <!-- End of Main Content -->

            <!-- Footer -->
            <jsp:include page="/admin_include/admin-footer.jsp"/>
        </div> <!-- End of Content Wrapper -->
    </div> <!-- End of Page Wrapper -->

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
</body>
</html>