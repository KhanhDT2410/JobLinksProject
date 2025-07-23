<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nạp/Rút Tiền - JobLinks</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        html { height: 100%; }
        body {
            margin: 0;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-content { flex: 1 0 auto; padding: 20px 0; margin-top: 130px;}
        .container { max-width: 1200px; margin: 0 auto; padding: 0 15px; }
        .deposit-form, .withdraw-form {
            max-width: 500px;
            margin: 0 auto 30px auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .payment-history {
            max-width: 800px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .form-control {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
            border-color: #6e8efb;
            box-shadow: 0 0 0 0.2rem rgba(110, 142, 251, 0.25);
        }
        .btn-primary {
            background-color: #6e8efb;
            border: none;
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #5d7ce0;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(110, 142, 251, 0.4);
        }
        .alert {
            margin-top: 20px;
            border-radius: 8px;
            padding: 15px 20px;
            font-weight: 500;
        }
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        .no-js-warning { display: none; color: red; font-weight: bold; margin-top: 10px; }
        .table-responsive { margin-top: 20px; }
        .badge-success { background-color: #28a745; color: white; padding: 8px 12px; border-radius: 20px; }
        .badge-warning { background-color: #ffc107; color: #212529; padding: 8px 12px; border-radius: 20px; }
        .badge-danger { background-color: #dc3545; color: white; padding: 8px 12px; border-radius: 20px; }
        .payment-type-deposit { color: #28a745; font-weight: bold; }
        .payment-type-withdraw { color: #dc3545; font-weight: bold; }
        .payment-type-refund { color: #17a2b8; font-weight: bold; }
        .no-history { text-align: center; color: #6c757d; font-style: italic; padding: 40px 20px; }
        .nav-tabs { border-bottom: 2px solid #dee2e6; }
        .nav-tabs .nav-link {
            color: #6e8efb;
            font-weight: 600;
            padding: 15px 30px;
            border: none;
            border-radius: 10px 10px 0 0;
            margin-right: 5px;
            transition: all 0.3s ease;
        }
        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
        }
        .nav-tabs .nav-link.active {
            color: #fff;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .tab-content {
            padding-top: 30px;
        }
        .balance-display {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .balance-amount {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .balance-label {
            font-size: 1rem;
            opacity: 0.9;
        }
        .input-group-text {
            background-color: #6e8efb;
            color: white;
            border: none;
            font-weight: 600;
        }
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px 30px;
        }
        .modal-title {
            font-weight: 600;
        }
        .btn-close {
            filter: invert(1);
        }
        .modal-body {
            padding: 30px;
        }
        .modal-footer {
            padding: 20px 30px;
            border-top: 1px solid #eee;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .table-dark {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(110, 142, 251, 0.05);
        }
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .spinner-border {
            color: #6e8efb;
        }
        .amount-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .amount-btn {
            padding: 8px 15px;
            border: 2px solid #6e8efb;
            background-color: white;
            color: #6e8efb;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .amount-btn:hover {
            background-color: #6e8efb;
            color: white;
        }
        .debug-info { display: none; }
    </style>
</head>
<body>
    <!-- Debug Info -->
    <div class="debug-info">
        <c:out value="Debug - sessionScope.user: ${sessionScope.user}"/>
        <c:out value="Debug - sessionScope.user.balance: ${sessionScope.user.balance}"/>
        <c:set var="userBalance" value="${sessionScope.user != null ? sessionScope.user.balance : 0}"/>
        <c:out value="Debug - userBalance: ${userBalance}"/>
    </div>

    <%@include file="header-layout.jsp" %>

    <div class="main-content">
        <div class="container">
            <h1 class="text-center mb-4">
                <i class="fas fa-wallet"></i> Ví Tiền Của Bạn
            </h1>

            <!-- Balance Display -->
            <div class="balance-display">
                <div class="balance-amount">
                    <fmt:formatNumber value="${sessionScope.user.balance}" type="currency" currencyCode="VND"/>
                </div>
                <div class="balance-label">Số dư hiện tại</div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Tabs -->
            <ul class="nav nav-tabs mb-4" id="paymentTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="deposit-tab" data-bs-toggle="tab" data-bs-target="#deposit" type="button" role="tab" aria-controls="deposit" aria-selected="true">
                        <i class="fas fa-plus-circle"></i> Nạp Tiền
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="withdraw-tab" data-bs-toggle="tab" data-bs-target="#withdraw" type="button" role="tab" aria-controls="withdraw" aria-selected="false">
                        <i class="fas fa-minus-circle"></i> Rút Tiền
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="paymentTabContent">
                <!-- Deposit Tab -->
                <div class="tab-pane fade show active" id="deposit" role="tabpanel" aria-labelledby="deposit-tab">
                    <div class="deposit-form">
                        <h3 class="text-center mb-4">
                            <i class="fas fa-credit-card"></i> Nạp Tiền Vào Tài Khoản
                        </h3>
                        <form id="depositForm" action="${pageContext.request.contextPath}/vnpayajax/createOrder" method="post">
                            <div class="mb-4">
                                <label for="amount" class="form-label">
                                    <i class="fas fa-dollar-sign"></i> Số tiền muốn nạp (VND)
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">VND</span>
                                    <input type="number" class="form-control" id="amount" name="amount" 
                                           min="10000" max="2000000" step="10000" required 
                                           placeholder="Nhập số tiền (10,000 - 2,000,000 VND)">
                                </div>
                                <div class="amount-buttons">
                                    <button type="button" class="amount-btn" onclick="setAmount(50000)">50,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(100000)">100,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(200000)">200,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(500000)">500,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(1000000)">1,000,000</button>
                                    <button type="button" class="amount-btn" onclick="setAmount(2000000)">2,000,000</button>
                                </div>
                            </div>
                            <noscript>
                                <div class="no-js-warning">JavaScript bị vô hiệu hóa. Vui lòng bật JavaScript để sử dụng chức năng xác nhận nạp tiền.</div>
                            </noscript>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-plus-circle"></i> Nạp tiền
                            </button>
                            <div class="loading" id="depositLoading">
                                <div class="spinner-border" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2">Đang xử lý giao dịch...</p>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Withdraw Tab -->
                <div class="tab-pane fade" id="withdraw" role="tabpanel" aria-labelledby="withdraw-tab">
                    <div class="withdraw-form">
                        <h3 class="text-center mb-4">
                            <i class="fas fa-money-check"></i> Rút Tiền Từ Tài Khoản
                        </h3>
                        <form id="withdrawForm" action="${pageContext.request.contextPath}/WithdrawServlet" method="post" onsubmit="return false;">
                            <div class="mb-3">
                                <label for="accountNumber" class="form-label">
                                    <i class="fas fa-credit-card"></i> Số tài khoản
                                </label>
                                <input type="text" class="form-control" id="accountNumber" name="accountNumber" 
                                       pattern="[0-9]{8,16}" required placeholder="Nhập số tài khoản (8-16 chữ số)">
                            </div>
                            <div class="mb-3">
                                <label for="bank" class="form-label">
                                    <i class="fas fa-university"></i> Ngân hàng
                                </label>
                                <select class="form-control" id="bank" name="bank" required>
                                    <option value="" disabled selected>Chọn ngân hàng</option>
                                    <option value="vietcombank">Vietcombank</option>
                                    <option value="momo">Momo</option>
                                    <option value="zalopay">ZaloPay</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock"></i> Mật khẩu
                                </label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       required placeholder="Nhập mật khẩu để xác nhận">
                            </div>
                            <div class="mb-4">
                                <label for="withdrawAmount" class="form-label">
                                    <i class="fas fa-dollar-sign"></i> Số tiền muốn rút (VND)
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">VND</span>
                                    <input type="number" class="form-control" id="withdrawAmount" name="withdrawAmount" 
                                           min="10000" step="10000" required 
                                           placeholder="Nhập số tiền (tối thiểu 10,000 VND)">
                                </div>
                                <small class="form-text text-muted">
                                    Số dư khả dụng: <strong><fmt:formatNumber value="${sessionScope.user.balance}" type="currency" currencyCode="VND"/></strong>
                                </small>
                            </div>
                            <noscript>
                                <div class="no-js-warning">JavaScript bị vô hiệu hóa. Vui lòng bật JavaScript để sử dụng chức năng xác nhận rút tiền.</div>
                            </noscript>
                            <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#confirmWithdrawModal">
                                <i class="fas fa-minus-circle"></i> Rút tiền
                            </button>
                            <div class="loading" id="withdrawLoading">
                                <div class="spinner-border" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2">Đang xử lý giao dịch...</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Payment History -->
            <div class="payment-history">
                <h3 class="mb-4">
                    <i class="fas fa-history"></i> Lịch sử giao dịch
                </h3>
                <c:choose>
                    <c:when test="${not empty paymentHistory}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th><i class="fas fa-calendar"></i> Ngày giao dịch</th>
                                        <th><i class="fas fa-exchange-alt"></i> Loại giao dịch</th>
                                        <th><i class="fas fa-money-bill"></i> Số tiền</th>
                                        <th><i class="fas fa-info-circle"></i> Mô tả</th>
                                        <th><i class="fas fa-check-circle"></i> Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payment" items="${paymentHistory}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${payment.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentType == 'DEPOSIT'}">
                                                        <span class="payment-type-deposit">
                                                            <i class="fas fa-plus-circle"></i> Nạp tiền
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${payment.paymentType == 'WITHDRAW'}">
                                                        <span class="payment-type-withdraw">
                                                            <i class="fas fa-minus-circle"></i> Rút tiền
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${payment.paymentType == 'REFUND'}">
                                                        <span class="payment-type-refund">
                                                            <i class="fas fa-undo"></i> Hoàn tiền
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>${payment.paymentType}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentType == 'DEPOSIT' || payment.paymentType == 'REFUND'}">
                                                        <span class="text-success fw-bold">
                                                            +<fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger fw-bold">
                                                            -<fmt:formatNumber value="${payment.amount}" type="currency" currencyCode="VND"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${payment.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.status == 'SUCCESS'}">
                                                        <span class="badge badge-success"><i class="fas fa-check-circle"></i> Thành công</span>
                                                    </c:when>
                                                    <c:when test="${payment.status == 'PENDING'}">
                                                        <span class="badge badge-warning"><i class="fas fa-clock"></i> Đang xử lý</span>
                                                    </c:when>
                                                    <c:when test="${payment.status == 'FAILED'}">
                                                        <span class="badge badge-danger"><i class="fas fa-times-circle"></i> Thất bại</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">${payment.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-history">
                            <i class="fas fa-info-circle fs-2 mb-3"></i>
                            <p>Chưa có lịch sử giao dịch nào.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Withdraw Modal -->
            <div class="modal fade" id="confirmWithdrawModal" tabindex="-1" aria-labelledby="confirmWithdrawModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="confirmWithdrawModalLabel">Xác nhận rút tiền</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn rút <span id="confirmWithdrawAmount">0</span> VND?</p>
                            <p>Ngân hàng: <span id="confirmBank">Chưa chọn</span></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary" onclick="submitWithdrawForm()">Xác nhận</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const userBalance = ${sessionScope.user != null && sessionScope.user.balance != null ? sessionScope.user.balance : 0};

    console.log("Debug - userBalance:", userBalance);

    // Set amount for quick selection buttons
    function setAmount(amount) {
        document.getElementById('amount').value = amount;
    }

    // Handle deposit form submission with AJAX
    document.getElementById('depositForm').addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent default form submission

        const amount = document.getElementById('amount').value;
        if (!amount || amount < 10000 || amount > 2000000) {
            alert('Vui lòng nhập số tiền hợp lệ (10,000 - 2,000,000 VND).');
            return;
        }

        const loading = document.getElementById('depositLoading');
        loading.style.display = 'block';

        fetch('${pageContext.request.contextPath}/vnpayajax', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'amount=' + encodeURIComponent(amount) + '&language=vn'
        })
        .then(response => response.json())
        .then(data => {
            loading.style.display = 'none';
            if (data.code === '00' && data.data) {
                // Open payment URL in a new tab
                window.open(data.data, '_blank');
            } else {
                alert('Có lỗi xảy ra: ' + data.message);
            }
        })
        .catch(error => {
            loading.style.display = 'none';
            alert('Lỗi khi kết nối với cổng thanh toán: ' + error.message);
        });
    });

    // Withdraw modal content update
    document.getElementById('confirmWithdrawModal').addEventListener('show.bs.modal', function (event) {
        const withdrawAmountInput = document.getElementById('withdrawAmount');
        const withdrawAmount = parseFloat(withdrawAmountInput.value);
        if (!withdrawAmount || isNaN(withdrawAmount) || withdrawAmount < 10000) {
            alert('Vui lòng nhập số tiền hợp lệ (tối thiểu 10,000 VND).');
            event.preventDefault();
            return;
        }
        if (withdrawAmount > userBalance) {
            alert('Không đủ số dư để rút');
            event.preventDefault();
            return;
        }
        document.getElementById('confirmWithdrawAmount').textContent = new Intl.NumberFormat('vi-VN').format(withdrawAmount);

        const bank = document.getElementById('bank').value;
        if (!bank) {
            alert('Vui lòng chọn ngân hàng.');
            event.preventDefault();
            return;
        }
        document.getElementById('confirmBank').textContent = bank.charAt(0).toUpperCase() + bank.slice(1);
    });

    function submitWithdrawForm() {
        const bank = document.getElementById('bank').value;
        const accountNumber = document.getElementById('accountNumber').value;
        const password = document.getElementById('password').value;
        if (!bank || !accountNumber || !password) {
            alert('Vui lòng điền đầy đủ thông tin.');
            return;
        }
        const withdrawLoading = document.getElementById('withdrawLoading');
        withdrawLoading.style.display = 'block';
        document.getElementById('withdrawForm').submit();
    }

    // Back to top button
    window.addEventListener('scroll', function() {
        const backToTop = document.getElementById('backToTop');
        if (window.pageYOffset > 300) {
            backToTop.classList.add('show');
        } else {
            backToTop.classList.remove('show');
        }
    });
    document.getElementById('backToTop').addEventListener('click', function(e) {
        e.preventDefault();
        window.scrollTo({top: 0, behavior: 'smooth'});
    });
</script>
</body>
</html>