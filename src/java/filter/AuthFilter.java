package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AppUser;

@WebFilter("/*")
public class AuthFilter implements Filter {

    /**
     * Các URL không cần đăng nhập.
     */
    private static final Set<String> PUBLIC_PREFIX
            = new HashSet<String>(Arrays.asList(
                    "/login",
                    "/logout",
                    "/css/",
                    "/js/",
                    "/images/"
            ));

    /**
     * URL -> các role được phép truy cập.
     *
     * ADM = Administrator MGR = Manager STF = Staff TEC = Technician
     */
    private static final Map<String, Set<String>> ACCESS
            = new LinkedHashMap<String, Set<String>>();

    static {

        // Dashboard
        ACCESS.put("/dashboard",
                roles("ADM", "MGR", "STF", "TEC"));

        // USER MANAGEMENT
        ACCESS.put("/user/create",
                roles("ADM"));
        ACCESS.put("/user/view",
                roles("ADM"));
        ACCESS.put("/user/edit",
                roles("ADM"));
        ACCESS.put("/user/save",
                roles("ADM"));
        ACCESS.put("/user/delete",
                roles("ADM"));
        ACCESS.put("/user/lock",
                roles("ADM"));
        ACCESS.put("/user/reset",
                roles("ADM"));
        ACCESS.put("/user",
                roles("ADM"));

        // AREA
        ACCESS.put("/area/save",
                roles("ADM"));

        ACCESS.put("/area/delete",
                roles("ADM"));

        ACCESS.put("/area/create",
                roles("ADM"));

        ACCESS.put("/area/edit",
                roles("ADM"));

        ACCESS.put("/area/view",
                roles("ADM", "MGR", "STF", "TEC"));

        ACCESS.put("/area",
                roles("ADM", "MGR", "STF", "TEC"));

        // WASTE BIN
        ACCESS.put("/wastebin/save", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/wastebin/delete", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/wastebin/create", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/wastebin/edit", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/wastebin/view", roles("ADM", "MGR", "STF", "TEC"));
        ACCESS.put("/wastebin", roles("ADM", "MGR", "STF", "TEC"));

        // COLLECTION
        ACCESS.put("/collection/staff-by-bin",
                roles("ADM", "MGR"));
        ACCESS.put("/collection/save",
                roles("ADM", "MGR", "STF"));

        ACCESS.put("/collection/delete",
                roles("ADM", "MGR"));

        ACCESS.put("/collection/create",
                roles("ADM", "MGR"));

        ACCESS.put("/collection/edit",
                roles("ADM", "MGR", "STF"));

        ACCESS.put("/collection/view",
                roles("ADM", "MGR", "STF"));

        ACCESS.put("/collection",
                roles("ADM", "MGR", "STF"));

        // MAINTENANCE
        ACCESS.put("/maintenance/save", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/maintenance/delete", roles("ADM", "MGR"));
        ACCESS.put("/maintenance/create", roles("ADM", "MGR"));
        ACCESS.put("/maintenance/edit", roles("ADM", "MGR", "TEC"));
        ACCESS.put("/maintenance", roles("ADM", "MGR", "TEC"));
        // ALERT
        ACCESS.put("/alert/save", roles("ADM", "MGR"));
        ACCESS.put("/alert/delete", roles("ADM", "MGR"));
        ACCESS.put("/alert/create", roles("ADM", "MGR"));
        ACCESS.put("/alert/edit", roles("ADM", "MGR"));
        ACCESS.put("/alert/resolve", roles("ADM", "MGR"));
        ACCESS.put("/alert", roles("ADM", "MGR", "STF", "TEC"));
        // REPORT
        ACCESS.put("/report",
                roles("ADM", "MGR"));
        ACCESS.put("/export",
                roles("ADM", "MGR"));

        // LOG
        ACCESS.put("/log",
                roles("ADM"));
    }

    /**
     * Tạo Set role.
     */
    private static Set<String> roles(String... values) {
        return new HashSet<String>(Arrays.asList(values));
    }

    @Override
    public void doFilter(ServletRequest rq,
            ServletResponse rp,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req
                = (HttpServletRequest) rq;

        HttpServletResponse resp
                = (HttpServletResponse) rp;

        req.setCharacterEncoding("UTF-8");

        String ctx = req.getContextPath();

        String path = req.getRequestURI()
                .substring(ctx.length());

        if (path.length() == 0) {
            path = "/";
        }

        /*
         * Những URL public không cần login.
         */
        for (String p : PUBLIC_PREFIX) {
            if (path.startsWith(p)) {
                chain.doFilter(rq, rp);
                return;
            }
        }

        /*
         * Lấy user từ session.
         */
        AppUser me = null;

        if (req.getSession(false) != null) {
            me = (AppUser) req.getSession(false)
                    .getAttribute("user");
        }

        /*
         * Chưa đăng nhập.
         */
        if (me == null) {
            resp.sendRedirect(ctx + "/login");
            return;
        }

        /*
         * Nếu truy cập root "/" thì chuyển dashboard.
         */
        if ("/".equals(path)) {
            resp.sendRedirect(ctx + "/dashboard");
            return;
        }

        /*
         * Kiểm tra quyền theo URL.
         */
        for (Map.Entry<String, Set<String>> entry
                : ACCESS.entrySet()) {

            String url = entry.getKey();
            Set<String> allowedRoles = entry.getValue();

            if (path.startsWith(url)) {

                String roleId = me.getRoleId();

                if (!allowedRoles.contains(roleId)) {

                    req.setAttribute(
                            "ERROR",
                            "You do not have permission to access this page."
                    );

                    req.getRequestDispatcher(
                            "/WEB-INF/views/denied.jsp"
                    ).forward(req, resp);

                    return;
                }

                break;
            }
        }

        chain.doFilter(rq, rp);
    }

    @Override
    public void init(FilterConfig config)
            throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
