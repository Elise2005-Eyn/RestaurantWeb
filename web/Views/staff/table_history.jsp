<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="table-responsive">
    <table class="table table-striped table-bordered align-middle">
        <thead class="table-primary text-center">
            <tr>
                <th>Mã đặt bàn</th>
                <th>Khách hàng</th>
                <th>Thời gian đặt</th>
                <th>Thời lượng (phút)</th>
                <th>Số khách</th>
                <th>Trạng thái</th>
                <th>Ghi chú</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${history}">
            <tr>
                <td class="text-center fw-semibold">${r.reservation_id}</td>
                <td>${r.customer_name}</td>
                <td class="text-center">
                    <fmt:formatDate value="${r.reserved_at}" pattern="dd/MM/yyyy HH:mm" />
                </td>
                <td class="text-center">${r.reserved_duration}</td>
                <td class="text-center">${r.guest_count}</td>
                <td class="text-center">
                    <span class="badge 
                        ${r.status == 'CONFIRMED' ? 'bg-success' :
                          r.status == 'PENDING' ? 'bg-warning text-dark' :
                          r.status == 'CANCELLED' ? 'bg-danger' : 'bg-secondary'}">
                        ${r.status}
                    </span>
                </td>
                <td>${r.note}</td>
            </tr>
        </c:forEach>

        <c:if test="${empty history}">
            <tr>
                <td colspan="7" class="text-center text-muted py-3">
                    Không có lịch sử đặt bàn nào cho bàn này.
                </td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
