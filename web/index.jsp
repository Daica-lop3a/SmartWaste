<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SmartWaste | Smart Waste Management</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/landing.css">
    </head>
    <body>

        <header class="navbar">
            <div class="nav-inner">
                <a class="brand" href="#home">
                    <span class="brand-mark">♻</span>
                    <span>Smart<span class="brand-accent">Waste</span></span>
                </a>

                <nav class="nav-links">
                    <a class="active" href="#home">Home</a>
                    <a href="#about">About</a>
                    <a href="#features">Features</a>
                    <a href="#workflow">How It Works</a>
                </nav>

                <a class="login-btn" href="<%=request.getContextPath()%>/login">Login <span>→</span></a>

                <button class="menu-btn" type="button" onclick="toggleMenu()">☰</button>
            </div>

            <nav class="mobile-nav" id="mobileNav">
                <a href="#home" onclick="closeMenu()">Home</a>
                <a href="#about" onclick="closeMenu()">About</a>
                <a href="#features" onclick="closeMenu()">Features</a>
                <a href="#workflow" onclick="closeMenu()">How It Works</a>
                <a href="<%=request.getContextPath()%>/login">Login</a>
            </nav>
        </header>

        <main>
            <section class="hero" id="home">
                <div class="hero-inner">
                    <div class="hero-content">
                        <div class="eyebrow">SMART WASTE MANAGEMENT</div>

                        <h1>
                            Smarter Waste.<br>
                            <span>Cleaner City.</span>
                        </h1>

                        <p>
                            A centralized waste management system for monitoring bins,
                            managing alerts, organizing collection requests and tracking
                            maintenance activities.
                        </p>

                        <div class="hero-actions">
                            <a class="primary-btn" href="<%=request.getContextPath()%>/login">
                                Get Started <span>→</span>
                            </a>
                            <a class="secondary-btn" href="#features">Explore Features</a>
                        </div>

                        <div class="hero-stats">
                            <div>
                                <strong>Real-time</strong>
                                <span>Bin Monitoring</span>
                            </div>
                            <div>
                                <strong>Smart</strong>
                                <span>Alerts</span>
                            </div>
                            <div>
                                <strong>Centralized</strong>
                                <span>Management</span>
                            </div>
                        </div>
                    </div>

                    <div class="hero-visual">
                        <div class="glow"></div>

                        <div class="bin">
                            <div class="bin-lid"></div>
                            <div class="bin-body">
                                <div class="recycle">♻</div>
                                <div class="bin-text">SMART<br>WASTE</div>
                            </div>
                            <div class="bin-base"></div>
                        </div>

                        <div class="status-card">
                            <div class="status-top">
                                <div>
                                    <small>WASTE BIN</small>
                                    <strong>BIN-Q1-001</strong>
                                </div>
                                <span class="warning">HIGH FILL</span>
                            </div>

                            <div class="status-main">
                                <div class="fill-circle">
                                    <strong>89%</strong>
                                    <small>FULL</small>
                                </div>
                                <div class="status-info">
                                    <p>Area <b>Quận 1</b></p>
                                    <p>Status <b>Needs Collection</b></p>
                                    <p class="live"><i></i> Live monitoring</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section about" id="about">
                <div class="section-heading">
                    <span>ABOUT SMARTWASTE</span>
                    <h2>Smarter Waste Management</h2>
                    <p>
                        SmartWaste connects the main waste-management activities
                        into one simple and centralized platform.
                    </p>
                </div>

                <div class="about-grid">
                    <article class="about-card large">
                        <div class="card-icon">◉</div>
                        <h3>From Monitoring to Action</h3>
                        <p>
                            View current bin conditions, identify high-fill situations,
                            create collection requests and follow them through completion.
                        </p>
                        <div class="mini-flow">
                            <span>Monitor</span><b>→</b>
                            <span>Alert</span><b>→</b>
                            <span>Collect</span><b>→</b>
                            <span>Complete</span>
                        </div>
                    </article>

                    <article class="about-card">
                        <div class="card-icon green">▥</div>
                        <h3>Area Management</h3>
                        <p>
                            Organize bins by area and manage assignments for managers
                            and collection staff.
                        </p>
                    </article>

                    <article class="about-card">
                        <div class="card-icon orange">!</div>
                        <h3>Actionable Alerts</h3>
                        <p>
                            Highlight high-fill conditions so responsible users can
                            review and take the appropriate action.
                        </p>
                    </article>
                </div>
            </section>

            <section class="section features" id="features">
                <div class="section-heading">
                    <span>KEY FEATURES</span>
                    <h2>Everything You Need to Manage Waste</h2>
                    <p>Focused on practical waste-management operations.</p>
                </div>

                <div class="feature-grid">
                    <article class="feature-card">
                        <div class="feature-icon green">▥</div>
                        <h3>Real-time Monitoring</h3>
                        <p>
                            Monitor bin fill levels and current status across different areas.
                        </p>
                    </article>

                    <article class="feature-card">
                        <div class="feature-icon orange">!</div>
                        <h3>Smart Alerts</h3>
                        <p>
                            Review high-fill conditions and respond when collection is required.
                        </p>
                    </article>

                    <article class="feature-card">
                        <div class="feature-icon blue">▣</div>
                        <h3>Collection Management</h3>
                        <p>
                            Create requests, assign staff and track collection status.
                        </p>
                    </article>

                    <article class="feature-card">
                        <div class="feature-icon purple">⚙</div>
                        <h3>Maintenance Tracking</h3>
                        <p>
                            Manage maintenance activities and keep waste-management
                            equipment operational.
                        </p>
                    </article>
                </div>
            </section>

            <section class="section workflow" id="workflow">
                <div class="section-heading">
                    <span>HOW IT WORKS</span>
                    <h2>From Monitoring to Collection</h2>
                    <p>A simple operational flow for the waste-management team.</p>
                </div>

                <div class="workflow-grid">
                    <div class="step">
                        <div class="step-number">01</div>
                        <div class="step-icon">▥</div>
                        <h3>Monitor Bins</h3>
                        <p>Check the current condition of waste bins.</p>
                    </div>

                    <div class="step-arrow">→</div>

                    <div class="step">
                        <div class="step-number">02</div>
                        <div class="step-icon blue">◉</div>
                        <h3>Check Fill Level</h3>
                        <p>Identify bins approaching full capacity.</p>
                    </div>

                    <div class="step-arrow">→</div>

                    <div class="step">
                        <div class="step-number">03</div>
                        <div class="step-icon orange">!</div>
                        <h3>Review Alert</h3>
                        <p>Review the condition and decide on collection.</p>
                    </div>

                    <div class="step-arrow">→</div>

                    <div class="step">
                        <div class="step-number">04</div>
                        <div class="step-icon purple">▣</div>
                        <h3>Assign Staff</h3>
                        <p>Create a request and assign the responsible staff.</p>
                    </div>

                    <div class="step-arrow">→</div>

                    <div class="step">
                        <div class="step-number">05</div>
                        <div class="step-icon green">✓</div>
                        <h3>Complete</h3>
                        <p>Finish collection and update the bin condition.</p>
                    </div>
                </div>
            </section>

            <section class="cta">
                <div>
                    <small>SMARTER WASTE • SMARTER CITY</small>
                    <h2>Ready to manage waste smarter?</h2>
                    <p>Access the SmartWaste management system.</p>
                </div>
                <a href="<%=request.getContextPath()%>/login">Login Now <span>→</span></a>
            </section>
        </main>

        <footer>
            <div class="footer-inner">
                <div class="brand">
                    <span class="brand-mark">♻</span>
                    <span>Smart<span class="brand-accent">Waste</span></span>
                </div>
                <p>Smart Waste Management System</p>
                <p>© 2026 SmartWaste</p>
            </div>
        </footer>

        <script>
            function toggleMenu() {
                document.getElementById("mobileNav").classList.toggle("show");
            }

            function closeMenu() {
                document.getElementById("mobileNav").classList.remove("show");
            }
        </script>

    </body>
</html>
