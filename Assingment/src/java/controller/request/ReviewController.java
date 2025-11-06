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

@WebServlet(urlPatterns = "/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int rid = Integer.parseInt(req.getParameter("id"));
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave reqLeave = db.get(rid);

        if (reqLeave == null) {
            req.setAttribute("error", "Không tìm thấy đơn nghỉ phép để cập nhật!");
            req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
            return;
        }

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        String message = null;

        switch (action) {
            case "update":
                String title = req.getParameter("title");
                String reason = req.getParameter("reason");
                reqLeave.setTitle(title);
                reqLeave.setReason(reason);
                db.update(reqLeave);
                message = "✅ Cập nhật đơn nghỉ phép thành công!";
                break;

            case "delete":
                db.delete(reqLeave);
                message = "❌ Đã xóa đơn nghỉ phép.";
                req.setAttribute("deleted", true);
                break;

            case "approve":
                reqLeave.setStatus(1);
                reqLeave.setProcessed_by(emp);
                db.update(reqLeave);
                message = "✅ Đơn đã được chấp nhận!";
                break;

            case "reject":
                reqLeave.setStatus(2);
                reqLeave.setProcessed_by(emp);
                db.update(reqLeave);
                message = "❌ Đơn đã bị từ chối!";
                break;
        }

        // ✅ Load lại đơn sau khi cập nhật bằng đối tượng mới
        RequestForLeave updated = new RequestForLeaveDBContext().get(rid);

        if (updated == null && !"delete".equals(action)) {
            req.setAttribute("error", "Không thể tải lại đơn nghỉ phép sau khi cập nhật!");
        } else {
            req.setAttribute("reqLeave", updated);
        }

        req.setAttribute("isOwner", reqLeave.getCreated_by().getId() == emp.getId());
        req.setAttribute("employee", emp);
        req.setAttribute("success", message);

        req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendRedirect("list");
            return;
        }

        int rid = Integer.parseInt(idRaw);
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        RequestForLeave reqLeave = db.get(rid);

        if (reqLeave == null) {
            req.setAttribute("error", "Không tìm thấy đơn nghỉ phép!");
            req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
            return;
        }

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        boolean isOwner = (reqLeave.getCreated_by().getId() == emp.getId());
        req.setAttribute("isOwner", isOwner);
        req.setAttribute("reqLeave", reqLeave);
        req.setAttribute("employee", emp);
        req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
    }

}
