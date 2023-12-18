// dto/shiftsDto.js
class ShiftsDto {
    constructor(date, startTime, endTime, breakTime, workingHours, workCategoryId, reportId) {
      
      this.date = date; //date
      /* time type */
      this.startTime = startTime;
      this.endTime = endTime;
      this.breakTime = breakTime;
      /* float */
      this.workingHours = workingHours;
      /* int*/
      this.workCategoryId = workCategoryId;
      // this.id = id; //auto
      this.reportId = reportId
    }
  }
  
  module.exports = ShiftsDto;
  