<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết công việc - Admin</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

        <style>
            body {
                background: #f7f9fc;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            h1.h3.mb-4.text-gray-800 {
                font-weight: 700;
                color: #34495e;
                text-align: center;
                margin-bottom: 40px;
                text-transform: uppercase;
                letter-spacing: 2px;
            }

            .card.shadow.mb-4 {
                border-radius: 15px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
                padding: 30px;
                background: #ffffff;
                max-width: 700px;
                margin: 20px auto;
            }

            dl.row dt.col-sm-3 {
                font-weight: 600;
                color: #34495e;
                font-size: 1.1rem;
                padding-bottom: 10px;
            }

            dl.row dd.col-sm-9 {
                font-size: 1rem;
                padding-bottom: 10px;
            }

            .badge {
                font-size: 0.9rem;
                padding: 7px 14px;
                border-radius: 12px;
                font-weight: 600;
            }

            a.btn-secondary {
                padding: 12px 25px;
                font-size: 1.1rem;
                border-radius: 12px;
                margin-top: 20px;
                color: #6c757d;
                border-color: #6c757d;
                transition: background-color 0.3s ease, color 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            a.btn-secondary:hover {
                background-color: #6c757d;
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <body id="page-top">

        <div id="wrapper">

            <jsp:include page="/admin_include/admin-sidebar.jsp" />

            <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">


                <div id="content">

                    <jsp:include page="/admin_include/admin-header.jsp" />

                    <div class="container-fluid">

                        <h1 class="h3 mb-4 text-gray-800">Chi tiết công việc</h1>

                        <div class="card shadow mb-4">
                            <div class="card-body">
                                <dl class="row">
                                    <dt class="col-sm-3">ID:</dt>
                                    <dd class="col-sm-9">${task.taskId}</dd>

                                    <dt class="col-sm-3">Tiêu đề:</dt>
                                    <dd class="col-sm-9">${task.title}</dd>

                                    <dt class="col-sm-3">Mô tả:</dt>
                                    <dd class="col-sm-9">${task.description}</dd>

                                    <dt class="col-sm-3">Người đăng:</dt>
                                    <dd class="col-sm-9">${task.clientName}</dd>

                                    <dt class="col-sm-3">Trạng thái:</dt>
                                    <dd class="col-sm-9">
                                        <c:choose>
                                            <c:when test="${task.status eq 'completed'}">
                                                <span class="badge bg-success">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${task.status eq 'pending'}">
                                                <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${task.status eq 'cancelled'}">
                                                <span class="badge" style="background-color: #dc3545; color: white;">Đã hủy</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge bg-secondary">${task.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </dd>


                                    <dt class="col-sm-3">Ngày tạo:</dt>
                                    <dd class="col-sm-9">${task.createdAt}</dd>
                                </dl>

                                <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet?action=list" class="btn btn-secondary mt-3">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>

                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

    </body>
</html>
