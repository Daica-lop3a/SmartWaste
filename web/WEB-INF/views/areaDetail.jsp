<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Area"%>
<%@page import="model.AppUser"%>

<%
    Area area = (Area) request.getAttribute("AREA");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role = currentUser != null
            ? currentUser.getRoleId()
            : "";

    boolean canManage
            = "ADM".equals(role)
            || "MGR".equals(role);
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>View Area</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: #f5f6f8;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
        }

        h1 {
            margin-top: 0;
        }

        .info-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        .value {
            padding: 10px;
            background: #f3f4f6;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-height: 20px;
        }

        .buttons {
            margin-top: 25px;
        }

        button, a {
            padding: 9px 15px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-edit {
            background: #2563eb;
            color: white;
        }

        .btn-back {
            background: #6c757d;
            color: white;
        }

    </style>

</head>


<body>

<div class="container">

    <h1>View Area</h1>


    <!-- AREA ID -->

    <div class="info-group">

        <label>Area ID</label>

        <div class="value">
            <%=area != null && area.getAreaId() != null
                    ? area.getAreaId()
                    : ""%>
        </div>

    </div>


    <!-- AREA NAME -->

    <div class="info-group">

        <label>Area Name</label>

        <div class="value">
            <%=area != null && area.getAreaName() != null
                    ? area.getAreaName()
                    : ""%>
        </div>

    </div>


    <!-- DESCRIPTION -->

    <div class="info-group">

        <label>Description</label>

        <div class="value">
            <%=area != null && area.getDescription() != null
                    ? area.getDescription()
                    : ""%>
        </div>

    </div>


    <!-- BUTTONS -->

    <div class="buttons">

        <% if (canManage && area != null) { %>

        <a class="btn-edit"
           href="<%=request.getContextPath()%>/area/edit?id=<%=area.getAreaId()%>">
            Edit Area
        </a>

        <% } %>


        <a class="btn-back"
           href="<%=request.getContextPath()%>/area">
            Back
        </a>

    </div>

</div>

</body>

</html>