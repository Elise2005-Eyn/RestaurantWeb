package Models;

import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;
import java.sql.Date;

public class Reservation {
    private Long reservationId;         // BIGINT IDENTITY
    private UUID customerId;            // UNIQUEIDENTIFIER
    private Date reservedDate;          // DATE (ngày đặt theo ca)
    private String sessionCode;         // VARCHAR(20): MORNING/LUNCH/TEA/DINNER/EVENING
    private int guestCount;             // INT (1..10)
    private String status;              // VARCHAR(20): PENDING/CONFIRMED/SEATED/COMPLETED/...
    private String note;                // NVARCHAR
    private Timestamp createdAt;        // DATETIME2
    private Timestamp updatedAt;        // DATETIME2
//    private String rejectionReason;     // NVARCHAR (nếu có cột này)
//    private List<Integer> tableIds;     // dùng khi gán bàn (nếu có)

    public Long getReservationId() {
        return reservationId;
    }

    public void setReservationId(Long reservationId) {
        this.reservationId = reservationId;
    }

    public UUID getCustomerId() {
        return customerId;
    }

    public void setCustomerId(UUID customerId) {
        this.customerId = customerId;
    }

    public Date getReservedDate() {
        return reservedDate;
    }

    public void setReservedDate(Date reservedDate) {
        this.reservedDate = reservedDate;
    }

    public String getSessionCode() {
        return sessionCode;
    }

    public void setSessionCode(String sessionCode) {
        this.sessionCode = sessionCode;
    }


    public int getGuestCount() {
        return guestCount;
    }

    public void setGuestCount(int guestCount) {
        this.guestCount = guestCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

   
}
