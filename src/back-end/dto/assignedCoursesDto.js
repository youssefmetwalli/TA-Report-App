// dto/assignedCoursesDto.js
class AssignedCoursesDto {
    constructor(studentId, courseId, profId, status, maxHours) {
      this.studentId = studentId;
      this.courseId = courseId;
      this.profId = profId;
      this.status = status; //sa or ta
      this.maxHours = maxHours;
      // this.assigned_course_report_id= assigned_course_report_id //auto added from AssignedCoursesReports table
      // this.id = id; //auto-generated in db
    }
  }
  
  module.exports = AssignedCoursesDto;
  