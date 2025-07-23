package controller;

import dao.DBContext;
import dao.MessageDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Message;
import model.User;

@WebServlet(name = "SendMessageServlet", urlPatterns = {"/sendMessage"})
public class SendMessageServlet extends HttpServlet {

    private DBContext dbContext;
    private MessageDAO messageDAO;
    private static final int DEFAULT_TASK_ID = 1;

    @Override
    public void init() throws ServletException {
        dbContext = new DBContext();
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        User user = (User) session.getAttribute("user");
        Integer userId = null;
        if (user != null) {
            userId = user.getUserId();
        }

        if (userId == null) {
            request.setAttribute("error", "Bạn chưa đăng nhập");
            request.getRequestDispatcher("/sendMessage.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy hoặc khởi tạo danh sách user đã xem từ session
            Set<Integer> viewedUsers = (Set<Integer>) session.getAttribute("viewedUsers");
            if (viewedUsers == null) {
                viewedUsers = new HashSet<>();
                session.setAttribute("viewedUsers", viewedUsers);
            }

            List<Map<String, Object>> allUsers = messageDAO.getAllUsersWithLatestMessage(userId);
            if (allUsers == null) {
                allUsers = new ArrayList<>();
            }

            // Gán trạng thái đã xem vào từng user
            for (Map<String, Object> u : allUsers) {
                Integer otherUserId = (Integer) u.get("userId");
                boolean hasViewed = viewedUsers.contains(otherUserId);
                u.put("hasViewed", hasViewed);
            }

            String searchQuery = request.getParameter("searchQuery");
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                List<Map<String, Object>> filteredUsers = new ArrayList<>();
                for (Map<String, Object> u : allUsers) {
                    String fullName = (String) u.get("fullName");
                    if (fullName != null && fullName.toLowerCase().contains(searchQuery.toLowerCase())) {
                        filteredUsers.add(u);
                    }
                }
                request.setAttribute("allUsers", filteredUsers);
            } else {
                request.setAttribute("allUsers", allUsers);
            }

            String receiverIdStr = request.getParameter("receiverId");
            if (receiverIdStr != null && !receiverIdStr.trim().isEmpty()) {
                try {
                    int receiverId = Integer.parseInt(receiverIdStr.trim());
                    List<Message> messages = messageDAO.getMessagesBetweenUsers(userId, receiverId, DEFAULT_TASK_ID);
                    viewedUsers.add(receiverId); // Đánh dấu user đã xem
                    session.setAttribute("viewedUsers", viewedUsers);
                    request.setAttribute("messages", messages);
                    request.setAttribute("selectedReceiverId", receiverId);

                    // Cập nhật lại danh sách user sau khi đánh dấu đã xem
                    for (Map<String, Object> u : allUsers) {
                        Integer otherUserId = (Integer) u.get("userId");
                        boolean hasViewed = viewedUsers.contains(otherUserId);
                        u.put("hasViewed", hasViewed);
                    }
                    request.setAttribute("allUsers", allUsers);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID người nhận không hợp lệ.");
                }
            } else {
                request.setAttribute("messages", new ArrayList<>());
            }

            request.getRequestDispatcher("/sendMessage.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/sendMessage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        User user = (User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getUserId() : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                String messageIdStr = request.getParameter("messageId");
                String receiverIdStr = request.getParameter("receiverId");

                if (messageIdStr == null || receiverIdStr == null) {
                    request.setAttribute("error", "Thông tin không hợp lệ");
                    doGet(request, response);
                    return;
                }

                int messageId = Integer.parseInt(messageIdStr);
                int receiverId = Integer.parseInt(receiverIdStr);

                boolean deleted = messageDAO.deleteMessage(messageId, userId);
                if (deleted) {
                    List<Map<String, Object>> allUsers = messageDAO.getAllUsersWithLatestMessage(userId);
                    request.setAttribute("allUsers", allUsers);
                    List<Message> messages = messageDAO.getMessagesBetweenUsers(userId, receiverId, DEFAULT_TASK_ID);
                    request.setAttribute("messages", messages);
                    request.setAttribute("selectedReceiverId", receiverId);
                    request.getRequestDispatcher("/sendMessage.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không thể xóa tin nhắn");
                    doGet(request, response);
                }
                return;
            }

            String receiverIdStr = request.getParameter("receiverId");
            String messageContent = request.getParameter("message");

            if (receiverIdStr == null || receiverIdStr.trim().isEmpty() || messageContent == null || messageContent.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                doGet(request, response);
                return;
            }

            int receiverId = Integer.parseInt(receiverIdStr.trim());

            Message message = new Message();
            message.setSenderId(userId);
            message.setReceiverId(receiverId);
            message.setTaskId(DEFAULT_TASK_ID);
            message.setMessage(messageContent);

            boolean success = messageDAO.sendMessage(message);
            if (success) {
                Set<Integer> viewedUsers = (Set<Integer>) session.getAttribute("viewedUsers");
                if (viewedUsers == null) {
                    viewedUsers = new HashSet<>();
                    session.setAttribute("viewedUsers", viewedUsers);
                }
                viewedUsers.add(receiverId); // Đánh dấu đã xem sau khi gửi tin nhắn
                List<Map<String, Object>> allUsers = messageDAO.getAllUsersWithLatestMessage(userId);
                for (Map<String, Object> u : allUsers) {
                    Integer otherUserId = (Integer) u.get("userId");
                    boolean hasViewed = viewedUsers.contains(otherUserId);
                    u.put("hasViewed", hasViewed);
                }
                request.setAttribute("allUsers", allUsers);
                List<Message> messages = messageDAO.getMessagesBetweenUsers(userId, receiverId, DEFAULT_TASK_ID);
                request.setAttribute("messages", messages);
                request.setAttribute("selectedReceiverId", receiverId);
                request.getRequestDispatcher("/sendMessage.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không thể gửi tin nhắn");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ: " + e.getMessage());
            doGet(request, response);
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi gửi tin nhắn: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    public void destroy() {
        if (dbContext != null) {
            dbContext.close();
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý gửi và hiển thị tin nhắn";
    }
}