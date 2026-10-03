<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();

    Object userObj = session.getAttribute("user");
    String displayName = "Administrator";

    if (userObj != null) {
        try {
            Object name = userObj.getClass().getMethod("getFullName").invoke(userObj);
            if (name != null && !name.toString().trim().isEmpty()) {
                displayName = name.toString();
            }
        } catch (Exception ignored) {
            // Giu ten mac dinh khi AppUser khong co getFullName()
        }
    }

    Object totalBinsObj = request.getAttribute("totalBins");
    Object totalRequestsObj = request.getAttribute("totalRequests");
    Object totalAlertsObj = request.getAttribute("totalAlerts");
    Object totalMaintenanceObj = request.getAttribute("totalMaintenance");

    String totalBins = totalBinsObj != null ? totalBinsObj.toString() : "0";
    String totalRequests = totalRequestsObj != null ? totalRequestsObj.toString() : "0";
    String totalAlerts = totalAlertsObj != null ? totalAlertsObj.toString() : "0";
    String totalMaintenance = totalMaintenanceObj != null ? totalMaintenanceObj.toString() : "0";

    int activeBins = request.getAttribute("activeBins") != null ? (Integer) request.getAttribute("activeBins") : 0;
    int fullBins = request.getAttribute("fullBins") != null ? (Integer) request.getAttribute("fullBins") : 0;
    int maintenanceBins = request.getAttribute("maintenanceBins") != null ? (Integer) request.getAttribute("maintenanceBins") : 0;
    int pendingRequests = request.getAttribute("pendingRequests") != null ? (Integer) request.getAttribute("pendingRequests") : 0;
    int inProgressRequests = request.getAttribute("inProgressRequests") != null ? (Integer) request.getAttribute("inProgressRequests") : 0;
    int completedRequests = request.getAttribute("completedRequests") != null ? (Integer) request.getAttribute("completedRequests") : 0;
    int unresolvedAlerts = request.getAttribute("unresolvedAlerts") != null ? (Integer) request.getAttribute("unresolvedAlerts") : 0;
    int pendingMaintenance = request.getAttribute("pendingMaintenance") != null ? (Integer) request.getAttribute("pendingMaintenance") : 0;
