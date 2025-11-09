package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.RequestForLeaveDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Employee;
import model.RequestForLeave;
import model.iam.User;

@WebServlet(urlPatterns = "/request/list")
public class ListController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());
        Employee emp = enrollDB.get(eid);

        // --- Phân trang
        int pagesize = 10;
        String pageParam = req.getParameter("page");
        int pageindex = 1;
        if (pageParam != null) {
            try {
                pageindex = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                pageindex = 1;
            }
        }

        // --- Lấy dữ liệu từ DB
        RequestForLeaveDBContext db = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> rfls = db.getByEmployeeAndSubodiaries(eid, pageindex, pagesize);
        int count = db.countByEmployeeAndSubodiaries(eid);
        int totalpage = (count % pagesize == 0) ? (count / pagesize) : (count / pagesize + 1);

        // --- Lấy thông báo từ session (nếu có)
        String message = (String) req.getSession().getAttribute("message");
        if (message != null) {
            req.setAttribute("message", message);
            req.getSession().removeAttribute("message");
        }

        // --- Set attribute cho JSP
        req.setAttribute("rfls", rfls);
        req.setAttribute("employee", emp);
        req.setAttribute("pageindex", pageindex);
        req.setAttribute("totalpage", totalpage);

        req.getRequestDispatcher("../view/request/list.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
