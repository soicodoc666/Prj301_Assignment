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

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        req.setAttribute("employee", emp);
        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String title = req.getParameter("title");
        String fromRaw = req.getParameter("from");
        String toRaw = req.getParameter("to");
        String reason = req.getParameter("reason");

        // ✅ Lấy Employee đang đăng nhập
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        if (emp == null) {
            req.setAttribute("error", "Không thể xác định thông tin nhân viên!");
            req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra dữ liệu
        if (title == null || title.trim().isEmpty()
                || fromRaw == null || toRaw == null
                || reason == null || reason.trim().isEmpty()) {
            req.setAttribute("error", "⚠️ Vui lòng nhập đầy đủ thông tin!");
            req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
            return;
        }

        java.sql.Date from = java.sql.Date.valueOf(fromRaw);
        java.sql.Date to = java.sql.Date.valueOf(toRaw);

        RequestForLeave reqLeave = new RequestForLeave();
        reqLeave.setTitle(title);
        reqLeave.setCreated_by(emp);
        reqLeave.setFrom(from);
        reqLeave.setTo(to);
        reqLeave.setReason(reason);
        reqLeave.setStatus(0); // Chờ duyệt

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.insert(reqLeave);

        req.setAttribute("success", "✅ Đơn nghỉ phép '" + title + "' đã được gửi thành công!");
        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }

}
