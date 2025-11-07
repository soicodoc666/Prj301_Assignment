package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import dal.ScheduleDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.*;
import model.Employee;
import model.Schedule;
import model.RequestForLeave;
import model.iam.Feature;
import model.iam.User;

@WebServlet(urlPatterns = "/division/schedule")
public class ScheduleController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // 1. Kiểm tra quyền VIEW_SCHEDULE
        boolean canViewSchedule = user.getRoles().stream()
                .flatMap(r -> r.getFeatures().stream())
                .anyMatch(f -> "VIEW_SCHEDULE".equals(f.getName()));
        if (!canViewSchedule) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        ArrayList<Employee> employees = new ArrayList<>();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        // 2. Phạm vi hiển thị theo Role
        String roleName = user.getRoles().get(0).getName(); // ví dụ lấy role đầu tiên
        if ("Sếp".equals(roleName)) {
            employees = enrollDB.getAllEmployees();
        } else if ("Trưởng phòng".equals(roleName)) {
            employees = enrollDB.getEmployeesByDivisionId(eid);
        } else {
            employees.add(enrollDB.getEmployeeByUserId(user.getId()));
        }

        // 3. Lấy khoảng thời gian
        String fromRaw = req.getParameter("from");
        String toRaw = req.getParameter("to");
        Date today = new Date(System.currentTimeMillis());
        Date sevenDaysAgo = new Date(today.getTime() - 6L * 24 * 60 * 60 * 1000);
        Date from = (fromRaw == null || fromRaw.isEmpty()) ? sevenDaysAgo : Date.valueOf(fromRaw);
        Date to = (toRaw == null || toRaw.isEmpty()) ? today : Date.valueOf(toRaw);

        // 4. Lấy lịch làm việc
        ScheduleDBContext schedDB = new ScheduleDBContext();
        ArrayList<Schedule> schedules = schedDB.getSchedulesInRange(from, to);

        // 5. Lấy đơn nghỉ phép (chỉ những đơn đã được duyệt)
        RequestForLeaveDBContext leaveDB = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> leaves = leaveDB.getLeavesInRangeByDivision(eid, from, to);

        // 6. Tạo danh sách ngày và slot
        ArrayList<Date> days = new ArrayList<>();
        for (long d = from.getTime(); d <= to.getTime(); d += 86400000L) {
            days.add(new Date(d));
        }
        String[] slots = {"Sáng", "Chiều", "Tối"};

        // 7. Map lịch: employeeId -> date -> slot -> task
        Map<Integer, Map<Date, Map<String, String>>> scheduleMap = new HashMap<>();
        for (Employee e : employees) {
            Map<Date, Map<String, String>> dayMap = new HashMap<>();
            for (Date d : days) {
                Map<String, String> slotMap = new HashMap<>();
                for (String slot : slots) {
                    slotMap.put(slot, ""); // mặc định trống
                }
                dayMap.put(d, slotMap);
            }
            scheduleMap.put(e.getId(), dayMap);
        }

        // 8. Điền task vào map
        for (Schedule s : schedules) {
            int empId = s.getEmployee().getId();
            Date d = s.getDate();
            // phân chia task theo slot (có thể dựa vào dữ liệu task hoặc rule)
            String slot = "Sáng"; // ví dụ mặc định, bạn có thể thêm cột slot trong DB
            if (scheduleMap.containsKey(empId) && scheduleMap.get(empId).containsKey(d)) {
                scheduleMap.get(empId).get(d).put(slot, s.getTask());
            }
        }

        // 9. Đặt trống slot nếu nhân viên nghỉ
        for (RequestForLeave r : leaves) {
            int empId = r.getCreated_by().getId();
            for (long d = r.getFrom().getTime(); d <= r.getTo().getTime(); d += 86400000L) {
                Date day = new Date(d);
                if (scheduleMap.containsKey(empId) && scheduleMap.get(empId).containsKey(day)) {
                    Map<String, String> slotMap = scheduleMap.get(empId).get(day);
                    for (String slot : slots) {
                        slotMap.put(slot, ""); // trống slot
                    }
                }
            }
        }

        // 10. Gửi attributes tới JSP
        req.setAttribute("employees", employees);
        req.setAttribute("days", days);
        req.setAttribute("slots", slots);
        req.setAttribute("scheduleMap", scheduleMap);
        req.getRequestDispatcher("../view/division/schedule.jsp").forward(req, resp);
    }
}
