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

            .btn-detail {
                background-color: #007bff;
                color: white;
            }

            .btn-detail:hover {
                opacity: 0.85;
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

            <!-- ✅ Hiển thị thông báo khi cập nhật, xóa, duyệt hoặc từ chối -->
            <c:if test="${not empty message}">
                <div style="background:#d4edda;color:#155724;padding:10px;
                     border-radius:6px;margin-bottom:15px;border:1px solid #c3e6cb;">
                    ${message}
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.success}">
                <div style="background:#d4edda;color:#155724;padding:10px;
                     border-radius:6px;margin-bottom:15px;border:1px solid #c3e6cb;">
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div style="background:#f8d7da;color:#721c24;padding:10px;
                     border-radius:6px;margin-bottom:15px;border:1px solid #f5c6cb;">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            <form action="${pageContext.request.contextPath}/request/list" method="get" style="margin-bottom: 15px; text-align: right;">
                <input type="text" name="keyword" value="${param.keyword}" placeholder="🔍 Tìm theo tên người tạo..." 
                       style="padding:6px 10px; border-radius:6px; border:1px solid #ccc; width:250px;">
                <button type="submit" style="padding:6px 12px; border:none; background-color:#e1251b; color:white; border-radius:6px;">
                    Tìm kiếm
                </button>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Người tạo</th>
                        <th>Tiêu đề</th>
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
                            <td>${r.title}</td>
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
                                <!-- Nút xem chi tiết -->
                                <a href="review?id=${r.id}" class="btn btn-detail">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- Phân trang -->

            <!-- Phân trang -->
            <div style="margin-top: 20px; text-align: center;">
                <c:if test="${totalpage > 1}">
                    <!-- Trang trước -->
                    <c:if test="${pageindex > 1}">
                        <a href="${pageContext.request.contextPath}/request/list?page=${pageindex - 1}" 
                           style="margin:0 5px; text-decoration:none;">&laquo; Trước</a>
                    </c:if>

                    <!-- Các số trang -->
                    <c:forEach begin="1" end="${totalpage}" var="i">
                        <c:choose>
                            <c:when test="${i == pageindex}">
                                <span style="margin:0 5px; font-weight:bold; color:#e1251b;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/request/list?page=${i}" 
                                   style="margin:0 5px; text-decoration:none; color:#007bff;">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- Trang sau -->
                    <c:if test="${pageindex < totalpage}">
                        <a href="${pageContext.request.contextPath}/request/list?page=${pageindex + 1}" 
                           style="margin:0 5px; text-decoration:none;">Sau &raquo;</a>
                    </c:if>
                </c:if>
            </div>

            <!-- Hiển thị số trang hiện tại / tổng số trang -->
            <div style="text-align:center; margin-top:5px;">
                Trang ${pageindex} / ${totalpage}
            </div>


            <a href="../home" class="back">← Quay lại trang chủ</a>
        </div>

    </body>
</html>
