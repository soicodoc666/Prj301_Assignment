package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EnrollmentDBContext;
import dal.NotificationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Notification;
import model.iam.User;

@WebServlet(urlPatterns = "/division/notification")
public class NotificationController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        NotificationDBContext notiDB = new NotificationDBContext();
        ArrayList<Notification> notifications = notiDB.getNotificationsByEmployee(eid);

        int unseenCount = notiDB.countUnseen(eid);

        req.setAttribute("notifications", notifications);
        req.setAttribute("unseenCount", unseenCount);
        req.getRequestDispatcher("/view/division/notification.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        NotificationDBContext notiDB = new NotificationDBContext();
        String action = req.getParameter("action");

        if ("markAll".equals(action)) {
            notiDB.markAllAsSeen(eid);
        } else if ("markOne".equals(action)) {
            int nid = Integer.parseInt(req.getParameter("nid"));
            notiDB.markAsSeen(nid);
        }

        resp.sendRedirect(req.getContextPath() + "/division/notification");
    }
}
