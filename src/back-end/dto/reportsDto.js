// dto/reportsDto.js
class ReportsDto {
    constructor(id, assignedCourseId, shiftID, studentId, reportDate, reportDescription) {
        this.id = id;
        this.assignedCourseId = assignedCourseId;
        this.shiftID = shiftID;
        this.studentId = studentId;
        this.reportDate = reportDate;
        this.reportDescription = reportDescription;
    }
  }
  
  module.exports = ReportsDto;
  