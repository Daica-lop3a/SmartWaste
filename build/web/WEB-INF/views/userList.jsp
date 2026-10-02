<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="model.AppUser"%>

<%
    List<AppUser> list
            = (List<AppUser>) request.getAttribute("LIST_USER");

    String keyword
            = (String) request.getAttribute("KEYWORD");

    String roleId
            = (String) request.getAttribute("ROLE_ID");

    String error
            = (String) request.getAttribute("ERROR");

    AppUser currentUser
            = (AppUser) session.getAttribute("user");

    String currentRole
            = currentUser != null
                    ? currentUser.getRoleId()
                    : "";
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>User Management</title>

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

            .btn-danger {
                background: #dc2626;
            }

            .btn-warning {
                background: #d97706;
            }

            .btn-secondary {
                background: #6b7280;
            }

            .search-box {
                background: white;
                padding: 15px;
                margin-bottom: 20px;
            }

            .search-box input,
            .search-box select {
                padding: 8px;
                margin-right: 8px;
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

            .error {
                color: #b91c1c;
                margin-bottom: 15px;
            }

            .status-active {
                color: #15803d;
                font-weight: bold;
            }

            .status-locked {
                color: #b91c1c;
                font-weight: bold;
            }

            form {
                display: inline;
            }

        </style>

    </head>

    <body>

        <h1>User Management</h1>


        <div class="top-bar">

            <strong>
                Role: <%=currentRole%>
            </strong>

            <br><br>

            <a class="btn"
               href="<%=request.getContextPath()%>/user/create">
                Add User
            </a>

            <a class="btn btn-secondary"
               href="<%=request.getContextPath()%>/dashboard">
                Dashboard
            </a>

        </div>


        <% if (error != null) {%>

        <div class="error">
            <%=error%>
        </div>

        <% }%>


        <div class="search-box">

            <form action="<%=request.getContextPath()%>/user"
                  method="GET">

                <input type="text"
                       name="keyword"
                       placeholder="Search user..."
                       value="<%=keyword != null ? keyword : ""%>">


                <select name="roleId">

                    <option value="">
                        All Roles
                    </option>

                    <option value="ADM"
                            <%="ADM".equals(roleId)
                                    ? "selected" : ""%>>
                        Admin
                    </option>

                    <option value="MGR"
                            <%="MGR".equals(roleId)
                                    ? "selected" : ""%>>
                        Manager
                    </option>

                    <option value="STF"
                            <%="STF".equals(roleId)
                                    ? "selected" : ""%>>
                        Staff
                    </option>

                    <option value="TEC"
                            <%="TEC".equals(roleId)
                                    ? "selected" : ""%>>
                        Technician
                    </option>

                </select>


                <button type="submit"
                        class="btn">
                    Search
                </button>

            </form>

        </div>


        <table>

            <thead>

                <tr>

                    <th>User ID</th>

                    <th>Full Name</th>

                    <th>Email</th>

                    <th>Phone</th>

                    <th>Role</th>

                    <th>Status</th>

                    <th>Action</th>

                </tr>

            </thead>


            <tbody>

                <%
                    if (list != null && !list.isEmpty()) {

                        for (AppUser user : list) {
                %>

                <tr>

                    <td>
                        <%=user.getUserId()%>
                    </td>

                    <td>
                        <%=user.getFullName()%>
                    </td>

                    <td>
                        <%=user.getEmail()%>
                    </td>

                    <td>
                        <%=user.getPhoneNumber()%>
                    </td>

                    <td>
                        <%=user.getRoleId()%>
                    </td>

                    <td>

                        <% if (user.isStatus()) { %>

                        <span class="status-active">
                            Active
                        </span>

                        <% } else { %>

                        <span class="status-locked">
                            Locked
                        </span>

                        <% }%>

                    </td>


                    <td>

                    <td>

                        <a class="btn btn-secondary"
                           href="<%=request.getContextPath()%>/user/view?id=<%=user.getUserId()%>">
                            View
                        </a>

                        <a class="btn"
                           href="<%=request.getContextPath()%>/user/edit?id=<%=user.getUserId()%>">
                            Edit
                        </a>


                        <form action="<%=request.getContextPath()%>/user/lock"
                              method="POST">

                            <input type="hidden"
                                   name="id"
                                   value="<%=user.getUserId()%>">

                            <button type="submit"
                                    class="btn btn-warning">

                                <%=user.isStatus()
                                        ? "Lock"
                                        : "Unlock"%>

                            </button>

                        </form>


                        <form action="<%=request.getContextPath()%>/user/reset"
                              method="POST"
                              onsubmit="return confirm('Reset password for this user?');">

                            <input type="hidden"
                                   name="id"
                                   value="<%=user.getUserId()%>">

                            <button type="submit"
                                    class="btn">
                                Reset
                            </button>

                        </form>


                        <form action="<%=request.getContextPath()%>/user/delete"
                              method="POST"
                              onsubmit="return confirm('Are you sure you want to delete this user?');">

                            <input type="hidden"
                                   name="id"
                                   value="<%=user.getUserId()%>">

                            <button type="submit"
                                    class="btn btn-danger">
                                Delete
                            </button>

                        </form>

                    </td>


            <form action="<%=request.getContextPath()%>/user/lock"
                  method="POST">

                <input type="hidden"
                       name="id"
                       value="<%=user.getUserId()%>">

                <button type="submit"
                        class="btn btn-warning">

                    <%=user.isStatus()
                            ? "Lock"
                            : "Unlock"%>

                </button>

            </form>


            <form action="<%=request.getContextPath()%>/user/reset"
                  method="POST"
                  onsubmit="return confirm('Reset password for this user?');">

                <input type="hidden"
                       name="id"
                       value="<%=user.getUserId()%>">

                <button type="submit"
                        class="btn">
                    Reset
                </button>

            </form>


            <form action="<%=request.getContextPath()%>/user/delete"
                  method="POST"
                  onsubmit="return confirm('Are you sure you want to delete this user?');">

                <input type="hidden"
                       name="id"
                       value="<%=user.getUserId()%>">

                <button type="submit"
                        class="btn btn-danger">
                    Delete
                </button>

            </form>

        </td>

    </tr>

    <%
        }

    } else {
    %>

    <tr>

        <td colspan="7">
            No users found.
        </td>

    </tr>

    <%
        }
    %>

</tbody>

</table>

</body>

</html>