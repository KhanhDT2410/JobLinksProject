<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Create Notification</title>

    <!-- Custom fonts for this template-->
    <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css" rel="stylesheet" />

    <!-- Summernote CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs4.min.css" rel="stylesheet">

</head>

<body id="page-top">

    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <%@include file="/admin_include/admin-sidebar.jsp" %>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column" style="margin-left: 240px;">

            <!-- Main Content -->
            <div id="content">

                <!-- Header -->
                <%@include file="/admin_include/admin-header.jsp" %>
                <!-- End of Header -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-4 text-gray-800">Create Notification</h1>

                    <!-- Notification Form -->
                    <div class="row">
                        <div class="col-lg-8">

                            <form action="${pageContext.request.contextPath}/admin/createNotification" method="post">

                                <div class="form-group">
                                    <label for="message">Notification Message <span style="color:red;">*</span></label>
                                    <textarea id="message" name="message" required></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="targetUserId">Send To (optional)</label>
                                    <select class="form-control" name="targetUserId" id="targetUserId">
                                        <option value="">-- All Users --</option>
                                        <% for (User user : users) { %>
                                            <option value="<%= user.getUserId() %>">
                                                <%= user.getFullName() %> (ID: <%= user.getUserId() %>, Email: <%= user.getEmail() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary">Send Notification</button>

                            </form>

                            <!-- Status Message -->
                            <% if (request.getParameter("status") != null && request.getParameter("status").equals("success")) { %>
                                <div class="alert alert-success mt-4" role="alert">
                                    Notification created successfully!
                                </div>
                            <% } else if (request.getParameter("status") != null && request.getParameter("status").equals("error")) { %>
                                <div class="alert alert-danger mt-4" role="alert">
                                    Failed to create notification. Please try again.
                                </div>
                            <% } %>

                        </div>
                    </div>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->

            <!-- Footer -->
            <%@include file="/admin_include/admin-footer.jsp" %>
            <!-- End of Footer -->

        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Bootstrap core JavaScript-->
    <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>

    <!-- Summernote JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs4.min.js"></script>

    <script>
        $(document).ready(function () {
            $('#message').summernote({
                height: 300
            });
        });
    </script>

</body>

</html>
