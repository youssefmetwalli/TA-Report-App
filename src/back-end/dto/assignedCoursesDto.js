// dto/assignedCoursesDto.js
class AssignedCoursesDto {
  constructor(studentId, courseId, courseName, profId, status, maxHours, submitStatus) {
    this.studentId = studentId;
    this.courseId = courseId;
    this.courseName = courseName;
    this.profId = profId;
    this.status = status; //sa:0 or ta:1
    this.maxHours = maxHours;
    this.submitStatus = submitStatus;
    // this.id = id; //auto-generated in db
  }
}

module.exports = AssignedCoursesDto;