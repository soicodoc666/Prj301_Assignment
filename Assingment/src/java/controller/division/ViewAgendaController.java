/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class ViewAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user); // chỉ dùng GET cho hiển thị
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // ✅ Đặt mã hóa UTF-8 cho toàn bộ request/response
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        // Lấy khoảng thời gian từ request
        String fromRaw = req.getParameter("from");
        String toRaw = req.getParameter("to");

        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        java.sql.Date sevenDaysAgo = new java.sql.Date(today.getTime() - 6L * 24 * 60 * 60 * 1000);

        java.sql.Date from = (fromRaw == null || fromRaw.isEmpty()) ? sevenDaysAgo : java.sql.Date.valueOf(fromRaw);
        java.sql.Date to = (toRaw == null || toRaw.isEmpty()) ? today : java.sql.Date.valueOf(toRaw);

        // Lấy danh sách đơn nghỉ
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> requests = db.getLeavesInRangeByDivision(eid, from, to);

        // Tạo danh sách ngày
        ArrayList<java.sql.Date> days = new ArrayList<>();
        for (long d = from.getTime(); d <= to.getTime(); d += 86400000L) { // cộng 1 ngày
            days.add(new java.sql.Date(d));
        }

        // Danh sách nhân viên
        ArrayList<Employee> employees = new ArrayList<>();
        for (RequestForLeave r : requests) {
            boolean exists = false;
            for (Employee e : employees) {
                if (e.getId() == r.getCreated_by().getId()) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                employees.add(r.getCreated_by());
            }
        }

        req.setAttribute("from", from);
        req.setAttribute("to", to);
        req.setAttribute("requests", requests);
        req.setAttribute("days", days);
        req.setAttribute("employees", employees);
        req.getRequestDispatcher("../view/division/agenda.jsp").forward(req, resp);
    }

}
