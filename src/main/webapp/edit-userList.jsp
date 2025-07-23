<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User - Admin</title>
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet" />
    <style>
        .error-message {
            color: red;
            font-size: 0.9em;
            display: none;
            margin-top: 5px;
        }
    </style>
</head>
<body id="page-top">
<div id="wrapper">
    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="#">
            <div class="sidebar-brand-text mx-3">JobLinks Admin</div>
        </a>
        <hr class="sidebar-divider">
        <li class="nav-item">
            <a class="nav-link" href="AdminManageUserServlet">
                <i class="fas fa-users"></i>
                <span>View User List</span>
            </a>
        </li>
    </ul>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">

        <!-- Main Content -->
        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                <h5 class="m-0 font-weight-bold text-primary">Edit User Info</h5>
            </nav>

            <!-- Begin Page Content -->
            <div class="container-fluid">
                <div class="card shadow mb-4">
                    <div class="card-body">

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="AdminManageUserServlet" method="post" onsubmit="return validateForm()">
                            <input type="hidden" name="userId" value="${user.userId}" />

                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="form-control" value="${user.fullName}" required />
                            </div>

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" 
                                       value="${user.email != null ? user.email : ''}" 
                                       pattern="^[a-zA-Z0-9._%+-]+@gmail\.com$" 
                                       title="Email phải có định dạng @gmail.com" required />
                                <div id="emailError" class="error-message">Email phải có định dạng @gmail.com!</div>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input type="text" id="phone" name="phone" class="form-control" 
                                       value="${user.phone != null ? user.phone : '0'}" 
                                       inputmode="numeric" pattern="0[0-9]{9}" 
                                       title="Số điện thoại phải có đúng 10 số và bắt đầu bằng số 0" 
                                       maxlength="10"
                                       onkeypress="return event.charCode >= 48 && event.charCode <= 57" required />
                                <div id="phoneError" class="error-message">Số điện thoại phải có đúng 10 số và bắt đầu bằng số 0!</div>
                                <small class="text-muted">Nhập đúng 10 số, bắt đầu bằng số 0</small>
                            </div>

                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" class="form-control" placeholder="Leave blank to keep current password" />
                            </div>

                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" name="address" class="form-control" value="${user.address != null ? user.address : ''}" />
                            </div>

                            <div class="form-group">
                                <label for="role">Role</label>
                                <select id="role" name="role" class="form-control" required>
                                    <option value="user" <c:if test="${user.role == 'user'}">selected</c:if>>User</option>
                                    <option value="worker" <c:if test="${user.role == 'worker'}">selected</c:if>>Worker</option>
                                    <option value="client" <c:if test="${user.role == 'client'}">selected</c:if>>Client</option>
                                    <option value="admin" <c:if test="${user.role == 'admin'}">selected</c:if>>Admin</option>
                                </select>
                            </div>

                            <div class="form-group form-check">
                                <input type="checkbox" class="form-check-input" id="locked" name="locked" <c:if test="${user.locked}">checked</c:if> />
                                <label class="form-check-label" for="locked">Locked</label>
                            </div>

                            <button type="submit" class="btn btn-primary">Save</button>
                            <a href="AdminManageUserServlet" class="btn btn-secondary">Back to User List</a>
                        </form>

                    </div>
                </div>
            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- End of Main Content -->

    </div>
    <!-- End of Content Wrapper -->
</div>
<!-- End of Page Wrapper -->

<script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
<script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>
<script>
    // Kiểm tra input số khi nhập và đảm bảo đúng format cho phone  
    document.getElementById('phone').addEventListener('input', function(e) {
        let phoneInput = e.target.value;
        const phoneError = document.getElementById('phoneError');
        
        // Chỉ cho phép nhập số
        phoneInput = phoneInput.replace(/[^0-9]/g, '');
        
        // Giới hạn độ dài tối đa 10 số
        if (phoneInput.length > 10) {
            phoneInput = phoneInput.substring(0, 10);
        }
        
        // Đảm bảo số đầu tiên là 0
        if (phoneInput.length > 0 && phoneInput.charAt(0) !== '0') {
            phoneInput = '0' + phoneInput.substring(1);
        }
        
        // Cập nhật giá trị input
        this.value = phoneInput;
        
        // Hiển thị error nếu chưa đủ 10 số hoặc không bắt đầu bằng 0
        if (phoneInput.length > 0 && (phoneInput.length !== 10 || phoneInput.charAt(0) !== '0')) {
            phoneError.style.display = 'block';
        } else {
            phoneError.style.display = 'none';
        }
    });

    // Kiểm tra email khi nhập
    document.getElementById('email').addEventListener('input', function(e) {
        const emailInput = e.target.value;
        const emailError = document.getElementById('emailError');
        if (emailInput && !/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(emailInput)) {
            emailError.style.display = 'block';
        } else {
            emailError.style.display = 'none';
        }
    });

    // Kiểm tra khi submit form
    function validateForm() {
        const phoneInput = document.getElementById('phone').value;
        const phoneError = document.getElementById('phoneError');
        const emailInput = document.getElementById('email').value;
        const emailError = document.getElementById('emailError');

        let isValid = true;

        // Kiểm tra phone - phải có đúng 10 số và bắt đầu bằng 0
        if (!phoneInput || phoneInput.length !== 10 || !/^0[0-9]{9}$/.test(phoneInput)) {
            phoneError.style.display = 'block';
            alert('Số điện thoại phải có đúng 10 số và bắt đầu bằng số 0!');
            isValid = false;
        } else {
            phoneError.style.display = 'none';
        }

        // Kiểm tra email
        if (!emailInput || !/^[a-zA-Z0-9._%+-]+@gmail\.com$/.test(emailInput)) {
            emailError.style.display = 'block';
            alert('Email phải có định dạng @gmail.com!');
            isValid = false;
        } else {
            emailError.style.display = 'none';
        }

        return isValid; // Ngăn submit nếu không hợp lệ
    }

    // Ngăn paste nội dung không hợp lệ vào phone
    document.getElementById('phone').addEventListener('paste', function(e) {
        e.preventDefault();
        let paste = (e.clipboardData || window.clipboardData).getData('text');
        paste = paste.replace(/[^0-9]/g, '').substring(0, 10);
        
        if (paste.length > 0 && paste.charAt(0) !== '0') {
            paste = '0' + paste.substring(1);
        }
        
        this.value = paste;
        this.dispatchEvent(new Event('input'));
    });
</script>
</body>
</html>