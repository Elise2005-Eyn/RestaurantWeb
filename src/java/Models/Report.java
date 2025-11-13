package Models;

import java.sql.Timestamp;
import java.time.LocalDate;

public class Report {

    private int reportId;
    private String title;
    private String reportType;
    private LocalDate fromDate;
    private LocalDate toDate;
    private String filePath;
    private String description;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Report() {
    }

    public Report(int reportId, String title, String reportType, LocalDate fromDate, LocalDate toDate,
            String filePath, String description, int createdBy, Timestamp createdAt, Timestamp updatedAt) {
        this.reportId = reportId;
        this.title = title;
        this.reportType = reportType;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.filePath = filePath;
        this.description = description;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter & Setter
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public LocalDate getFromDate() {
        return fromDate;
    }

    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public LocalDate getToDate() {
        return toDate;
    }

    public void setToDate(LocalDate toDate) {
        this.toDate = toDate;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
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
