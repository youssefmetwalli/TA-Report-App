// dto/reportsDto.js
class ReportsDto {
    constructor(assignedCourseId, reportDate, reportDescription, year, month) {
        // this.id = id;//auto added in db
        this.assignedCourseId = assignedCourseId;
        this.reportDate = reportDate; //null
        this.reportDescription = reportDescription; //null
        this.year = year;
        this.month = month;
    }
  }
  
  module.exports = ReportsDto;