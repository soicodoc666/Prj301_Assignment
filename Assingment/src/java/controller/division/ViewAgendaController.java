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

        // 1️⃣ Lấy employee ID từ user đang đăng nhập
        EnrollmentDBContext enrollDB = new EnrollmentDBContext();
        int eid = enrollDB.getEmployeeIdByUserId(user.getId());

        // 2️⃣ Lấy danh sách các đơn nghỉ của nhân viên và cấp dưới
        RequestForLeaveDBContext rflDB = new RequestForLeaveDBContext();
        ArrayList<RequestForLeave> requests = rflDB.getByEmployeeAndSubodiaries(eid);

        // 3️⃣ Gửi danh sách sang view để hiển thị
        req.setAttribute("requests", requests);
        req.getRequestDispatcher("../view/division/agenda.jsp").forward(req, resp);
    }

}
