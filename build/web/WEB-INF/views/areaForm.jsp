<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Area"%>

<%
    Area area = (Area) request.getAttribute("AREA");

    boolean edit = area != null
            && area.getAreaId() != null
            && !area.getAreaId().trim().isEmpty();

    String error = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= edit ? "Edit Area" : "Add Area" %></title>

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

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 9px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        textarea {
            height: 100px;
            resize: vertical;
        }

        .error {
            color: #dc3545;
            margin-bottom: 15px;
        }

        .buttons {
            margin-top: 20px;
        }

        button, a {
            padding: 9px 15px;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-save {
            background: #198754;
            color: white;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }
    </style>
</head>

<body>

<div class="container">

    <h1>
        <%= edit ? "Edit Area" : "Add Area" %>
    </h1>

    <% if (error != null) { %>
        <div class="error">
            <%= error %>
        </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/area/save"
          method="POST">

        <div class="form-group">

            <label>Area ID</label>

            <input type="text"
                   name="areaId"
                   value="<%= edit ? area.getAreaId() : "" %>"
                   <%= edit ? "readonly" : "" %>
                   required>

        </div>

        <div class="form-group">

            <label>Area Name</label>

            <input type="text"
                   name="areaName"
                   value="<%= edit ? area.getAreaName() : "" %>"
                   required>

        </div>

        <div class="form-group">

            <label>Description</label>

            <textarea name="description"><%= edit ? area.getDescription() : "" %></textarea>

        </div>

        <div class="buttons">

            <button type="submit" class="btn-save">
                <%= edit ? "Update Area" : "Create Area" %>
            </button>

            <a class="btn-cancel"
               href="<%=request.getContextPath()%>/area">
                Cancel
            </a>

        </div>

    </form>

</div>

</body>
</html>