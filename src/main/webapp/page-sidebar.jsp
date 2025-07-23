<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Sidebar</title>
  <style>
      body {
        font-family: 'Segoe UI', sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f6f9;
      }

      .sidebar {
        position: fixed;
        top: 0;
        left: -260px;
        width: 240px;
        height: 100%;
        background: #1e293b;
        color: white;
        padding-top: 0;
        transition: left 0.3s ease;
        z-index: 999;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
      }

      .sidebar.active {
        left: 0;
      }

      .sidebar-logo {
        padding: 20px;
        text-align: center;
        font-size: 22px;
        font-weight: bold;
        background-color: #0f172a;
        border-bottom: 1px solid #374151;
        letter-spacing: 1px;
      }

      .sidebar a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 20px;
        color: #e2e8f0;
        text-decoration: none;
        transition: background 0.2s, padding-left 0.2s;
        border-radius: 8px;
        margin: 4px 8px;
      }

      .sidebar a:hover {
        background-color: #334155;
        padding-left: 26px;
      }

      .submenu {
        display: none;
        padding-left: 10px;
        margin-left: 12px;
        border-left: 3px solid #38bdf8;
        background-color: #1e293b;
      }

      .menu-item.active .submenu {
        display: block;
      }

      .menu-item > a::after {
        content: '\f107'; /* caret-down */
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        margin-left: auto;
      }

      .menu-item.active > a::after {
        content: '\f106'; /* caret-up */
      }

      .sidebar-content {
        flex-grow: 1;
        overflow-y: auto;
        padding-top: 10px;
        margin-top: 80px;
      }

      .sidebar-footer {
        border-top: 1px solid #334155;
        padding: 10px 0;
      }

      .sidebar-footer a {
        background-color: #0f172a;
        text-align: center;
        color: #f87171;
      }

      #toggleSidebar {
        position: fixed;
        top: 10px;
        left: 10px;
        z-index: 1100;
        color: white;
        background-color: #0ea5e9;
        border: none;
        padding: 10px 15px;
        cursor: pointer;
        border-radius: 6px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        font-size: 18px;
        transition: background 0.3s;
      }

      #toggleSidebar:hover {
        background-color: #0284c7;
      }
      /* Số dư */
      .header-user-balance {
            background-color: #e0f8e0;         /* xanh lá nhạt */
            color: #2d7a2d;                    /* chữ xanh lá đậm */
            padding: 6px 12px;                 /* khoảng cách trong */
            border-radius: 8px;                /* bo góc */
            font-weight: bold;                /* in đậm */
            font-size: 14px;                   /* cỡ chữ vừa */
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1); /* bóng nhẹ */
            display: inline-block;             /* gọn gàng trong header */
        }

</style>
</head>
<body>
<!-- Nút mở sidebar -->
<button id="toggleSidebar"><i class="fas fa-bars"></i></button>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
  <!-- Logo -->
  <div class="sidebar-logo">
    <i class="fas fa-briefcase"></i> JOBLINKS
  </div>

  <!-- Nội dung -->
  <div class="sidebar-content">
    <a href="home.jsp"><i class="fas fa-home"></i> Trang chủ</a>

    <div class="menu-item">
      <a href="#" onclick="toggleSubmenu(event)"><i class="fas fa-user"></i> Hồ sơ</a>
      <div class="submenu">
        <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-id-card"></i> Profile</a>
        <a href="${pageContext.request.contextPath}/notifications"><i class="fas fa-bell"></i> Thông báo</a>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/sendMessage"><i class="fas fa-envelope"></i> Nhắn tin</a>

    <div class="menu-item">
      <a href="#" onclick="toggleSubmenu(event)"><i class="fas fa-briefcase"></i> Công việc</a>
      <div class="submenu">
        <a href="${pageContext.request.contextPath}/tasks"><i class="fas fa-tasks"></i> Danh sách việc</a>
        <a href="${pageContext.request.contextPath}/loadJobPoster"><i class="fas fa-upload"></i> Đăng tuyển dụng</a>
        <a href="${pageContext.request.contextPath}/boostTask"><i class="fas fa-rocket"></i> Quản Lý Boost Task</a>
        <a href="${pageContext.request.contextPath}/acceptedTasks"><i class="fas fa-briefcase"></i> Công việc đã nhận</a>
        <a href="${pageContext.request.contextPath}/tasks?action=applied"><i class="fas fa-history"></i> Lịch sử công việc</a>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/report"><i class="fas fa-search"></i> Report</a>
      
    <a href="support.jsp"><i class="fas fa-headset"></i> Hỗ Trợ Khách Hàng</a>
  </div>

    <a href="${pageContext.request.contextPath}/DepositServlet"><i class="fas fa-wallet"></i> Nạp tiền</a>

  <!-- Đăng xuất -->
    <span class="header-user-balance">
        Số dư: <fmt:formatNumber value="${sessionScope.user.balance}" type="currency" currencyCode="VND"/>
    </span>
  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
  </div>
</div>

<script>
  const sidebar = document.getElementById('sidebar');
  const toggleSidebar = document.getElementById('toggleSidebar');

  toggleSidebar.addEventListener('click', () => {
    sidebar.classList.toggle('active');
  });

  function toggleSubmenu(event) {
    event.preventDefault();
    const parent = event.target.closest('.menu-item');
    parent.classList.toggle('active');
  }
</script>
</body>
</html>
