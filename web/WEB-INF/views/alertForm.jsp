<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Alert"%>
<%@page import="model.AppUser"%>

<%
    Alert alert
            = (Alert) request.getAttribute("ALERT");

    AppUser user
            = (AppUser) session.getAttribute("user");

    boolean canManage
            = user != null
            && ("ADM".equals(user.getRoleId())
            || "MGR".equals(user.getRoleId()));
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Alert Details</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
                margin: 30px;
            }

            .container {
                width: 700px;
                margin: auto;
                background-color: white;
                padding: 25px;
                border-radius: 8px;
            }

            h2 {
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                width: 180px;
                background-color: #f2f2f2;
            }

            .resolved {
                color: #198754;
                font-weight: bold;
            }

            .unresolved {
                color: #dc3545;
                font-weight: bold;
            }

            .message {
                white-space: pre-wrap;
            }

            .btn {
                display: inline-block;
                padding: 9px 16px;
                margin-right: 5px;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            .btn-back {
                background-color: #6c757d;
                color: white;
            }

            .btn-edit {
                background-color: #ffc107;
                color: black;
            }

            .btn-delete {
                background-color: #dc3545;
                color: white;
            }

            .btn-resolve {
                background-color: #198754;
                color: white;
            }

            .btn-unresolve {
                background-color: #6c757d;
                color: white;
            }

            form {
                display: inline;
            }

        </style>

    </head>

    <body>

        <div class="container">

            <h2>Alert Details</h2>

            <% if (alert != null) {%>

            <table>

                <tr>

                    <th>Alert ID</th>

                    <td>
                        <%=alert.getAlertID()%>
                    </td>

                </tr>

                <tr>

                    <th>Waste Bin</th>

                    <td>
                        <%=alert.getBinID()%>
                    </td>

                </tr>

                <tr>

                    <th>Alert Type</th>

                    <td>
                        <%=alert.getAlertType()%>
                    </td>

                </tr>

                <tr>

                    <th>Message</th>

                    <td class="message">
                        <%=alert.getMessage()%>
                    </td>

                </tr>

                <tr>

                    <th>Created Date</th>

                    <td>
                        <%=alert.getCreatedDate()%>
                    </td>

                </tr>

                <tr>

                    <th>Status</th>

                    <td>

                        <% if (alert.isResolved()) { %>

                        <span class="resolved">
                            Resolved
                        </span>

                        <% } else { %>

                        <span class="unresolved">
                            Unresolved
                        </span>

                        <% } %>

                    </td>

                </tr>

            </table>


            <!-- ADMIN / MANAGER ACTIONS -->

            <% if (canManage) {%>

            <a class="btn btn-edit"
               href="<%=request.getContextPath()%>/alert/edit?id=<%=alert.getAlertID()%>">
                Edit
            </a>


            <% if (!alert.isResolved()) {%>

            <form method="post"
                  action="<%=request.getContextPath()%>/alert/resolve">

                <input type="hidden"
                       name="id"
                       value="<%=alert.getAlertID()%>">

                <input type="hidden"
                       name="value"
                       value="true">

                <button class="btn btn-resolve"
                        type="submit">

                    Resolve

                </button>

            </form>

            <% } else {%>

            <form method="post"
                  action="<%=request.getContextPath()%>/alert/resolve">

                <input type="hidden"
                       name="id"
                       value="<%=alert.getAlertID()%>">

                <input type="hidden"
                       name="value"
                       value="false">

                <button class="btn btn-unresolve"
                        type="submit">

                    Unresolve

                </button>

            </form>

            <% }%>


            <form method="post"
                  action="<%=request.getContextPath()%>/alert/delete"
                  onsubmit="return confirm('Bạn có chắc muốn xóa Alert này không?');">

                <input type="hidden"
                       name="id"
                       value="<%=alert.getAlertID()%>">

                <button class="btn btn-delete"
                        type="submit">

                    Delete

                </button>

            </form>

            <% }%>


            <a class="btn btn-back"
               href="<%=request.getContextPath()%>/alert">

                Back to Alert

            </a>

            <% } else {%>

            <p>Alert không tồn tại.</p>

            <a class="btn btn-back"
               href="<%=request.getContextPath()%>/alert">

                Back to Alert

            </a>

            <% }%>

        </div>

    </body>

</html>