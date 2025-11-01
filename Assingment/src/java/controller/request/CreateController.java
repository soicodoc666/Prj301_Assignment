package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
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
        // Hiển thị form tạo đơn
        req.getRequestDispatcher("../view/request/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String reason = req.getParameter("reason");
        Date from = Date.valueOf(req.getParameter("from"));
        Date to = Date.valueOf(req.getParameter("to"));

        // Tạo đối tượng Employee từ User hiện tại
        Employee emp = new Employee();
        emp.setId(user.getId());

        // Tạo đơn nghỉ phép
        RequestForLeave rfl = new RequestForLeave();
        rfl.setReason(reason);
        rfl.setFrom(from);
        rfl.setTo(to);
        rfl.setCreated_by(emp);
        rfl.setStatus(0); // 0 = đang chờ duyệt

        // Lưu vào DB
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.insert(rfl);

        // Quay lại danh sách đơn
        resp.sendRedirect("list");
    }
}
