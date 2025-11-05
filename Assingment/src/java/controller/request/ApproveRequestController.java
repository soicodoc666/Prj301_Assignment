package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/approve")
public class ApproveRequestController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        int rid = Integer.parseInt(req.getParameter("rid"));
        int status = Integer.parseInt(req.getParameter("status")); // 1 = duyệt, 2 = từ chối

        // Lấy thông tin người xử lý hiện tại
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        if (eid == -1) {
            resp.sendRedirect("../request/list?error=notfound");
            return;
        }

        // Gắn người xử lý
        Employee processor = new Employee();
        processor.setId(eid);

        RequestForLeave reqLeave = new RequestForLeave();
        reqLeave.setId(rid);
        reqLeave.setStatus(status);
        reqLeave.setProcessed_by(processor);

        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        db.update(reqLeave);

        // Quay lại trang danh sách sau khi duyệt
        resp.sendRedirect("../request/list");
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
