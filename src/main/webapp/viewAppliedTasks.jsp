<%@ page import="model.Task" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dal.TaskDAO" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications - JobLinks</title>
    <style>
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .nav-links a { margin-left: 15px; text-decoration: none; color: #007bff; }
        .task-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .task-card { border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
        .task-title { font-size: 1.2em; font-weight: bold; margin-bottom: 10px; }
        .task-info { margin-bottom: 5px; }
        .task-actions { display: flex; gap: 10px; }
        .btn { padding: 5px 10px; text-decoration: none; border-radius: 3px; }
        .btn-secondary { background-color: #6c757d; color: white; border: none; cursor: pointer; }
        .btn-secondary:disabled { background-color: #ccc; cursor: not-allowed; }
        .empty-state { text-align: center; padding: 50px 0; }
        .alert { padding: 10px; margin-bottom: 10px; border-radius: 5px; }
        .alert-success { background-color: #d4edda; color: #155724; }
        .alert-error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>My Applications</h1>
            <div class="nav-links">
                <a href="tasks">Available Tasks</a>
                <a href="tasks?action=applied" class="active">My Applications</a>
            </div>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <% String success = (String) request.getAttribute("success");
           if (success != null) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>

        <% 
            TaskDAO taskDAO = new TaskDAO();
            List<Task> tasks = taskDAO.getAppliedTasks((Integer) session.getAttribute("user_id"));
            if (tasks != null && !tasks.isEmpty()) { %>
            <div class="task-grid">
                <% for (Task task : tasks) { %>
                    <div class="task-card">
                        <div class="task-title"><%= task.getTitle() %></div>
                        <div class="task-info"><strong>Client:</strong> <%= task.getClientName() != null ? task.getClientName() : "Unknown" %></div>
                        <% if (task.getCategoryName() != null) { %>
                            <div class="task-info"><strong>Category:</strong> <%= task.getCategoryName() %></div>
                        <% } %>
                        <div class="task-info"><strong>Status:</strong> <%= task.getApplicationStatus() != null ? task.getApplicationStatus() : "N/A" %></div>
                        <div class="task-info"><strong>Applied At:</strong> <%= task.getAppliedAt() != null ? new SimpleDateFormat("dd/MM/yyyy HH:mm").format(task.getAppliedAt()) : "N/A" %></div>
                        <div class="task-info"><strong>Message:</strong> <%= task.getApplicationMessage() != null ? task.getApplicationMessage() : "No message" %></div>
                        <div class="task-actions">
                            <form action="taskApplication" method="post" onsubmit="return confirm('Are you sure you want to cancel this application?')">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="application_id" value="<%= task.getApplicationId() %>">
                                <button type="submit" class="btn btn-secondary" <%= !"pending".equals(task.getApplicationStatus()) ? "disabled" : "" %>>Cancel Application</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <h3>No Applied Tasks</h3>
                <p>You have not applied for any tasks yet.</p>
                <p><a href="tasks" class="btn-add-task">Browse Available Tasks</a></p>
            </div>
        <% } %>
    </div>

    <script>
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>