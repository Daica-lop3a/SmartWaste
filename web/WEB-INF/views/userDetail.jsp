<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.AppUser"%>

<%
    AppUser user = (AppUser) request.getAttribute("USER");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <title>
            View User - SmartWaste
        </title>

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background: #f5f6fa;
            }

            .header {
                background: #1f2937;
                color: white;
                padding: 18px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .header h2 {
                margin: 0;
            }

            .container {
                width: 600px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
            }

            .info-group {
                margin-bottom: 18px;
            }

            .label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
                color: #374151;
            }

            .value {
                padding: 10px;
                background: #f3f4f6;
                border: 1px solid #ddd;
                border-radius: 5px;
            }

            .status-active {
                color: #15803d;
                font-weight: bold;
            }

            .status-locked {
                color: #b91c1c;
                font-weight: bold;
            }

            .buttons {
                margin-top: 25px;
            }

            .btn {
                padding: 10px 16px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                cursor: pointer;
                display: inline-block;
            }

            .btn-primary {
                background: #2563eb;
                color: white;
            }

            .btn-secondary {
                background: #6b7280;
                color: white;
            }
        </style>
    </head>

    <body>

        <div class="header">

            <h2>SmartWaste - User Management</h2>

            <a class="btn btn-secondary"
               href="<%=request.getContextPath()%>/user">
                Back to User List
            </a>

        </div>


        <div class="container">

            <h2>View User</h2>


            <!-- USER ID -->

            <div class="info-group">

                <span class="label">
                    User ID
                </span>

                <div class="value">
                    <%=user != null && user.getUserId() != null
                            ? user.getUserId()
                            : ""%>
                </div>

            </div>


            <!-- FULL NAME -->

            <div class="info-group">

                <span class="label">
                    Full Name
                </span>

                <div class="value">
                    <%=user != null && user.getFullName() != null
                            ? user.getFullName()
                            : ""%>
                </div>

            </div>


            <!-- EMAIL -->

            <div class="info-group">

                <span class="label">
                    Email
                </span>

                <div class="value">
                    <%=user != null && user.getEmail() != null
                            ? user.getEmail()
                            : ""%>
                </div>

            </div>


            <!-- PHONE -->

            <div class="info-group">

                <span class="label">
                    Phone Number
                </span>

                <div class="value">
                    <%=user != null && user.getPhoneNumber() != null
                            ? user.getPhoneNumber()
                            : ""%>
                </div>

            </div>


            <!-- ROLE -->

            <div class="info-group">

                <span class="label">
                    Role
                </span>

                <div class="value">
                    <%=user != null && user.getRoleId() != null
                            ? user.getRoleId()
                            : ""%>
                </div>

            </div>


            <!-- STATUS -->

            <div class="info-group">

                <span class="label">
                    Status
                </span>

                <div class="value">

                    <%
                        if (user != null && user.isStatus()) {
                    %>

                    <span class="status-active">
                        Active
                    </span>

                    <%
                    } else {
                    %>

                    <span class="status-locked">
                        Locked
                    </span>

                    <%
                        }
                    %>

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="buttons">

                <%
                    if (user != null) {
                %>

                <a href="<%=request.getContextPath()%>/user/edit?id=<%=user.getUserId()%>"
                   class="btn btn-primary">
                    Edit User
                </a>

                <%
                    }
                %>

                <a href="<%=request.getContextPath()%>/user"
                   class="btn btn-secondary">
                    Back
                </a>

            </div>

        </div>

    </body>
</html>