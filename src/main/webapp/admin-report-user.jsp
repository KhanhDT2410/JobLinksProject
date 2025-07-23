<%-- 
    Document   : admin-report-user
    Created on : Jul 13, 2025, 06:50 PM
    Author     : Grok (xAI)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Báo cáo</title>
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

    <style>
        .card.shadow.mb-4 {
            max-width: 1200px;
            margin: 30px auto;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
            background-color: #fff;
        }
        h1.h3.mb-4.text-gray-800 {
            text-align: center;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 40px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }
        .table {
            border-radius: 15px;
            overflow: hidden;
            width: 100%;
            table-layout: fixed;
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
            word-wrap: break-word;
            padding: 12px;
        }
        .table th {
            background-color: #43945B;
            color: white;
            white-space: nowrap;
        }
        .table td {
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .table th:nth-child(1), .table td:nth-child(1) { width: 5%; } /* STT */
        .table th:nth-child(2), .table td:nth-child(2) { width: 15%; } /* Người báo cáo */
        .table th:nth-child(3), .table td:nth-child(3) { width: 15%; } /* Người bị báo cáo */
        .table th:nth-child(4), .table td:nth-child(4) { width: 30%; } /* Nội dung */
        .table th:nth-child(5), .table td:nth-child(5) { width: 15%; } /* Task liên quan */
        .table th:nth-child(6), .table td:nth-child(6) { width: 20%; } /* Thời gian */
        .warning-box {
            background-color: #fff3cd;
            color: #856404;
            border: 1px #ffeeba;
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .warning-box i {
            margin-right: 10px;
            font-size: 1.3em;
            color: #d39e00;
        }
        @media (max-width: 768px) {
            .card.shadow.mb-4 {
                margin: 10px;
                padding: 15px;
            }
            .table { font-size: 0.9em; }
            .table th, .table td { padding: 6px; }
            .table th:nth-child(4), .table td:nth-child(4) { width: 25%; } /* Giảm kích thước Nội dung trên mobile */
        }
    </style>
</head>
<body id="page-top">

    <div id="wrapper">

        <jsp:include page="admin_include/admin-sidebar.jsp" />

        <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">

            <div id="content">

                <jsp:include page="admin_include/admin-header.jsp" />

                <div class="container-fluid">

                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <h1 class="h3 mb-4 text-gray-800">Danh sách tất cả báo cáo</h1>

                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger text-center"><c:out value="${errorMessage}" /></div>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty allReports}">
                                    <table class="table table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Người báo cáo</th>
                                                <th>Người bị báo cáo</th>
                                                <th>Nội dung</th>
                                                <th>Task liên quan</th>
                                                <th>Thời gian</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="report" items="${allReports}" varStatus="loop">
                                                <tr>
                                                    <td><c:out value="${loop.count}" /></td>
                                                    <td><c:out value="${report.reporterId}" /></td> <!-- Hiển thị ID tạm thời -->
                                                    <td><c:out value="${report.reportedName}" /></td>
                                                    <td><c:out value="${report.message}" /></td>
                                                    <td><c:out value="${report.taskTitle != null ? report.taskTitle : 'Không có'}" escapeXml="true" /></td>
                                                    <td><c:out value="${report.reportTime}" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="warning-box">
                                        <i class="fas fa-exclamation-triangle"></i> Không có báo cáo nào trong hệ thống.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>

            <jsp:include page="admin_include/admin-footer.jsp" />

        </div>

    </div>

    <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

</body>
</html>