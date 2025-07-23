<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chat Support</title>
    <style>
        .chat-popup {
            display: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 350px;
            height: 450px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            font-family: Arial, sans-serif;
            margin-bottom: 50px;
        }
        .chat-header {
            background-color: #28a745;
            color: #ffffff;
            padding: 12px;
            text-align: left;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            position: relative;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .chatbot-img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #ffffff;
            padding: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .chatbot-img img {
            width: 20px;
            height: 20px;
        }
        .close-button {
            position: absolute;
            top: 10px;
            right: 15px;
            background: none;
            border: none;
            color: #ffffff;
            font-size: 38px;
            cursor: pointer;
            transition: color 0.3s;
        }
        .close-button:hover {
            color: #ffcccc;
        }
        .chat-body {
            padding: 15px;
            height: 320px;
            overflow-y: auto;
            color: #333333;
            background-color: #f9f9f9;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 25px;
        }
        .message {
            max-width: 70%;
            padding: 8px 12px;
            border-radius: 15px;
            margin: 5px 0;
            margin-bottom: 20px;
        }
        .sent {
            background-color: #e6ffe6;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
        }
        .received {
            background-color: #d9f3ff;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
        }
        .chat-input {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            background-color: #ffffff;
            border-top: 1px solid #e9ecef;
        }
        .chat-input input {
            width: 75%;
            padding: 10px;
            border-radius: 20px;
            border: 2px solid #28a745;
            outline: none;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        .chat-input input:focus {
            border-color: #218838;
        }
        .chat-input button {
            padding: 8px;
            background: none;
            border: none;
            cursor: pointer;
            margin-left: 5px;
        }
        .chat-input button img {
            width: 24px;
            height: 18px;
        }
        .popup-button {
            position: fixed;
            bottom: 25px;
            right: 25px;
            padding: 10px;
            background: #28a745;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            z-index: 1001;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s;
            margin-bottom: 50px;
        }
        .popup-button img {
            width: 30px;
            height: 30px;
            filter: brightness(0) saturate(100%) invert(100%) sepia(0%) saturate(0%) hue-rotate(93deg) brightness(103%) contrast(103%);
        }
        .popup-button:hover {
            transform: scale(1.1);
        }
        .login-message {
            position: fixed;
            bottom: 75px;
            right: 25px;
            color: #dc3545;
            font-size: 14px;
            z-index: 1002;
            font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>
    <button class="popup-button" onclick="toggleChat()">
        <img src="https://img.icons8.com/ios-filled/50/ffffff/chat.png" alt="Chat">
    </button>
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <div class="chatbot-img">
                <img src="https://img.icons8.com/ios-filled/20/000000/chat.png" alt="Chatbot">
            </div>
            Chat Support
            <button class="close-button" onclick="toggleChat()">×</button>
        </div>
        <div class="chat-body" id="chatBody"></div>
        <div class="chat-input">
            <input type="text" id="chatInput" placeholder="Type a message..." onkeypress="if(event.key === 'Enter') sendMessage()">
            <button onclick="sendMessage()">
                <img src="img/send-icon.png" alt="Send">
            </button>
        </div>
    </div>

    <script>
        // Hiển thị đoạn chat
        function toggleChat() {
            var popup = document.getElementById("chatPopup");
            var button = document.querySelector(".popup-button");
            var loginMessage = document.querySelector(".login-message");
            
            if (popup.style.display === "none") {
                popup.style.display = "block";
                button.style.display = "none";
                loginMessage.style.display = "none";
            } else {
                popup.style.display = "none";
                button.style.display = "block";
            }
        }

        function sendMessage() {
            var input = document.getElementById("chatInput").value;
            var chatBody = document.getElementById("chatBody");
            if (input) {
                chatBody.innerHTML += "<p class='message sent'>" + input + "</p>";
                chatBody.scrollTop = chatBody.scrollHeight;
                document.getElementById("chatInput").value = "";

                fetch('<%= request.getContextPath() %>/chatbot', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'message=' + encodeURIComponent(input)
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Máy chủ trả về lỗi: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    // Nếu không tìm thấy phản hồi phù hợp
                    let reply = data.reply;
                    if (!reply || reply.trim() === "") {
                        reply = "Tôi không hiểu rõ vấn đề bạn đang nói, xin hãy mô tả chi tiết hơn.";
                    }

                    chatBody.innerHTML += "<p class='message received'>" + reply.replace(/\n/g, "<br>") + "</p>";
                    chatBody.scrollTop = chatBody.scrollHeight;
                })
                .catch(error => {
                    chatBody.innerHTML += "<p class='message received'>Lỗi khi xử lý tin nhắn: " + error.message + "</p>";
                    chatBody.scrollTop = chatBody.scrollHeight;
                });
            }
        }

    </script>
</body>
</html>