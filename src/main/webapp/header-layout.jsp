<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

    </head>
    
    <body>
        <c:if test="${not empty sessionScope.user}">
            <%@include file="page-sidebar.jsp" %>
            <%@include file="chatbot.jsp" %>
        </c:if>  
        <%@include file="header.jsp" %>

    </body>
</html>