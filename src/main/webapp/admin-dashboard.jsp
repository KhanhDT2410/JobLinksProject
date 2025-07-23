<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

        <style>
            body {
                font-size: 1.1rem;
            }
            .card .h5 {
                font-size: 1.4rem;
            }
            .btn, .nav-link, .form-control {
                font-size: 1.1rem;
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
                        <div class="d-sm-flex align-items-center justify-content-between mb-4">
                            <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                        </div>
                        <!-- Info Cards -->
                        <div class="row">
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card border-left-primary shadow h-100 py-2">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng người dùng</div>
                                            <div class="h5 font-weight-bold text-gray-800">${totalUsers}</div>
                                        </div>
                                        <i class="fas fa-users fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card border-left-success shadow h-100 py-2">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Tổng công việc</div>
                                            <div class="h5 font-weight-bold text-gray-800">${totalTasks}</div>
                                        </div>
                                        <i class="fas fa-tasks fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="card border-left-warning shadow h-100 py-2">
                                    <div class="card-body d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Chờ duyệt</div>
                                            <div class="h5 font-weight-bold text-gray-800">${pendingTasks}</div>
                                        </div>
                                        <i class="fas fa-clock fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Charts -->
                        <div class="row">
                            <div class="col-xl-8 col-lg-7">
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3"><h6 class="m-0 font-weight-bold text-primary">Công việc theo tháng</h6></div>
                                    <div class="card-body">
                                        <canvas id="earningsAreaChart"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-5">
                                <div class="card shadow mb-4">
                                    <div class="card-header py-3"><h6 class="m-0 font-weight-bold text-primary">Tỷ lệ loại công việc</h6></div>
                                    <div class="card-body">
                                        <canvas id="revenuePieChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Recent Users -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Người dùng mới đăng ký</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Ngày tạo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${recentUsers}">
                                                <tr>
                                                    <td>${user.userId}</td>
                                                    <td>${user.fullName}</td>
                                                    <td>${user.email}</td>
                                                    <td>${user.role}</td>
                                                    <td>${user.createdAt}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- Recent Tasks -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Công việc mới tạo</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tiêu đề</th>
                                                <th>Người đăng</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="task" items="${recentTasks}">
                                                <tr>
                                                    <td>${task.taskId}</td>
                                                    <td>${task.title}</td>
                                                    <td>${task.clientName}</td>
                                                    <td>${task.status}</td>
                                                    <td>${task.createdAt}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- Quick Actions -->
                        <div class="row">
                            <div class="col-lg-6 mb-4">
                                <div class="card shadow">
                                    <div class="card-header py-3"><h6 class="m-0 font-weight-bold text-primary">Thông báo</h6></div>
                                    <div class="card-body">
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check-circle text-success"></i> Tài khoản mới được duyệt: Alice Cooper.</li>
                                            <li><i class="fas fa-info-circle text-info"></i> Hệ thống cập nhật version 2.3.1.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 mb-4">
                                <div class="card shadow">
                                    <div class="card-header py-3"><h6 class="m-0 font-weight-bold text-primary">Chức năng nhanh</h6></div>
                                    <div class="card-body text-center">
                                        <a href="${pageContext.request.contextPath}/admin/AdminManageUserServlet" class="btn btn-primary m-2">
                                            <i class="fas fa-users"></i> Quản lý người dùng
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet" class="btn btn-success m-2">
                                            <i class="fas fa-tasks"></i> Quản lý công việc
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/createNotification" class="btn btn-warning m-2">
                                            <i class="fas fa-comments"></i> Tạo thông báo
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Recent Logs -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-primary">Nhật ký hệ thống gần đây</h6>
                                <a href="${pageContext.request.contextPath}/view-logs" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-sm">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Thời gian</th>
                                                <th>Email người dùng</th>
                                                <th>Hành động</th>
                                                <th>Đối tượng</th>
                                                <th>Mô tả</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="log" items="${recentLogs}">
                                                <tr>
                                                    <td>${log.timestamp}</td>
                                                    <td>${log.email}</td>
                                                    <td>${log.action}</td>
                                                    <td>${log.target}</td>
                                                    <td>${log.description}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- Welcome -->
                        <div class="card shadow mb-4">
                            <div class="card-body">
                                Chào mừng bạn đến với Trang Quản Trị JobLinks. Sử dụng sidebar để điều hướng đến các mục quản lý người dùng, công việc, báo cáo và hệ thống.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
        <!-- ChartJS Dynamic Data -->
        <script>
            // Parse JSON data an toàn
            const monthlyLabels = JSON.parse('${fn:escapeXml(monthlyLabelsJson)}');
            const monthlyCounts = JSON.parse('${fn:escapeXml(monthlyCountsJson)}');
            const pieLabels = JSON.parse('${fn:escapeXml(taskTypeLabelsJson)}');
            const pieData = JSON.parse('${fn:escapeXml(taskTypeDataJson)}');

            console.log("monthlyLabelsJson:", '${fn:escapeXml(monthlyLabelsJson)}');
            console.log("monthlyCountsJson:", '${fn:escapeXml(monthlyCountsJson)}');
            console.log("taskTypeLabelsJson:", '${fn:escapeXml(taskTypeLabelsJson)}');
            console.log("taskTypeDataJson:", '${fn:escapeXml(taskTypeDataJson)}');

            // Vẽ biểu đồ cột (bar chart) để so sánh số lượng công việc theo tháng
            new Chart(document.getElementById("earningsAreaChart"), {
                type: 'bar', // Chuyển sang biểu đồ cột để so sánh rõ ràng hơn
                data: {
                    labels: monthlyLabels, // Các tháng
                    datasets: [{
                        label: "Số công việc",
                        data: monthlyCounts, // Số lượng công việc mỗi tháng
                        backgroundColor: "rgba(78, 115, 223, 0.5)", // Màu nền cột
                        borderColor: "rgba(78, 115, 223, 1)", // Màu viền cột
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Số lượng công việc'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Tháng'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return `Số công việc: ${context.parsed.y}`;
                                }
                            }
                        }
                    }
                }
            });

            // Vẽ biểu đồ tròn (pie chart)
            new Chart(document.getElementById("revenuePieChart"), {
                type: 'doughnut',
                data: {
                    labels: pieLabels,
                    datasets: [{
                        data: pieData,
                        backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b']
                    }]
                },
                options: {
                    cutout: '70%',
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        </script>
    </body>
</html>