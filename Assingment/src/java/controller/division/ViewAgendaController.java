package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import dal.RoleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.Employee;
import model.RequestForLeave;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class ViewAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // 1. Kiểm tra feature
        RoleDBContext roleDB = new RoleDBContext();
        ArrayList<Role> roles = roleDB.getByUserId(user.getId());
        boolean canViewAgenda = roles.stream()
                .flatMap(r -> r.getFeatures().stream())
                .anyMatch(f -> "/division/agenda".equals(f.getUrl()));
        if (!canViewAgenda) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        // 2. Lấy viewType
        String viewType = req.getParameter("viewType");
        if (viewType == null) {
            viewType = "self"; // mặc định
        }
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        RequestForLeaveDBContext leaveDB = new RequestForLeaveDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        ArrayList<Employee> employees = new ArrayList<>();
        String roleName = user.getRole().getName();

        // 3. Phân quyền theo viewType
        switch (viewType) {
            case "all":
                if ("Trưởng Bộ phận (IT Head)".equals(roleName)) {
                    employees = enrollDB.getAllEmployees();
                }
                break;

            case "division":
                employees = enrollDB.getEmployeesBySupervisorOrDivision(eid);
                break;

            case "self":
            default:
                Employee self = enrollDB.getEmployeeByUserId(user.getId());
                if (self != null) {
                    employees.add(self);
                }
                break;
        }

        // 4. Khoảng thời gian
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        java.sql.Date sevenDaysAgo = new java.sql.Date(today.getTime() - 6L * 24 * 60 * 60 * 1000);
        java.sql.Date from = (req.getParameter("from") == null || req.getParameter("from").isEmpty())
                ? sevenDaysAgo : java.sql.Date.valueOf(req.getParameter("from"));
        java.sql.Date to = (req.getParameter("to") == null || req.getParameter("to").isEmpty())
                ? today : java.sql.Date.valueOf(req.getParameter("to"));

        // 5. Lấy các đơn nghỉ phép hợp lệ
        ArrayList<RequestForLeave> requests = leaveDB.getLeavesInRangeByDivision(eid, from, to);

        // 6. Tạo danh sách ngày
        ArrayList<java.sql.Date> days = new ArrayList<>();
        for (long d = from.getTime(); d <= to.getTime(); d += 86400000L) {
            days.add(new java.sql.Date(d));
        }

        // 7. Tạo map trạng thái
        Map<Integer, Map<java.sql.Date, String>> agenda = new HashMap<>();
        for (Employee e : employees) {
            Map<java.sql.Date, String> map = new HashMap<>();
            for (java.sql.Date day : days) {
                map.put(day, "Đi làm");
            }
            agenda.put(e.getId(), map);
        }

        for (RequestForLeave r : requests) {
            Map<java.sql.Date, String> map = agenda.get(r.getCreated_by().getId());
            if (map != null) {
                for (long d = r.getFrom().getTime(); d <= r.getTo().getTime(); d += 86400000L) {
                    java.sql.Date day = new java.sql.Date(d);
                    if (map.containsKey(day)) {
                        map.put(day, "Nghỉ phép");
                    }
                }
            }
        }

        // 8. Truyền sang JSP
        req.setAttribute("employees", employees);
        req.setAttribute("days", days);
        req.setAttribute("agenda", agenda);
        req.setAttribute("viewType", viewType);
        req.setAttribute("from", from);
        req.setAttribute("to", to);
        req.getRequestDispatcher("../view/division/agenda.jsp").forward(req, resp);
    }
}
