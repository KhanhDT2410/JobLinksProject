<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý ưu tiên công việc - Admin</title>
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
    <style>
        body { font-size: 1.1rem; }
        .h1, .h2, .h3, .h4, .h5, .h6, h1, h2, h3, h4, h5, h6 { font-size: 1.25em; }
        .sidebar .nav-item .nav-link { font-size: 1.1rem; }
        .card .card-body .text-xs { font-size: 1rem !important; }
        .card .h5 { font-size: 1.4rem; }
        .navbar .nav-link, .navbar .dropdown-toggle { font-size: 1.1rem; }
        .form-control { font-size: 1.1rem; }
        .btn { font-size: 1.1rem; }
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
                        <h1 class="h3 mb-0 text-gray-800">Quản lý ưu tiên công việc</h1>
                    </div>

                    <!-- Thông báo thành công hoặc lỗi -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${success}
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

                    <!-- Danh sách công việc -->
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Trạng thái</th>
                                            <th>Ưu tiên</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty tasks and not empty tasks}">
                                                <c:forEach var="task" items="${tasks}">
                                                    <tr>
                                                        <td>${task.taskId}</td>
                                                        <td>${task.title}</td>
                                                        <td>${task.status}</td>
                                                        <td>${task.boostedAt != null ? 'Có' : 'Không'}</td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/admin/adminBoostTask" method="post" style="display:inline;">
                                                                <input type="hidden" name="taskId" value="${task.taskId}">
                                                                <input type="hidden" name="action" value="boost">
                                                                <button type="submit" class="btn btn-primary btn-sm ${task.boostedAt != null ? 'd-none' : ''}">Đẩy lên đầu</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/adminBoostTask" method="post" style="display:inline;">
                                                                <input type="hidden" name="taskId" value="${task.taskId}">
                                                                <input type="hidden" name="action" value="unboost">
                                                                <button type="submit" class="btn btn-danger btn-sm ${task.boostedAt == null ? 'd-none' : ''}">Hủy ưu tiên</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="5" class="text-center">Không có công việc nào để hiển thị.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
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