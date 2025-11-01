<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách yêu cầu nghỉ phép</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
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
            font-weight: bold;
            margin-left: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }

        h3 {
            color: #333;
            border-left: 5px solid #e1251b;
            padding-left: 10px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th {
            background-color: #e1251b;
            color: white;
            padding: 12px;
            text-align: center;
        }

        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        tr:hover {
            background-color: #f9f9f9;
        }

        .status-processing {
            color: #f0ad4e;
            font-weight: bold;
        }

        .status-approved {
            color: #28a745;
            font-weight: bold;
        }

        .status-rejected {
            color: #dc3545;
            font-weight: bold;
        }

        .btn {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-approve {
            background-color: #28a745;
            color: white;
        }

        .btn-reject {
            background-color: #dc3545;
            color: white;
        }

        .btn:hover {
            opacity: 0.85;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #e1251b;
            font-weight: bold;
        }

    </style>
</head>
<body>

<header>
    <h2>Danh sách yêu cầu nghỉ phép</h2>
    <div>
        <a href="../home">Trang chủ</a>
        <a href="../logout">Đăng xuất</a>
    </div>
</header>

<div class="container">
    <h3>Danh sách yêu cầu của bạn</h3>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Người tạo</th>
                <th>Lý do</th>
                <th>Từ ngày</th>
                <th>Đến ngày</th>
                <th>Trạng thái</th>
                <th>Người xử lý</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${requestScope.rfls}" var="r">
                <tr>
                    <td>${r.id}</td>
                    <td>${r.created_by.name}</td>
                    <td>${r.reason}</td>
                    <td>${r.from}</td>
                    <td>${r.to}</td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status eq 0}">
                                <span class="status-processing">Đang chờ duyệt</span>
                            </c:when>
                            <c:when test="${r.status eq 1}">
                                <span class="status-approved">Đã duyệt</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-rejected">Từ chối</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${r.processed_by ne null}">
                            ${r.processed_by.name}
                        </c:if>
                        <c:if test="${r.processed_by eq null}">
                            Chưa xử lý
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${r.processed_by eq null}">
                            <a href="review?id=${r.id}&action=approve" class="btn btn-approve">Duyệt</a>
                            <a href="review?id=${r.id}&action=reject" class="btn btn-reject">Từ chối</a>
                        </c:if>
                        <c:if test="${r.processed_by ne null}">
                            —
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <a href="../home" class="back">← Quay lại trang chủ</a>
</div>

</body>
</html>
