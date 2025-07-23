<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách công việc - Admin</title>
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
            <jsp:include page="admin_include/admin-sidebar.jsp" />

            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">

                <!-- Main Content -->
                <div id="content">

                    <!-- Header / Topbar -->
                    <jsp:include page="admin_include/admin-header.jsp" />

                    <!-- Begin Page Content -->
                    <div class="container-fluid">

                        <!-- Page Heading -->
                        <div class="d-sm-flex align-items-center justify-content-between mb-4">
                            <h1 class="h3 mb-0 text-gray-800">Danh sách công việc</h1>
                        </div>

                        <!-- Tasks Table -->
                        <div class="card shadow mb-4">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tiêu đề</th>
                                                <th>Người đăng</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="task" items="${taskList}">
                                                <tr>
                                                    <td>${task.taskId}</td>
                                                    <td>${task.title}</td>
                                                    <td>${task.clientName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${task.status eq 'completed'}">
                                                                <span class="badge bg-success">Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${task.status eq 'pending'}">
                                                                <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${task.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${task.createdAt}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet?action=view&taskId=${task.taskId}" class="btn btn-sm btn-info" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet?action=edit&taskId=${task.taskId}" class="btn btn-sm btn-primary" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet?action=delete&taskId=${task.taskId}" class="btn btn-sm btn-danger" title="Xóa"
                                                           onclick="return confirm('Bạn chắc chắn muốn xóa công việc này?');">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </a>
                                                    </td>


                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div> <!-- End container-fluid -->

                </div> <!-- End of Main Content -->

            </div> <!-- End of Content Wrapper -->

        </div> <!-- End of Page Wrapper -->

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

    </body>
</html>
