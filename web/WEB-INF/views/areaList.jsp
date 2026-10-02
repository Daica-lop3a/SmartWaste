<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Area"%>
<%@page import="model.AppUser"%>

<%
    List<Area> list
            = (List<Area>) request.getAttribute("LIST_AREA");

    String error
            = (String) request.getAttribute("ERROR");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String role
            = currentUser != null
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

        <title>Area Management</title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background: #f5f7fa;
            }

            h1 {
                margin-bottom: 20px;
            }

            .top-bar {
                margin-bottom: 20px;
            }

            .btn {
                display: inline-block;
                padding: 9px 14px;
                margin-right: 6px;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background: #2563eb;
                color: white;
            }

            .btn-secondary {
                background: #6b7280;
            }

            .btn-danger {
                background: #dc2626;
            }

            .role-info {
                background: white;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
            }

            .error {
                color: #b91c1c;
                margin-bottom: 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            th {
                background: #e5e7eb;
            }

            form {
                display: inline;
            }

        </style>

    </head>

    <body>

        <h1>Area Management</h1>

        <div class="role-info">

            Logged in as:

            <strong>
                <%=currentUser != null
                        ? currentUser.getFullName()
                        : ""%>
            </strong>

            |

            Role:

            <strong>
                <%=role%>
            </strong>

        </div>


        <div class="top-bar">

            <% if (canManage) {%>

            <a class="btn"
               href="<%=request.getContextPath()%>/area/create">
                Add Area
            </a>

            <% }%>


            <a class="btn btn-secondary"
               href="<%=request.getContextPath()%>/dashboard">
                Dashboard
            </a>

        </div>


        <% if (error != null) {%>

        <div class="error">
            <%=error%>
        </div>

        <% } %>


        <table>

            <thead>

                <tr>

                    <th>Area ID</th>

                    <th>Area Name</th>

                    <th>Description</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

                <%
                    if (list != null && !list.isEmpty()) {

                        for (Area area : list) {
                %>

                <tr>

                    <td>
                        <%=area.getAreaId()%>
                    </td>

                    <td>
                        <%=area.getAreaName()%>
                    </td>

                    <td>
                        <%=area.getDescription()%>
                    </td>

                    <td>

                        <!-- VIEW -->

                        <a class="btn btn-secondary"
                           href="<%=request.getContextPath()%>/area/view?id=<%=area.getAreaId()%>">
                            View
                        </a>


                        <% if (canManage) {%>

                        <!-- EDIT -->

                        <a class="btn"
                           href="<%=request.getContextPath()%>/area/edit?id=<%=area.getAreaId()%>">
                            Edit
                        </a>


                        <!-- DELETE -->

                        <form action="<%=request.getContextPath()%>/area/delete"
                              method="POST"
                              onsubmit="return confirm('Are you sure you want to delete this area?');">

                            <input type="hidden"
                                   name="id"
                                   value="<%=area.getAreaId()%>">

                            <button type="submit"
                                    class="btn btn-danger">
                                Delete
                            </button>

                        </form>

                        <% } %>

                    </td>

                </tr>

                <%
                    }

                } else {
                %>

                <tr>

                    <td colspan="4">
                        No areas found.
                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

        </table>

    </body>

</html>