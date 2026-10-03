<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.WasteBin"%>
<%@page import="model.AppUser"%>

<%
    List<WasteBin> list
            = (List<WasteBin>) request.getAttribute("LIST_BIN");

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
            || "MGR".equals(role)
            || "TEC".equals(role);
%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Waste Bin Management</title>

        <!-- CSS chung -->
        <link rel="stylesheet"
              href="<%=request.getContextPath()%>/css/style.css">

        <!-- CSS rieng cho Waste Bin -->
        <link rel="stylesheet"
              href="<%=request.getContextPath()%>/css/wastebin.css">

    </head>

    <body>

        <div class="app-shell">

            <!-- Sidebar -->
            <aside class="sidebar">

                <div class="brand">

                    <div class="brand-mark">
                        SW
                    </div>

                    <div>
                        <strong>SmartWaste</strong>
                        <span>Management System</span>
                    </div>

                </div>

                <nav class="sidebar-nav">

                    <a href="<%=request.getContextPath()%>/dashboard"
                       class="nav-item">

                        <span class="nav-icon">⌂</span>
                        <span>Dashboard</span>

                    </a>

                    <a href="<%=request.getContextPath()%>/area"
                       class="nav-item">

                        <span class="nav-icon">⌖</span>
                        <span>Area</span>

                    </a>

                    <a href="<%=request.getContextPath()%>/wastebin"
                       class="nav-item active">

                        <span class="nav-icon">▣</span>
                        <span>Waste Bin</span>

                    </a>

                    <a href="<%=request.getContextPath()%>/collection"
                       class="nav-item">

                        <span class="nav-icon">↻</span>
                        <span>Collection</span>

                    </a>

                    <a href="<%=request.getContextPath()%>/maintenance"
                       class="nav-item">

                        <span class="nav-icon">⚙</span>
                        <span>Maintenance</span>

                    </a>

                    <a href="<%=request.getContextPath()%>/alert"
                       class="nav-item">

                        <span class="nav-icon">!</span>
                        <span>Alert</span>

                    </a>

                </nav>

                <div class="sidebar-bottom">

                    <div class="eco-mini-card">

                        <div class="eco-mini-icon">
                            ♻
                        </div>

                        <div>
                            <strong>Smart Waste</strong>
                            <span>Cleaner city, smarter future.</span>
                        </div>

                    </div>

                    <a href="<%=request.getContextPath()%>/logout"
                       class="logout-link">

                        <span>↪</span>
                        Logout

                    </a>

                </div>

            </aside>


            <!-- Main content -->
            <main class="main-content">

                <!-- Topbar -->
                <header class="topbar">

                    <div>

                        <div class="eyebrow">
                            SMARTWASTE MANAGEMENT
                        </div>

                        <h1>Waste Bin Management</h1>

                    </div>

                    <div class="topbar-actions">

                        <div class="profile">

                            <div class="avatar">
                                <%=currentUser != null
                                        && currentUser.getFullName() != null
                                        && !currentUser.getFullName().isEmpty()
                                        ? currentUser.getFullName().substring(0, 1).toUpperCase()
                                        : "U"%>
                            </div>

                            <div class="profile-info">

                                <strong>
                                    <%=currentUser != null
                                            ? currentUser.getFullName()
                                            : ""%>
                                </strong>

                                <span>
                                    <%=role%>
                                </span>

                            </div>

                        </div>

                    </div>

                </header>


                <!-- Page intro -->
                <section class="page-intro">

                    <div>

                        <span class="section-kicker">
                            WASTE BIN MONITORING
                        </span>

                        <h2>
                            Monitor and manage waste bins
                        </h2>

                        <p>
                            Track bin capacity, location, status and current
                            fill level across the waste management system.
                        </p>

                    </div>

                    <div class="page-actions">

                        <% if (canManage) {%>

                        <a class="btn btn-primary"
                           href="<%=request.getContextPath()%>/wastebin/create">

                            <span>+</span>
                            Add Waste Bin

                        </a>

                        <% }%>

                        <a class="btn btn-light"
                           href="<%=request.getContextPath()%>/dashboard">

                            Dashboard

                        </a>

                    </div>

                </section>


                <!-- Error -->
                <% if (error != null) {%>

                <div class="alert-error">

                    <span class="alert-error-icon">!</span>

                    <span>
                        <%=error%>
                    </span>

                </div>

                <% }%>


                <!-- Summary -->
                <section class="bin-summary">

                    <div class="summary-card">

                        <div class="summary-icon summary-icon-total">
                            ▣
                        </div>

                        <div>

                            <span>Total Bins</span>

                            <strong>
                                <%=list != null ? list.size() : 0%>
                            </strong>

                        </div>

                    </div>


                    <div class="summary-card">

                        <div class="summary-icon summary-icon-active">
                            ✓
                        </div>

                        <div>

                            <span>Active</span>

                            <strong>
                                <%
                                    int activeCount = 0;

                                    if (list != null) {
                                        for (WasteBin bin : list) {
                                            if ("ACTIVE".equalsIgnoreCase(bin.getStatus())) {
                                                activeCount++;
                                            }
                                        }
                                    }
                                %>

                                <%=activeCount%>
                            </strong>

                        </div>

                    </div>


                    <div class="summary-card">

                        <div class="summary-icon summary-icon-warning">
                            !
                        </div>

                        <div>

                            <span>High Fill</span>

                            <strong>
                                <%
                                    int highFillCount = 0;

                                    if (list != null) {
                                        for (WasteBin bin : list) {
                                            if (bin.getCurrentFill() >= 80) {
                                                highFillCount++;
                                            }
                                        }
                                    }
                                %>

                                <%=highFillCount%>
                            </strong>

                        </div>

                    </div>

                </section>


                <!-- Waste Bin table -->
                <section class="panel bin-panel">

                    <div class="panel-header">

                        <div>

                            <span class="panel-kicker">
                                BIN INVENTORY
                            </span>

                            <h3>
                                Waste Bin List
                            </h3>

                        </div>

                        <span class="record-count">

                            <%=list != null ? list.size() : 0%>
                            records

                        </span>

                    </div>


                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>

                                <tr>

                                    <th>Bin ID</th>

                                    <th>Bin Code</th>

                                    <th>Location</th>

                                    <th>Capacity</th>

                                    <th>Current Fill</th>

                                    <th>Status</th>

                                    <th>Area</th>

                                    <th>Action</th>

                                </tr>

                            </thead>


                            <tbody>

                                <%
                                    if (list != null && !list.isEmpty()) {

                                        for (WasteBin bin : list) {

                                            double fill = bin.getCurrentFill();

                                            String fillClass = "fill-green";

                                            String fillLabel = "Normal";

                                            if (fill >= 80) {

                                                fillClass = "fill-red";
                                                fillLabel = "High";

                                            } else if (fill >= 50) {

                                                fillClass = "fill-yellow";
                                                fillLabel = "Medium";
                                            }
                                %>

                                <tr>

                                    <td>
                                        <span class="bin-id">
                                            #<%=bin.getBinID()%>
                                        </span>
                                    </td>


                                    <td>

                                        <span class="bin-code">
                                            <%=bin.getBinCode()%>
                                        </span>

                                    </td>


                                    <td>

                                        <div class="location-cell">

                                            <span class="location-icon">
                                                ⌖
                                            </span>

                                            <span>
                                                <%=bin.getLocation()%>
                                            </span>

                                        </div>

                                    </td>


                                    <td>

                                        <span class="capacity-value">
                                            <%=bin.getCapacity()%>
                                        </span>

                                    </td>


                                    <td>

                                        <div class="fill-cell">

                                            <div class="fill-info">

                                                <strong class="<%=fillClass%>">
                                                    <%=fill%>%
                                                </strong>

                                                <span class="<%=fillClass%>">
                                                    <%=fillLabel%>
                                                </span>

                                            </div>

                                            <div class="fill-bar">

                                                <div class="fill-progress <%=fillClass%>"
                                                     style="width: <%=Math.min(fill, 100)%>%;">

                                                </div>

                                            </div>

                                        </div>

                                    </td>


                                    <td>

                                        <span class="status-badge">

                                            <span class="status-dot"></span>

                                            <%=bin.getStatus()%>

                                        </span>

                                    </td>


                                    <td>

                                        <span class="area-badge">
                                            Area <%=bin.getAreaID()%>
                                        </span>

                                    </td>


                                    <td>

                                        <div class="action-group">

                                            <a class="action-btn action-view"
                                               href="<%=request.getContextPath()%>/wastebin/view?id=<%=bin.getBinID()%>">

                                                View

                                            </a>


                                            <% if (canManage) {%>

                                            <a class="action-btn action-edit"
                                               href="<%=request.getContextPath()%>/wastebin/edit?id=<%=bin.getBinID()%>">

                                                Edit

                                            </a>


                                            <form action="<%=request.getContextPath()%>/wastebin/delete"
                                                  method="POST"
                                                  onsubmit="return confirm('Are you sure you want to delete this waste bin?');">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<%=bin.getBinID()%>">

                                                <button type="submit"
                                                        class="action-btn action-delete">

                                                    Delete

                                                </button>

                                            </form>

                                            <% } %>

                                        </div>

                                    </td>

                                </tr>

                                <%
                                    }

                                } else {
                                %>

                                <tr>

                                    <td colspan="8">

                                        <div class="empty-state">

                                            <div class="empty-icon">
                                                ▣
                                            </div>

                                            <strong>
                                                No waste bins found
                                            </strong>

                                            <span>
                                                There are currently no waste
                                                bins available in the system.
                                            </span>

                                        </div>

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </section>


                <footer class="footer">

                    <span>
                        SmartWaste Management System
                    </span>

                    <span>
                        Waste Bin Monitoring
                    </span>

                </footer>

            </main>

        </div>

    </body>

</html>