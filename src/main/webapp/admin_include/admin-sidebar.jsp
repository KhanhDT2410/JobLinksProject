<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!-- Sidebar -->
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
    style="position: fixed; top: 0; left: 0; height: 100vh; width: 240px; overflow-y: auto; font-size: 1.1rem; z-index: 1000;">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center mt-3" href="#">
        <div class="sidebar-brand-icon rotate-n-15">
            <i class="fas fa-laugh-wink"></i>
        </div>
        <div class="sidebar-brand-text mx-3">JobLinks Admin</div>
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-2">

    <!-- Nav Item - Dashboard -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
    </li>

    <!-- Nav Item - View User List -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/AdminManageUserServlet">
            <i class="fas fa-users"></i>
            <span>View User List</span>
        </a>
    </li>

    <!-- Nav Item - View User Tasks -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/AdminManageTaskServlet">
            <i class="fas fa-tasks"></i>
            <span>View User Tasks</span>
        </a>
    </li>

    <!-- Nav Item - Create User Notification -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/createNotification">
            <i class="fas fa-bell"></i>
            <span>Create User Notification</span>
        </a>
    </li>

    <!-- ✅ Nav Item - Manage User Balance -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manageBalance">
            <i class="fas fa-wallet"></i>
            <span>Manage User Balance</span>
        </a>
    </li>

    <!-- ✅ Nav Item - Manage Boost Task -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminBoostTask">
            <i class="fas fa-rocket"></i>
            <span>Manage Boost Task</span>
        </a>
    </li>

    <!-- Nav Item - View System Logs -->
    <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/view-logs">
            <i class="fas fa-history"></i>
            <span>View System Logs</span>
        </a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block my-3">

</ul>
<!-- End of Sidebar -->
