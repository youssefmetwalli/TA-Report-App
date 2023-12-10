// dto/shiftsDto.js
class ShiftsDto {
    constructor(date, startTime, endTime, breakTime, workingHours, workCategoryId, id, report_id) {
      
      this.date = date;
      this.startTime = startTime;
      this.endTime = endTime;
      this.breakTime = breakTime;
      this.workingHours = workingHours;
      this.workCategoryId = workCategoryId;
      this.id = id; //auto
      this.report_id = report_id
    }
  }
  
  module.exports = ShiftsDto;
  