<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SmartWaste Login</title>
    </head>

    <body>

        <h2>SmartWaste Management - Login</h2>

        <form action="<%= request.getContextPath() %>/login" method="POST">

            <label for="username">Username:</label>
            <input type="text"
                   id="username"
                   name="username"
                   required />
            <br/>

            <label for="password">Password:</label>
            <input type="password"
                   id="password"
                   name="password"
                   required />
            <br/>

            <input type="submit" value="Login" />

        </form>

        <%
            String error = (String) request.getAttribute("ERROR");

            if (error == null) {
                error = "";
            }
        %>

        <p style="color: red;">
            <%= error %>
        </p>

    </body>
</html>