%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>SmartWaste - Dashboard</title>

        <!-- CSS chung -->
        <link rel="stylesheet" href="<%= ctx%>/css/style.css">

        <!-- CSS rieng cho Dashboard -->
        <link rel="stylesheet" href="<%= ctx%>/css/dashboard.css">
    </head>

    <body>

        <div class="app-shell">

            <!-- SIDEBAR -->
            <aside class="sidebar">

                <a href="<%= ctx%>/dashboard" class="brand">
                    <span class="brand-icon">♻</span>

                    <span class="brand-text">
                        <strong>Smart</strong><b>Waste</b>
                    </span>
                </a>

                <div class="sidebar-section-title">
                    MAIN MENU
                </div>

                <nav class="side-nav">

                    <a class="nav-item active"
                       href="<%= ctx%>/dashboard">

                        <span class="nav-icon">⌂</span>
                        <span>Dashboard</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/area">

                        <span class="nav-icon">⌖</span>
                        <span>Areas</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/wastebin">

                        <span class="nav-icon">▣</span>
                        <span>Waste Bins</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/collection">

                        <span class="nav-icon">↻</span>
                        <span>Collection Requests</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/alert">

                        <span class="nav-icon">!</span>
                        <span>Alerts</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/maintenance">

                        <span class="nav-icon">⚙</span>
                        <span>Maintenance</span>

                    </a>

                    <div class="sidebar-section-title">
                        MANAGEMENT
                    </div>

                    <a class="nav-item"
                       href="<%= ctx%>/user">

                        <span class="nav-icon">♙</span>
                        <span>Users</span>

                    </a>

                    <a class="nav-item"
                       href="<%= ctx%>/report">

                        <span class="nav-icon">▤</span>
                        <span>Reports</span>

                    </a>

                </nav>

                <div class="sidebar-bottom">

                    <div class="eco-mini-card">

                        <div class="eco-mini-icon">
                            🌱
                        </div>

                        <div>
                            <strong>Cleaner city</strong>
                            <span>Smarter waste operations</span>
                        </div>

                    </div>

                    <a class="logout-link"
                       href="<%= ctx%>/logout">

                        <span>↪</span>
                        Logout

                    </a>

                </div>

            </aside>


            <!-- MAIN CONTENT -->
            <main class="main-content">

                <!-- TOP BAR -->
                <header class="topbar">

                    <div>

                        <span class="eyebrow">
                            SMART WASTE MANAGEMENT
                        </span>

                        <h1>
                            Dashboard
                        </h1>

                    </div>

                    <div class="topbar-actions">

                        <button class="icon-button"
                                type="button"
                                aria-label="Notifications">

                            ♢

                            <% if (unresolvedAlerts > 0) { %>

                            <span class="notification-dot"></span>

                            <% }%>

                        </button>

                        <div class="profile">

                            <div class="avatar">
                                <%= displayName.substring(0, 1).toUpperCase()%>
                            </div>

                            <div class="profile-info">

                                <strong>
                                    <%= displayName%>
                                </strong>

                                <span>
                                    System User
                                </span>

                            </div>

                        </div>

                    </div>

                </header>


                <!-- HERO -->
                <section class="hero">

                    <div class="hero-copy">

                        <span class="hero-pill">
                            ♻ Smart • Clean • Connected
                        </span>

                        <h2>
                            Smarter waste.<br>
                            <span>Cleaner city.</span>
                        </h2>

                        <p>
                            Manage waste bins, collection activities and alerts
                            from one centralized platform.
                        </p>

                        <div class="hero-actions">

                            <a href="<%= ctx%>/wastebin"
                               class="btn btn-primary">

                                View Waste Bins
                                <span>→</span>

                            </a>

                            <a href="<%= ctx%>/collection/create"
                               class="btn btn-light">

                                New Collection

                            </a>

                        </div>

                    </div>


                    <!-- HERO VISUAL -->
                    <div class="hero-visual">

                        <div class="orbit orbit-one"></div>
                        <div class="orbit orbit-two"></div>

                        <div class="city-shape">

                            <span class="building b1"></span>
                            <span class="building b2"></span>
                            <span class="building b3"></span>
                            <span class="building b4"></span>

                            <span class="tree t1">♣</span>
                            <span class="tree t2">♣</span>

                            <span class="smart-bin">
                                ♻
                            </span>

                        </div>


                        <!-- FLOATING MONITOR CARD -->
                        <div class="floating-card">

                            <div class="floating-card-head">

                                <strong>
                                    Smart Monitoring
                                </strong>

                                <span class="status-live">
                                    LIVE
                                </span>

                            </div>


                            <div class="monitor-row">

                                <span class="monitor-icon">
                                    ▣
                                </span>

                                <div>

                                    <strong>
                                        Waste Bins
                                    </strong>

                                    <small>
                                        Connected management
                                    </small>

                                </div>

                                <b>
                                    <%= totalBins%>
                                </b>

                            </div>


                            <div class="monitor-line"></div>


                            <div class="monitor-row">

                                <span class="monitor-icon">
                                    ↻
                                </span>

                                <div>

                                    <strong>
                                        Collections
                                    </strong>

                                    <small>
                                        Collection requests
                                    </small>

                                </div>

                                <b>
                                    <%= totalRequests%>
                                </b>

                            </div>

                        </div>

                    </div>

                </section>


                <!-- STATISTICS -->
                <section class="stats-grid">

                    <article class="stat-card">

                        <div class="stat-icon green">
                            ▣
                        </div>

                        <div class="stat-content">

                            <span>
                                Total Waste Bins
                            </span>

                            <strong>
                                <%= totalBins%>
                            </strong>

                            <small>
                                Registered in system
                            </small>

                        </div>

                    </article>


                    <article class="stat-card">

                        <div class="stat-icon blue">
                            ↻
                        </div>

                        <div class="stat-content">

                            <span>
                                Collection Requests
                            </span>

                            <strong>
                                <%= totalRequests%>
                            </strong>

                            <small>
                                Collection requests
                            </small>

                        </div>

                    </article>


                    <article class="stat-card">

                        <div class="stat-icon orange">
                            !
                        </div>

                        <div class="stat-content">

                            <span>
                                Active Alerts
                            </span>

                            <strong>
                                <%= totalAlerts%>
                            </strong>

                            <small>
                                Require attention
                            </small>

                        </div>

                    </article>


                    <article class="stat-card">

                        <div class="stat-icon purple">
                            ⌖
                        </div>

                        <div class="stat-content">

                            <span>
                                Maintenance
                            </span>

                            <strong>
                                <%= totalMaintenance%>
                            </strong>

                            <small>
                                Maintenance records
                            </small>

                        </div>

                    </article>

                </section>


                <!-- CONTENT GRID -->
                <section class="content-grid">

                    <!-- MAP -->
                    <article class="panel map-panel">

                        <div class="panel-header">

                            <div>

                                <span class="panel-kicker">
                                    LOCATION OVERVIEW
                                </span>

                                <h3>
                                    Smart City Map
                                </h3>

                            </div>

                            <a href="<%= ctx%>/area"
                               class="text-link">

                                View areas →

                            </a>

                        </div>


                        <div class="fake-map">

                            <div class="map-road road-1"></div>
                            <div class="map-road road-2"></div>
                            <div class="map-road road-3"></div>
                            <div class="map-road road-4"></div>

                            <div class="map-block block-1"></div>
                            <div class="map-block block-2"></div>
                            <div class="map-block block-3"></div>
                            <div class="map-block block-4"></div>

                            <span class="map-pin pin-1">
                                ♻
                            </span>

                            <span class="map-pin pin-2">
                                ♻
                            </span>

                            <span class="map-pin pin-3">
                                ♻
                            </span>

                            <span class="map-pin pin-4">
                                ♻
                            </span>


                            <div class="map-label">

                                <strong>
                                    Waste management areas
                                </strong>

                                <span>
                                    Interactive map can be connected here.
                                </span>

                            </div>

                        </div>

                    </article>


                    <!-- BIN OVERVIEW -->
                    <article class="panel overview-panel">

                        <div class="panel-header">

                            <div>

                                <span class="panel-kicker">
                                    STATUS
                                </span>

                                <h3>
                                    Bin Overview
                                </h3>

                            </div>

                            <a href="<%= ctx%>/wastebin"
                               class="text-link">

                                View all →

                            </a>

                        </div>


                        <div class="overview-body">

                            <div class="status-ring">

                                <div class="ring-inner">

                                    <strong>
                                        <%= totalBins%>
                                    </strong>

                                    <span>
                                        total bins
                                    </span>

                                </div>

                            </div>


                            <div class="status-list">

                                <div class="status-item">

                                    <span class="status-dot normal"></span>

                                    <div>

                                        <strong>
                                            Active
                                        </strong>

                                        <small>
                                            Operating normally
                                        </small>

                                    </div>

                                    <b>
                                        <%= activeBins%>
                                    </b>

                                </div>


                                <div class="status-item">

                                    <span class="status-dot warning"></span>

                                    <div>

                                        <strong>
                                            Full
                                        </strong>

                                        <small>
                                            Collection may be required
                                        </small>

                                    </div>

                                    <b>
                                        <%= fullBins%>
                                    </b>

                                </div>


                                <div class="status-item">

                                    <span class="status-dot critical"></span>

                                    <div>

                                        <strong>
                                            Maintenance
                                        </strong>

                                        <small>
                                            Requires maintenance
                                        </small>

                                    </div>

                                    <b>
                                        <%= maintenanceBins%>
                                    </b>

                                </div>

                            </div>

                        </div>

                    </article>

                </section>


                <!-- BOTTOM GRID -->
                <section class="bottom-grid">

                    <!-- RECENT COLLECTION -->
                    <article class="panel collection-panel">

                        <div class="panel-header">

                            <div>

                                <span class="panel-kicker">
                                    OPERATIONS
                                </span>

                                <h3>
                                    Recent Collections
                                </h3>

                            </div>

                            <a href="<%= ctx%>/collection"
                               class="text-link">

                                View all →

                            </a>

                        </div>


                        <div class="status-list">

                            <div class="status-item">

                                <span class="status-dot warning"></span>

                                <div>

                                    <strong>
                                        Pending
                                    </strong>

                                    <small>
                                        Waiting for collection
                                    </small>

                                </div>

                                <b>
                                    <%= pendingRequests%>
                                </b>

                            </div>


                            <div class="status-item">

                                <span class="status-dot normal"></span>

                                <div>

                                    <strong>
                                        In Progress
                                    </strong>

                                    <small>
                                        Currently being handled
                                    </small>

                                </div>

                                <b>
                                    <%= inProgressRequests%>
                                </b>

                            </div>


                            <div class="status-item">

                                <span class="status-dot normal"></span>

                                <div>

                                    <strong>
                                        Completed
                                    </strong>

                                    <small>
                                        Finished requests
                                    </small>

                                </div>

                                <b>
                                    <%= completedRequests%>
                                </b>

                            </div>

                        </div>

                    </article>


                    <!-- QUICK ACTIONS -->
                    <article class="panel quick-panel">

                        <div class="panel-header">

                            <div>

                                <span class="panel-kicker">
                                    SHORTCUTS
                                </span>

                                <h3>
                                    Quick Actions
                                </h3>

                            </div>

                        </div>


                        <div class="quick-actions">

                            <a href="<%= ctx%>/collection/create"
                               class="quick-action">

                                <span class="quick-icon green-bg">
                                    ↻
                                </span>

                                <span>

                                    <strong>
                                        New Collection
                                    </strong>

                                    <small>
                                        Create a collection request
                                    </small>

                                </span>

                                <b>
                                    →
                                </b>

                            </a>


                            <a href="<%= ctx%>/wastebin/create"
                               class="quick-action">

                                <span class="quick-icon blue-bg">
                                    ▣
                                </span>

                                <span>

                                    <strong>
                                        Add Waste Bin
                                    </strong>

                                    <small>
                                        Register a new bin
                                    </small>

                                </span>

                                <b>
                                    →
                                </b>

                            </a>


                            <a href="<%= ctx%>/alert"
                               class="quick-action">

                                <span class="quick-icon orange-bg">
                                    ⌖
                                </span>

                                <span>

                                    <strong>
                                        View Alerts
                                    </strong>

                                    <small>
                                        <%= unresolvedAlerts%> unresolved alerts
                                    </small>

                                </span>

                                <b>
                                    →
                                </b>

                            </a>

                        </div>

                    </article>

                </section>


                <!-- FOOTER -->
                <footer class="footer">

                    <span>
                        © SmartWaste Management System
                    </span>

                    <span>
                        Smarter waste • Cleaner city
                    </span>

                </footer>

            </main>

        </div>

    </body>

</html>