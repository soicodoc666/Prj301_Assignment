/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String name = req.getParameter("ename");

        // Nếu người dùng nhập tên nhân viên -> kiểm tra
        if (name != null && !name.trim().isEmpty()) {
            EnrollmentDBContext enrollDB = new EnrollmentDBContext();
            Employee emp = enrollDB.getByName(name.trim());
            if (emp != null) {
                req.setAttribute("foundEmployee", emp);
            } else {
                req.setAttribute("error", "❌ Nhân viên '" + name + "' không tồn tại trong công ty!");
            }
        }

        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String name = req.getParameter("ename");
        String fromRaw = req.getParameter("from");
        String toRaw = req.getParameter("to");
        String reason = req.getParameter("reason");

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        Employee emp = enrollDB.getByName(name);

        // Nếu không tìm thấy nhân viên
        if (emp == null) {
            req.setAttribute("error", "❌ Nhân viên '" + name + "' không tồn tại trong công ty!");
            req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra dữ liệu nhập
        if (fromRaw == null || toRaw == null || fromRaw.isEmpty() || toRaw.isEmpty() || reason == null || reason.isEmpty()) {
            req.setAttribute("error", "⚠️ Vui lòng nhập đầy đủ thông tin!");
            req.setAttribute("foundEmployee", emp);
            req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
            return;
        }

        Date from = Date.valueOf(fromRaw);
        Date to = Date.valueOf(toRaw);

        RequestForLeave reqLeave = new RequestForLeave();
        reqLeave.setCreated_by(emp);
        reqLeave.setFrom(from);
        reqLeave.setTo(to);
        reqLeave.setReason(reason);
        reqLeave.setStatus(0); // 0 = chờ duyệt

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.insert(reqLeave);

        req.setAttribute("success", "✅ Đơn nghỉ phép của bạn đã được gửi thành công!");
        req.setAttribute("foundEmployee", emp);
        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }
}
