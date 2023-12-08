// dto/assignedCoursesDto.js
class AssignedCoursesDto {
    constructor(id, studentId, courseId, profId, status, maxHours) {
      this.studentId = studentId;
      this.courseId = courseId;
      this.profId = profId;
      this.status = status; //sa or ta
      this.maxHours = maxHours;
      this.id = id; //auto-generated in db
    }
  }
  
  module.exports = AssignedCoursesDto;
  