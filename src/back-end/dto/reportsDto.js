// dto/reportsDto.js
class ReportsDto {
    constructor(id, assignedCourseId, reportDate, reportDescription) {
        this.id = id;
        this.assignedCourseId = assignedCourseId;
        this.reportDate = reportDate; //null
        this.reportDescription = reportDescription; //null
    }
  }
  
  module.exports = ReportsDto;
  