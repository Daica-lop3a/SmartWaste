<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Area"%>
<%@page import="model.AppUser"%>

<%
    List<Area> list
            = (List<Area>) request.getAttribute("LIST_AREA");

    String error
            = (String) request.getAttribute("ERROR");

    String search
            = (String) request.getAttribute("SEARCH");

    String sort
            = (String) request.getAttribute("SORT");

    String order
            = (String) request.getAttribute("ORDER");

    if (search == null) {
        search = "";
    }

    if (sort == null || sort.isEmpty()) {
        sort = "areaId";
    }

    if (order == null || order.isEmpty()) {
        order = "ASC";
    }

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
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Area Management</title>

        <link rel="stylesheet"
              href="<%=request.getContextPath()%>/css/style.css">

        <link rel="stylesheet"
              href="<%=request.getContextPath()%>/css/wastebin.css">

    </head>


    <body>

        <div class="app-shell">


            <!-- Thanh menu -->

            <aside class="sidebar">

                <div class="brand">

                    <div class="brand-icon">
                        ♻
                    </div>

                    <div class="brand-text">
                        <strong>Smart</strong><b>Waste</b>
                    </div>

                </div>


                <nav class="side-nav">

                    <a href="<%=request.getContextPath()%>/dashboard"
                       class="nav-item">

                        <span class="nav-icon">⌂</span>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <a href="<%=request.getContextPath()%>/area"
                       class="nav-item active">

                        <span class="nav-icon">⌖</span>

                        <span>
                            Area
                        </span>

                    </a>


                    <a href="<%=request.getContextPath()%>/wastebin"
                       class="nav-item">

                        <span class="nav-icon">▣</span>

                        <span>
                            Waste Bin
                        </span>

                    </a>


                    <a href="<%=request.getContextPath()%>/collection"
                       class="nav-item">

                        <span class="nav-icon">↻</span>

                        <span>
                            Collection
                        </span>

                    </a>


                    <a href="<%=request.getContextPath()%>/maintenance"
                       class="nav-item">

                        <span class="nav-icon">⚙</span>

                        <span>
                            Maintenance
                        </span>

                    </a>


                    <a href="<%=request.getContextPath()%>/alert"
                       class="nav-item">

                        <span class="nav-icon">!</span>

                        <span>
                            Alert
                        </span>

                    </a>

                </nav>


                <div class="sidebar-bottom">

                    <div class="eco-mini-card">

                        <div class="eco-mini-icon">
                            ♻
                        </div>

                        <div>

                            <strong>
                                Smart Waste
                            </strong>

                            <span>
                                Cleaner city, smarter future.
                            </span>

                        </div>

                    </div>


                    <a href="<%=request.getContextPath()%>/logout"
                       class="logout-link">

                        <span>
                            ↪
                        </span>

                        Logout

                    </a>

                </div>

            </aside>


            <!-- Noi dung chinh -->

            <main class="main-content">


                <!-- Thanh dau trang -->

                <header class="topbar">

                    <div>

                        <div class="eyebrow">
                            SMARTWASTE MANAGEMENT
                        </div>

                        <h1>
                            Area Management
                        </h1>

                    </div>


                    <div class="topbar-actions">

                        <div class="profile">

                            <div class="avatar">

                                <%=currentUser != null
                                        && currentUser.getFullName() != null
                                        && !currentUser.getFullName().isEmpty()
                                        ? currentUser.getFullName()
                                                .substring(0, 1)
                                                .toUpperCase()
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


                <!-- Gioi thieu trang -->

                <section class="page-intro">

                    <div>

                        <span class="section-kicker">
                            AREA MANAGEMENT
                        </span>

                        <h2>
                            Manage waste collection areas
                        </h2>

                        <p>
                            View, search and manage areas in the
                            waste management system.
                        </p>

                    </div>


                    <div class="page-actions">

                        <% if (canManage) {%>

                        <a class="btn btn-primary"
                           href="<%=request.getContextPath()%>/area/create">

                            <span>
                                +
                            </span>

                            Add Area

                        </a>

                        <% }%>


                        <a class="btn btn-light"
                           href="<%=request.getContextPath()%>/dashboard">

                            Dashboard

                        </a>

                    </div>

                </section>


                <!-- Loi -->

                <% if (error != null) {%>

                <div class="alert-error">

                    <span class="alert-error-icon">
                        !
                    </span>

                    <span>
                        <%=error%>
                    </span>

                </div>

                <% }%>


                <!-- Bo loc -->

                <section class="panel">

                    <div class="panel-header">

                        <div>

                            <span class="panel-kicker">
                                FILTER & SORT
                            </span>

                            <h3>
                                Area Filters
                            </h3>

                        </div>

                    </div>


                    <form method="GET"
                          action="<%=request.getContextPath()%>/area">

                        <div style="
                             display:flex;
                             align-items:flex-end;
                             gap:12px;
                             flex-wrap:wrap;
                             margin-top:18px;
                             ">


                            <div style="
                                 display:flex;
                                 flex-direction:column;
                                 gap:6px;
                                 ">

                                <label for="search"
                                       style="
                                       font-size:11px;
                                       font-weight:700;
                                       color:var(--muted);
                                       ">

                                    Search

                                </label>


                                <input type="text"
                                       id="search"
                                       name="search"
                                       value="<%=search%>"
                                       placeholder="Area ID / Area Name"
                                       style="
                                       min-height:42px;
                                       min-width:230px;
                                       padding:0 13px;
                                       border:1px solid var(--border);
                                       border-radius:11px;
                                       outline:none;
                                       background:var(--white);
                                       color:var(--text);
                                       font-size:12px;
                                       ">

                            </div>


                            <div style="
                                 display:flex;
                                 flex-direction:column;
                                 gap:6px;
                                 ">

                                <label for="sort"
                                       style="
                                       font-size:11px;
                                       font-weight:700;
                                       color:var(--muted);
                                       ">

                                    Sort by

                                </label>


                                <select id="sort"
                                        name="sort"
                                        style="
                                        min-height:42px;
                                        min-width:160px;
                                        padding:0 13px;
                                        border:1px solid var(--border);
                                        border-radius:11px;
                                        background:var(--white);
                                        color:var(--text);
                                        font-size:12px;
                                        ">

                                    <option value="areaId"
                                            <%= "areaId".equals(sort)
                                                    ? "selected"
                                                    : ""%>>

                                        Area ID

                                    </option>


                                    <option value="areaName"
                                            <%= "areaName".equals(sort)
                                                    ? "selected"
                                                    : ""%>>

                                        Area Name

                                    </option>

                                </select>

                            </div>


                            <div style="
                                 display:flex;
                                 flex-direction:column;
                                 gap:6px;
                                 ">

                                <label for="order"
                                       style="
                                       font-size:11px;
                                       font-weight:700;
                                       color:var(--muted);
                                       ">

                                    Order

                                </label>


                                <select id="order"
                                        name="order"
                                        style="
                                        min-height:42px;
                                        min-width:130px;
                                        padding:0 13px;
                                        border:1px solid var(--border);
                                        border-radius:11px;
                                        background:var(--white);
                                        color:var(--text);
                                        font-size:12px;
                                        ">

                                    <option value="ASC"
                                            <%= "ASC".equals(order)
                                                    ? "selected"
                                                    : ""%>>

                                        ASC

                                    </option>


                                    <option value="DESC"
                                            <%= "DESC".equals(order)
                                                    ? "selected"
                                                    : ""%>>

                                        DESC

                                    </option>

                                </select>

                            </div>


                            <div style="
                                 display:flex;
                                 gap:8px;
                                 ">

                                <button type="submit"
                                        class="btn btn-primary">

                                    Apply Filter

                                </button>


                                <a href="<%=request.getContextPath()%>/area"
                                   class="btn btn-light">

                                    Reset

                                </a>

                            </div>

                        </div>

                    </form>

                </section>


                <!-- Danh sach Area -->

                <section class="panel"
                         style="margin-top:20px;">

                    <div class="panel-header">

                        <div>

                            <span class="panel-kicker">
                                AREA INVENTORY
                            </span>

                            <h3>
                                Area List
                            </h3>

                        </div>


                        <span class="record-count">

                            <%=list != null ? list.size() : 0%>
                            records

                        </span>

                    </div>


                    <div class="table-wrapper"
                         style="margin-top:18px;">

                        <table class="data-table">

                            <thead>

                                <tr>

                                    <th>
                                        Area ID
                                    </th>

                                    <th>
                                        Area Name
                                    </th>

                                    <th>
                                        Description
                                    </th>

                                    <th>
                                        Action
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                                <%
                                    if (list != null && !list.isEmpty()) {

                                        for (Area area : list) {
                                %>

                                <tr>


                                    <td>

                                        <span class="bin-id">

                                            #<%=area.getAreaId()%>

                                        </span>

                                    </td>


                                    <td>

                                        <span class="bin-code">

                                            <%=area.getAreaName()%>

                                        </span>

                                    </td>


                                    <td>

                                        <span style="
                                              color:var(--muted);
                                              font-size:13px;
                                              ">

                                            <%=area.getDescription() != null
                                                    ? area.getDescription()
                                                    : ""%>

                                        </span>

                                    </td>


                                    <td>

                                        <div class="action-group">


                                            <a href="<%=request.getContextPath()%>/area/view?id=<%=area.getAreaId()%>"
                                               class="action-btn action-view">

                                                View

                                            </a>


                                            <% if (canManage) {%>


                                            <a href="<%=request.getContextPath()%>/area/edit?id=<%=area.getAreaId()%>"
                                               class="action-btn action-edit">

                                                Edit

                                            </a>


                                            <form action="<%=request.getContextPath()%>/area/delete"
                                                  method="POST"
                                                  onsubmit="return confirm('Are you sure you want to delete this area?');">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<%=area.getAreaId()%>">


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

                                    <td colspan="4">

                                        <div class="empty-state">

                                            <div class="empty-icon">
                                                ⌖
                                            </div>


                                            <strong>
                                                No areas found
                                            </strong>


                                            <span>
                                                There are currently no areas
                                                available in the system.
                                            </span>

                                        </div>

                                    </td>

                                </tr>


                                <%                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </section>


                <!-- Chan trang -->

                <footer class="footer">

                    <span>
                        SmartWaste Management System
                    </span>

                    <span>
                        Area Management
                    </span>

                </footer>


            </main>

        </div>

    </body>

</html>