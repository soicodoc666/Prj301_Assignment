<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>🗓 Thời khoá biểu</title>
        <style>
            body {
                font-family: "Segoe UI", sans-serif;
                background:#f5f6f8;
                margin:0;
                padding:0;
            }
            header {
                background:#e1251b;
                color:white;
                padding:15px 40px;
                display:flex;
                justify-content:space-between;
                align-items:center;
            }
            header h2 {
                margin:0;
                font-size:22px;
            }
            .container {
                max-width:1100px;
                margin:40px auto;
                background:white;
                border-radius:10px;
                padding:25px 35px;
                box-shadow:0 4px 10px rgba(0,0,0,0.1);
            }
            table {
                width:100%;
                border-collapse:collapse;
            }
            th, td {
                border:1px solid #ddd;
                text-align:center;
                padding:8px;
            }
            th {
                background:#f5f5f5;
            }
            .slot-working {
                background-color:#c9f7c0;
            }  /* đi làm */
            .slot-leave {
                background-color:#f7c0c0;
            }    /* nghỉ */
            .back-home {
                display:inline-block;
                background:#e1251b;
                color:white;
                padding:8px 16px;
                border-radius:6px;
                text-decoration:none;
                margin-bottom:15px;
            }
            .back-home:hover {
                background:#c92018;
            }
        </style>
    </head>
    <body>
        <header>
            <h2>🗓 Thời khoá biểu nhân viên</h2>
            <div>
                Xin chào, <c:out value="${sessionScope.user.displayname}" />
            </div>
        </header>

        <div class="container">
            <a href="../home" class="back-home">🏠 Quay về Trang chủ</a>

            <table>
                <thead>
                    <tr>
                        <th>Nhân viên</th>
                            <c:forEach var="day" items="${days}">
                            <th colspan="3">${day}</th>
                            </c:forEach>
                    </tr>
                    <tr>
                        <th></th>
                            <c:forEach var="day" items="${days}">
                            <th>Sáng</th>
                            <th>Chiều</th>
                            <th>Tối</th>
                            </c:forEach>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="emp" items="${employees}">
                        <tr>
                            <td>${emp.name}</td>
                            <c:forEach var="day" items="${days}">
                                <c:set var="slotsMap" value="${scheduleMap[emp.id][day]}" />
                                <td class="${slotsMap['Sáng'] eq 'Nghỉ' ? 'slot-leave' : 'slot-working'}">
                                    <c:out value="${slotsMap['Sáng']}" />
                                </td>
                                <td class="${slotsMap['Chiều'] eq 'Nghỉ' ? 'slot-leave' : 'slot-working'}">
                                    <c:out value="${slotsMap['Chiều']}" />
                                </td>
                                <td class="${slotsMap['Tối'] eq 'Nghỉ' ? 'slot-leave' : 'slot-working'}">
                                    <c:out value="${slotsMap['Tối']}" />
                                </td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
