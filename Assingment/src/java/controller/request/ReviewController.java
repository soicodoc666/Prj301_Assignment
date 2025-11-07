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
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        switch (action) {
            case "update" -> {
                RequestForLeave existing = db.get(rid); // ✅ lấy đơn hiện tại trong DB
                if (existing != null) {
                    existing.setTitle(req.getParameter("title"));
                    existing.setFrom(java.sql.Date.valueOf(req.getParameter("from")));
                    existing.setTo(java.sql.Date.valueOf(req.getParameter("to")));
                    existing.setReason(req.getParameter("reason"));
                    existing.setStatus(0);
                    db.update(existing); // ✅ gọi update có đủ thông tin created_by, created_time
                }
            }

            case "delete" -> {
                db.delete(rid);
            }

            case "approve" -> {
                db.updateStatus(rid, 1, eid);
            }

            case "reject" -> {
                db.updateStatus(rid, 2, eid);
            }
        }

        // ✅ Quay lại danh sách
        resp.sendRedirect(req.getContextPath() + "/request/list");
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
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

        boolean isOwner = (reqLeave.getCreated_by() != null
                && reqLeave.getCreated_by().getId() == emp.getId());

        req.setAttribute("isOwner", isOwner);
        req.setAttribute("reqLeave", reqLeave);
        req.setAttribute("employee", emp);

        req.getRequestDispatcher("../view/request/review.jsp").forward(req, resp);
    }
}
