<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch nghỉ phép - Phòng ban</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #e1251b;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            font-weight: bold;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            background-color: white;
            border-radius: 10px;
            padding: 25px 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h3 {
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #fafafa;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .status {
            font-weight: bold;
            border-radius: 6px;
            padding: 4px 8px;
        }

        .pending { color: #ff9800; }
        .approved { color: #4caf50; }
        .rejected { color: #e1251b; }

        .filter-form {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-form input, .filter-form select {
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .filter-form button {
            background-color: #e1251b;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .filter-form button:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
<header>
    <h2>Lịch nghỉ phép phòng ban</h2>
    <div>
        <a href="../home">Trang chủ</a>
        <a href="../request/create">Tạo đơn</a>
        <a href="../request/list">Xem đơn</a>
        <a href="../logout">Đăng xuất</a>
    </div>
</header>

<div class="container">
    <h3>Danh sách yêu cầu nghỉ phép</h3>

    <form class="filter-form" method="get" action="agenda">
        <label>Từ:</label>
        <input type="date" name="from">

        <label>Đến:</label>
        <input type="date" name="to">

        <label>Trạng thái:</label>
        <select name="status">
            <option value="">Tất cả</option>
            <option value="0">Đang chờ</option>
            <option value="1">Đã duyệt</option>
            <option value="2">Bị từ chối</option>
        </select>

        <button type="submit">Lọc</button>
    </form>

    <table>
        <tr>
            <th>ID</th>
            <th>Người tạo</th>
            <th>Lý do</th>
            <th>Từ ngày</th>
            <th>Đến ngày</th>
            <th>Trạng thái</th>
            <th>Xử lý bởi</th>
        </tr>

        <c:forEach var="r" items="${requests}">
            <tr>
                <td>${r.id}</td>
                <td>${r.created_by.name}</td>
                <td>${r.reason}</td>
                <td>${r.from}</td>
                <td>${r.to}</td>
                <td>
                    <span class="status 
                        ${r.status == 0 ? 'pending' : 
                         r.status == 1 ? 'approved' : 'rejected'}">
                        ${r.status == 0 ? 'Đang chờ' :
                          r.status == 1 ? 'Đã duyệt' : 'Bị từ chối'}
                    </span>
                </td>
                <td>
                    <c:if test="${r.processed_by != null}">
                        ${r.processed_by.name}
                    </c:if>
                    <c:if test="${r.processed_by == null}">
                        —
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>
