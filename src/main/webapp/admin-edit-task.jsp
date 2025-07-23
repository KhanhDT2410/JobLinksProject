<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa công việc - Admin</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">

        <style>
            .card.shadow.mb-4 {
                max-width: 700px;
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
            label.form-label {
                font-weight: 600;
                color: #34495e;
            }
            input.form-control, textarea.form-control, select.form-control {
                border-radius: 10px;
                border: 1.5px solid #ced4da;
                font-size: 1rem;
                padding: 10px 15px;
                transition: border-color 0.3s ease;
            }
            input.form-control:focus, textarea.form-control:focus, select.form-control:focus {
                border-color: #4e73df;
                box-shadow: 0 0 8px rgba(78, 115, 223, 0.3);
                outline: none;
            }
            button.btn-primary {
                border-radius: 12px;
                padding: 12px 30px;
                font-size: 1.1rem;
                font-weight: 600;
            }
            a.btn-secondary {
                border-radius: 12px;
                padding: 12px 30px;
                font-size: 1.1rem;
                font-weight: 600;
                margin-left: 15px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }
            .mb-3 {
                margin-bottom: 1.5rem !important;
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

                        <h1 class="h3 mb-4 text-gray-800">Chỉnh sửa công việc</h1>

                        <div class="card shadow mb-4">
                            <div class="card-body">

                                <form action="${pageContext.request.contextPath}/admin/AdminManageTaskServlet" method="post" autocomplete="off">
                                    <input type="hidden" name="action" value="update" />
                                    <input type="hidden" name="taskId" value="${task.taskId}" />

                                    <div class="mb-3">
                                        <label class="form-label" for="title">Tiêu đề</label>
                                        <input type="text" id="title" name="title" class="form-control" value="${task.title != null ? task.title : ''}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="description">Mô tả</label>
                                        <textarea id="description" name="description" class="form-control" rows="5" required>${task.description != null ? task.description : ''}</textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="clientName">Người đăng</label>
                                        <input type="text" id="clientName" name="clientName" class="form-control" value="${task.clientName != null ? task.clientName : ''}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label" for="categoryId">Danh mục</label>
                                        <input type="hidden" id="categoryId" name="categoryId" class="form-control" value="${task.categoryId}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="location">Địa điểm</label>
                                        <input type="text" id="location" name="location" class="form-control" value="${task.location}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="scheduledTime">Thời gian dự kiến</label>
                                        <input type="datetime-local" id="scheduledTime" name="scheduledTime"
                                               class="form-control"
                                               value="${task.scheduledTime != null ? fn:substring(task.scheduledTime, 0, 16) : ''}" required>

                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="budget">Ngân sách</label>
                                        <input type="number" step="0.01" id="budget" name="budget" class="form-control" value="${task.budget}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="status">Trạng thái</label>
                                        <select id="status" name="status" class="form-control" required>
                                            <option value="pending" ${task.status eq 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                            <option value="completed" ${task.status eq 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                            <option value="cancelled" ${task.status eq 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label" for="createdAt">Ngày tạo</label>
                                        <input type="text" id="createdAt" name="createdAt" class="form-control" value="${task.createdAt != null ? task.createdAt : ''}" readonly>
                                    </div>

                                    <!-- Bạn có thể thêm các trường khác ở đây tương tự nếu cần -->

                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Lưu thay đổi
                                    </button>

                                    <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet?action=list" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                </form>

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
