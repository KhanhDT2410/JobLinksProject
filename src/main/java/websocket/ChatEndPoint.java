package websocket;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import dao.MessageDAO;
import jakarta.websocket.CloseReason;
import model.Message;

@ServerEndpoint(value = "/chat/{userId}")
public class ChatEndPoint {

    private static final ConcurrentHashMap<Integer, Set<Session>> userSessions = new ConcurrentHashMap<>();
    private static final MessageDAO messageDAO = new MessageDAO();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userIdStr) {
        try {
            int userId = Integer.parseInt(userIdStr);
            session.getUserProperties().put("userId", userId);
            userSessions.computeIfAbsent(userId, k -> Collections.newSetFromMap(new ConcurrentHashMap<>())).add(session);
            System.out.println("WebSocket OPENED for user " + userId + ", session ID: " + session.getId());
        } catch (NumberFormatException e) {
            System.err.println("Invalid userId format: " + userIdStr);
            try {
                if (session.isOpen()) session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "Invalid userId"));
            } catch (IOException io) {
                System.err.println("Failed to close session: " + io.getMessage());
            }
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            String[] parts = message.split(":", 2);
            if (parts.length == 2) {
                int receiverId = Integer.parseInt(parts[0].trim());
                String content = parts[1].trim();
                int senderId = getUserIdFromSession(session);

                if (senderId != -1) {
                    Message msg = new Message();
                    msg.setSenderId(senderId);
                    msg.setReceiverId(receiverId);
                    msg.setTaskId(1); // Gi� tr? m?c ??nh, thay n?u c?n
                    msg.setMessage(content);
                    messageDAO.sendMessage(msg);

                    Set<Session> receiverSessions = userSessions.get(receiverId);
                    if (receiverSessions != null && !receiverSessions.isEmpty()) {
                        for (Session s : receiverSessions) {
                            if (s.isOpen() && !s.equals(session)) {
                                // G?i c? senderId v� content
                                s.getAsyncRemote().sendText(senderId + ":" + content);
                            }
                        }
                        System.out.println("Message sent to user " + receiverId + " from " + senderId);
                    } else {
                        System.out.println("No active sessions for user " + receiverId);
                    }
                } else {
                    System.err.println("Sender ID not found in session for session ID: " + session.getId());
                }
            } else {
                System.err.println("Invalid message format: " + message);
            }
        } catch (Exception e) {
            System.err.println("Error processing message: " + e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session, CloseReason reason) {
        int userId = getUserIdFromSession(session);
        if (userId != -1) {
            Set<Session> sessions = userSessions.get(userId);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    userSessions.remove(userId);
                }
                System.out.println("WebSocket CLOSED for user " + userId + ", session ID: " + session.getId() + ", reason: " + reason);
            }
        }
    }

    private int getUserIdFromSession(Session session) {
        Object userIdObj = session.getUserProperties().get("userId");
        return (userIdObj instanceof Integer) ? (Integer) userIdObj : -1;
    }
}