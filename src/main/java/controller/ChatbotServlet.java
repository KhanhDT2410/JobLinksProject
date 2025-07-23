package controller;

import dao.ChatbotDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ChatbotServlet extends HttpServlet {

    // Hàm escape để bảo vệ phản hồi JSON
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "")
                    .replace("\t", "\\t");
        // KHÔNG thay thế < > nếu muốn hiển thị thẻ HTML
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String message = request.getParameter("message");
        System.out.println("👉 Message received: " + message);

        String reply;
        if (message == null || message.trim().isEmpty()) {
            reply = "Tin nhắn rỗng, vui lòng nhập lại!";
        } else {
            reply = ChatbotDAO.getResponse(message.trim(), getServletContext());
        }

        String safeReply = escapeJson(reply);
        String jsonResponse = "{\"reply\": \"" + safeReply + "\"}";

        System.out.println("✅ JSON response: " + jsonResponse);

        response.getWriter().write(jsonResponse);
    }
}