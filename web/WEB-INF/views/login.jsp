<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>SmartWaste Login</title>

        <link rel="stylesheet"
              href="<%= request.getContextPath()%>/css/login.css">

    </head>

    <body>

        <div class="login-page">

            <!-- LEFT -->
            <div class="login-intro">

                <div class="brand">

                    <div class="brand-icon">
                        ♻
                    </div>

                    <div>
                        <div class="brand-name">
                            SmartWaste
                        </div>

                        <div class="brand-subtitle">
                            Smart Waste Management
                        </div>
                    </div>

                </div>


                <div class="intro-content">

                    <div class="eyebrow">
                        SMART WASTE MANAGEMENT
                    </div>

                    <h1>
                        Smarter Waste.<br>
                        Cleaner City.
                    </h1>

                    <p>
                        A centralized system for monitoring
                        waste bins, managing collection requests,
                        alerts and maintenance activities.
                    </p>


                    <div class="intro-features">

                        <div class="intro-feature">
                            <span class="feature-icon">✓</span>
                            <span>Real-time waste bin monitoring</span>
                        </div>

                        <div class="intro-feature">
                            <span class="feature-icon">✓</span>
                            <span>Smart collection management</span>
                        </div>

                        <div class="intro-feature">
                            <span class="feature-icon">✓</span>
                            <span>Centralized system management</span>
                        </div>

                    </div>

                </div>


                <div class="intro-footer">
                    SmartWaste Management System
                </div>

            </div>


            <!-- RIGHT -->
            <div class="login-side">

                <div class="login-card">

                    <div class="mobile-logo">

                        <div class="brand-icon">
                            ♻
                        </div>

                        <span>
                            SmartWaste
                        </span>

                    </div>


                    <div class="login-header">

                        <h2>
                            Welcome back
                        </h2>

                        <p>
                            Sign in to access your dashboard.
                        </p>

                    </div>


                    <%
                        String error
                                = (String) request.getAttribute("ERROR");

                        if (error != null
                                && !error.trim().isEmpty()) {
                    %>

                    <div class="error-message">

                        <span>!</span>

                        <%= error%>

                    </div>

                    <%
                        }
                    %>


                    <form
                        action="<%= request.getContextPath()%>/login"
                        method="POST"
                        class="login-form">


                        <!-- USERNAME -->

                        <div class="form-group">

                            <label for="username">
                                Username
                            </label>

                            <div class="input-wrapper">

                                <span class="input-icon">
                                    👤
                                </span>

                                <input
                                    type="text"
                                    id="username"
                                    name="username"
                                    placeholder="Enter your username"
                                    autocomplete="username"
                                    required>

                            </div>

                        </div>


                        <!-- PASSWORD -->

                        <div class="form-group">

                            <label for="password">
                                Password
                            </label>

                            <div class="input-wrapper">

                                <span class="input-icon">
                                    🔒
                                </span>

                                <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    placeholder="Enter your password"
                                    autocomplete="current-password"
                                    required>

                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword()">

                                    Show

                                </button>

                            </div>

                        </div>


                        <!-- LOGIN -->

                        <button
                            type="submit"
                            class="login-button">

                            <span>
                                Sign In
                            </span>

                            <span class="arrow">
                                →
                            </span>

                        </button>

                    </form>


                    <div class="login-divider">
                        <span>SmartWaste</span>
                    </div>


                    <p class="login-note">
                        Authorized users only.
                        Please use your assigned account.
                    </p>

                </div>

            </div>

        </div>


        <script>

            function togglePassword() {

                const password =
                        document.getElementById("password");

                const button =
                        document.querySelector(".password-toggle");


                if (password.type === "password") {

                    password.type = "text";
                    button.textContent = "Hide";

                } else {

                    password.type = "password";
                    button.textContent = "Show";

                }

            }

        </script>

    </body>

</html>