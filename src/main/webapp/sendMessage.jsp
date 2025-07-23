<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gửi tin nhắn</title>
        <style>
            /* Giữ nguyên CSS hiện tại */
            * {
                box-sizing: border-box;
            }
            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f0f2f5;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }
            .chat-container {
                width: 900px;
                height: 600px;
                background-color: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                display: flex;
                overflow: hidden;
            }
            .sidebar {
                width: 300px;
                background-color: #f9f9f9;
                border-right: 1px solid #eee;
                display: flex;
                flex-direction: column;
            }
            .sidebar-header {
                background-color: #007bff;
                color: white;
                padding: 16px;
                font-size: 18px;
                font-weight: bold;
            }
            .conversation-list {
                flex: 1;
                overflow-y: auto;
                padding: 10px;
            }
            .conversation-item {
                padding: 12px;
                border-bottom: 1px solid #eee;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .conversation-item:hover {
                background-color: #e9ecef;
            }
            .conversation-item.selected {
                background-color: #e0e7ff;
            }
            .conversation-item .latest-message {
                font-size: 12px;
                color: #666;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .conversation-item .latest-message.unread {
                font-weight: bold;
                color: #333;
            }
            .search-bar {
                padding: 10px;
                border-top: 1px solid #eee;
            }
            .search-bar input {
                width: 100%;
                padding: 8px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 8px;
                transition: border-width 0.2s;
            }
            .chat-box {
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .chat-header {
                background-color: #007bff;
                color: white;
                padding: 16px;
                font-size: 18px;
                font-weight: bold;
            }
            .chat-content {
                flex: 1;
                padding: 16px;
                overflow-y: auto;
                font-size: 14px;
            }
            .message {
                margin-bottom: 8px;
                padding: 6px 10px;
                border-radius: 10px;
                max-width: 60%;
                word-wrap: break-word;
                font-size: 13px;
                border: 0.5px solid #ddd;
                position: relative;
            }
            .message.sent {
                background-color: #007bff;
                color: white;
                margin-left: auto;
                text-align: right;
                border-color: #0056b3;
            }
            .message.received {
                background-color: #e9ecef;
                color: #333;
                margin-right: auto;
                text-align: left;
                border-color: #ccc;
            }
            .message .timestamp {
                font-size: 0.7em;
                color: #888;
                display: block;
                margin-top: 2px;
            }
            .message .delete-btn {
                display: none;
                position: absolute;
                top: 2px;
                right: 2px;
                background-color: #ff4d4d;
                color: white;
                border: none;
                border-radius: 50%;
                width: 18px;
                height: 18px;
                font-size: 12px;
                cursor: pointer;
                line-height: 18px;
                text-align: center;
            }
            .message.sent:hover .delete-btn {
                display: block;
            }
            .message .delete-btn:hover {
                background-color: #e60000;
            }
            .form-group {
                margin-bottom: 10px;
            }
            .form-group label {
                display: block;
                margin-bottom: 4px;
                font-weight: bold;
                color: #333;
            }
            .form-group input {
                width: 100%;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #ccc;
                font-size: 14px;
                transition: border-width 0.2s;
            }
            .chat-footer {
                border-top: 1px solid #eee;
                padding: 12px;
                background-color: #f9f9f9;
            }
            .chat-footer form {
                display: flex;
                gap: 8px;
            }
            .chat-footer textarea {
                flex: 1;
                padding: 10px;
                border-radius: 20px;
                border: 1px solid #ccc;
                resize: none;
                height: 40px;
                font-size: 14px;
                transition: border-width 0.2s;
            }
            .send-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 0 20px;
                border-radius: 20px;
                font-weight: bold;
                cursor: pointer;
            }
            .send-btn:hover {
                background-color: #0056b3;
            }
            .error {
                color: red;
                text-align: center;
                margin: 10px;
            }
        </style>
    </head>
    <body>
        <div class="chat-container">
            <!-- Sidebar: Danh sách tất cả user với thanh tìm kiếm -->
            <div class="sidebar">
                <div class="sidebar-header">Hộp thư</div>
                <div class="conversation-list" id="conversationList">
                    <c:if test="${empty allUsers}">
                        <p>Chưa có người dùng nào.</p>
                    </c:if>
                    <c:forEach var="user" items="${allUsers}">
                        <a href="sendMessage?receiverId=${user.userId}" style="text-decoration: none; color: inherit;" onclick="selectConversation(${user.userId}, '${user.fullName}')">
                            <div class="conversation-item ${user.userId == selectedReceiverId ? 'selected' : ''}" id="conv_${user.userId}">
                                <p><strong>${user.fullName}</strong> (ID: ${user.userId})</p>
                                <c:if test="${not empty user.latestMessage}">
                                    <p class="latest-message ${user.senderId != sessionScope.user.userId && !user.hasViewed ? 'unread' : ''}">
                                        <c:choose>
                                            <c:when test="${user.senderId == sessionScope.user.userId}">
                                                Bạn: ${user.latestMessage}
                                            </c:when>
                                            <c:otherwise>
                                                ${user.latestMessage}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </c:if>
                            </div>
                        </a>
                    </c:forEach>
                </div>
                <div class="search-bar">
                    <form action="sendMessage" method="get">
                        <input type="text" name="searchQuery" placeholder="Tìm tên người dùng..." value="${param.searchQuery}">
                    </form>
                </div>
            </div>

            <!-- Chat box: Hiển thị tin nhắn -->
            <div class="chat-box">
                <div class="chat-header">
                    Gửi tin nhắn
                    <a href="${pageContext.request.contextPath}/home" style="float: right; color: white; text-decoration: none; font-size: 14px;">⬅ Quay về trang chủ</a>
                </div>
                <div class="chat-content" id="chatContent">
                    <c:if test="${not empty error}">
                        <div class="error">${error}</div>
                    </c:if>

                    <c:if test="${empty messages}">
                        <p>Chưa có tin nhắn nào. Hãy gửi tin nhắn đầu tiên!</p>
                    </c:if>
                    <c:forEach var="message" items="${messages}">
                        <div class="message ${message.senderId == sessionScope.user.userId ? 'sent' : 'received'}">
                            <p>${message.message}</p>
                            <span class="timestamp"><fmt:formatDate value="${message.sentAt}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
                            <c:if test="${message.senderId == sessionScope.user.userId}">
                                <form action="sendMessage" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="messageId" value="${message.messageId}">
                                    <input type="hidden" name="receiverId" value="${selectedReceiverId}">
                                    <button type="submit" class="delete-btn">X</button>
                                </form>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>

                <div class="chat-footer">
                    <c:if test="${not empty selectedReceiverId}">
                        <form id="messageForm">
                            <input type="hidden" name="receiverId" value="${selectedReceiverId}">
                            <textarea name="message" id="messageInput" placeholder="Nhập tin nhắn..." required></textarea>
                            <button class="send-btn" type="button" onclick="sendMessage()">Gửi</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>

        <script>
            var ws;
            var currentUserId = "${sessionScope.user.userId}";
            var selectedReceiverId = "${selectedReceiverId}";
            var serverIp = "localhost"; // Sử dụng localhost

            // Khởi tạo WebSocket với IP localhost
            function initWebSocket() {
                if (ws)
                    ws.close();
                ws = new WebSocket("ws://" + serverIp + ":8080/JobLinks/chat/" + currentUserId);

                ws.onopen = function () {
                    console.log("WebSocket connected for user " + currentUserId + ", readyState: " + ws.readyState);
                };

                ws.onmessage = function (event) {
                    var chatContent = document.getElementById('chatContent');
                    var messageData = event.data.split(":");
                    if (messageData.length === 2) {
                        var senderId = parseInt(messageData[0]);
                        var content = messageData[1];

                        // Nếu đang chat đúng với người gửi => hiển thị tin nhắn
                        if (senderId === parseInt(selectedReceiverId)) {
                            var messageDiv = document.createElement('div');
                            messageDiv.className = "message received";
                            messageDiv.innerHTML = "<p>" + content + "</p><span class='timestamp'>" + new Date().toLocaleTimeString() + "</span>";
                            chatContent.appendChild(messageDiv);
                            chatContent.scrollTop = chatContent.scrollHeight;
                        } else {
                            // Có thể thêm thông báo popup hoặc cập nhật sidebar nếu cần
                            console.log("Nhận tin nhắn từ " + senderId + " nhưng không phải cuộc trò chuyện hiện tại.");
                        }
                    }
                };


                ws.onerror = function (error) {
                    console.error("WebSocket error: ", error);
                    alert("Kết nối WebSocket thất bại. Chi tiết: " + error);
                };

                ws.onclose = function (event) {
                    console.log("WebSocket closed, code: " + event.code + ", reason: " + event.reason + ", readyState: " + ws.readyState);
                    alert("Kết nối WebSocket đã đóng. Mã lỗi: " + event.code + ", Lý do: " + event.reason);
                };
            }

            // Chọn cuộc trò chuyện và cập nhật nội dung
            function selectConversation(receiverId, fullName) {
                selectedReceiverId = receiverId;
                document.getElementById('messageForm').querySelector('input[name="receiverId"]').value = receiverId;
                // Lấy lại nội dung tin nhắn từ server
                window.location.href = "sendMessage?receiverId=" + receiverId;
                // Xóa trạng thái unread khi chọn
                updateUnreadStatus(receiverId, true);
            }

            // Cập nhật trạng thái unread trong sidebar
            function updateUnreadStatus(receiverId, viewed) {
                var convItem = document.getElementById('conv_' + receiverId);
                if (convItem) {
                    var latestMsg = convItem.querySelector('.latest-message');
                    if (latestMsg && !viewed) {
                        latestMsg.classList.add('unread');
                    } else if (latestMsg) {
                        latestMsg.classList.remove('unread');
                    }
                }
            }

            // Khởi tạo WebSocket khi trang load
            window.onload = function () {
                initWebSocket();
                var chatContent = document.getElementById('chatContent');
                chatContent.scrollTop = chatContent.scrollHeight;
                console.log("Initialized with currentUserId: " + currentUserId + ", selectedReceiverId: " + selectedReceiverId);
            };

            // Tìm kiếm chỉ khi nhấn Enter
            var searchInput = document.querySelector('.search-bar input');
            if (searchInput) {
                searchInput.addEventListener('keydown', function (event) {
                    if (event.key === 'Enter' || event.keyCode === 13) {
                        this.form.submit();
                    }
                });

                searchInput.addEventListener('input', function () {
                    if (this.value.trim() === '') {
                        this.form.submit();
                    }
                });
            }

            // Gửi tin nhắn qua WebSocket
            function sendMessage() {
                var messageInput = document.getElementById('messageInput');
                var message = messageInput.value.trim();
                console.log("Sending message. ws: ", ws, "readyState: ", ws ? ws.readyState : "null", "selectedReceiverId: ", selectedReceiverId);
                if (message && ws && ws.readyState === WebSocket.OPEN && selectedReceiverId) {
                    var messageToSend = selectedReceiverId + ":" + message;
                    ws.send(messageToSend);
                    messageInput.value = "";

                    var chatContent = document.getElementById('chatContent');
                    var messageDiv = document.createElement('div');
                    messageDiv.className = "message sent";
                    messageDiv.innerHTML = "<p>" + message + "</p><span class='timestamp'>" + new Date().toLocaleTimeString() + "</span>";
                    chatContent.appendChild(messageDiv);
                    chatContent.scrollTop = chatContent.scrollHeight;
                } else {
                    var errorMsg = "Không gửi được tin nhắn. ";
                    if (!message)
                        errorMsg += "Tin nhắn trống. ";
                    if (!ws)
                        errorMsg += "WebSocket không khởi tạo. ";
                    else if (ws.readyState !== WebSocket.OPEN)
                        errorMsg += "WebSocket chưa sẵn sàng (readyState: " + (ws ? ws.readyState : "null") + "). ";
                    if (!selectedReceiverId)
                        errorMsg += "Chưa chọn người nhận. ";
                    alert(errorMsg);
                }
            }
        </script>
    </body>
</html>