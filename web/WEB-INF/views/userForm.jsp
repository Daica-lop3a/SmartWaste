<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.AppUser"%>

<%
    AppUser user = (AppUser) request.getAttribute("USER");

    boolean edit = user != null
            && user.getUserId() != null
            && !user.getUserId().trim().isEmpty();

    String error = (String) request.getAttribute("ERROR");

    if (user == null) {
        user = new AppUser();
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>
            <%= edit ? "Edit User" : "Add User"%> - SmartWaste
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

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
            }

            input,
            select {
                width: 100%;
                box-sizing: border-box;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            input:disabled {
                background: #eee;
            }

            .error {
                background: #fee2e2;
                color: #991b1b;
                padding: 12px;
                border-radius: 5px;
                margin-bottom: 20px;
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

            <h2>
                <%= edit ? "Edit User" : "Add User"%>
            </h2>

            <%
                if (error != null && !error.trim().isEmpty()) {
            %>

            <div class="error">
                <%= error%>
            </div>

            <%
                }
            %>

            <form action="<%=request.getContextPath()%>/user/save"
                  method="POST">

                <%
                    if (edit) {
                %>

                <input type="hidden"
                       name="oldId"
                       value="<%=user.getUserId()%>">

                <%
                    }
                %>


                <!-- USER ID -->

                <div class="form-group">

                    <label>User ID</label>

                    <input type="text"
                           name="userId"
                           value="<%=user.getUserId() != null
                                   ? user.getUserId()
                                   : ""%>"
                           <%=edit ? "readonly" : ""%>
                           required>

                </div>


                <!-- FULL NAME -->

                <div class="form-group">

                    <label>Full Name</label>

                    <input type="text"
                           name="fullName"
                           value="<%=user.getFullName() != null
                                   ? user.getFullName()
                                   : ""%>"
                           required>

                </div>


                <!-- EMAIL -->

                <div class="form-group">

                    <label>Email</label>

                    <input type="email"
                           name="email"
                           value="<%=user.getEmail() != null
                                   ? user.getEmail()
                                   : ""%>"
                           required>

                </div>


                <!-- PHONE -->

                <div class="form-group">

                    <label>Phone Number</label>

                    <input type="text"
                           name="phoneNumber"
                           value="<%=user.getPhoneNumber() != null
                                   ? user.getPhoneNumber()
                                   : ""%>"
                           required>

                </div>


                <!-- ROLE -->

                <div class="form-group">

                    <label>Role</label>

                    <select name="roleId" required>

                        <option value="">-- Select Role --</option>

                        <option value="ADM"
                                <%= "ADM".equals(user.getRoleId())
                            ? "selected" : ""%>>
                            Administrator
                        </option>

                        <option value="MGR"
                                <%= "MGR".equals(user.getRoleId())
                            ? "selected" : ""%>>
                            Manager
                        </option>

                        <option value="STF"
                                <%= "STF".equals(user.getRoleId())
                            ? "selected" : ""%>>
                            Staff
                        </option>

                        <option value="TEC"
                                <%= "TEC".equals(user.getRoleId())
                            ? "selected" : ""%>>
                            Technician
                        </option>

                    </select>

                </div>


                <!-- PASSWORD -->

                <%
                    if (!edit) {
                %>

                <div class="form-group">

                    <label>Default Password</label>

                    <input type="text"
                           value="123456"
                           disabled>

                    <small>
                        New accounts use the default password 123456.
                    </small>

                </div>

                <%
                    }
                %>


                <!-- BUTTONS -->

                <div class="buttons">

                    <button type="submit"
                            class="btn btn-primary">
                        <%= edit ? "Update User" : "Create User"%>
                    </button>

                    <a href="<%=request.getContextPath()%>/user"
                       class="btn btn-secondary">
                        Cancel
                    </a>

                </div>

            </form>

        </div>

    </body>
</html>