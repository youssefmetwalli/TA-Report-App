require('dotenv').config();
const db = require('./dbService');
// const config = require('../config');
const courseDto = require('../dto/coursesDto')
const assignedCoursesDto = require('../dto/assignedCoursesDto')

class CourseService{
    constructor(connection){
        this.connection = connection;
    };

    //check if course in Courses table
    doesCourseExist(course_id){
        return new Promise((resolve, reject) => {
            const query = `SELECT COUNT(*) As count FROM Courses WHERE ID = ${course_id}`;
            db.DB.query(query, (error, results)=>{
                if (error){
                    console.log("Internal serval error");
                    reject(error);
                    return;
                }

                const course_count = results[0].count;
                const course_exists = course_count>0;

                resolve(course_exists)　// returns true if the course exists
            })
        });
    };

    // add a new course of courseDTO type
    addCourse(courseDto){
        return new Promise((resolve, reject) =>{

            this.doesCourseExist(courseDto.id).then((course_exists) => {
                if (course_exists) {
                    console.log(`course ${courseDto.id} already exists in the database`)
                    resolve({
                        success: true,
                        message: "course exists!"
                    })
                }
                else{
                    console.log('adding the course...');
                    const query = `INSERT INTO Courses (Name, Quarter, Semester, ID) VALUES (${courseDto.name}, ${courseDto.quarter}, ${courseDto.semester}, ${courseDto.id})`;
                    db.DB.query(query, (error, results) => {
                        if(error){
                            console.log("Error 2: Internal server adding a course. ", error);
                            reject(error);
                            return;
                        }
                        console.log('Course added successfully:', results);
                        resolve({
                            success: true,
                            message: "course added!",
                            result: results
                        })
                    })
                }
            }).finally(() => {
                db.DB.end(); // Close the database connection
              });
        })
    }

    //ASSIGNED COURSES
    assignCourseToStudent(assignedCoursesDto) {
        return new Promise((resolve, reject) => {
          const query = 'INSERT INTO Assigned_courses (student_id, course_id, prof_id, status, max_hours) VALUES (?, ?, ?, ?, ?)';
          
          dp.DB.query(query, [assignedCoursesDto.studentId, assignedCoursesDto.courseId, assignedCoursesDto.professorId, assignedCoursesDto.status, assignedCoursesDto.maxHours], (error, results) => {
            if (error) {
              console.log("Error 3: Internal server assigning a course. ", error);
              reject({
                success: false,
                message: "Internal Server Error",
                error: error
            });
              return;
            }
            console.log('Course assigned to student successfully:', results);
            resolve(
                {
                    success: true,
                    message: "course assigned!",
                    result: results
                }
            );
          });
        });
      }

    
    deleteAssignedCourse(assigned_course_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM AssignedCourses WHERE ID = ?';

            db.DB.query(query, [assigned_course_id], (error, results) => {
                if(error){
                    console.log(`Error 5: cannot delete the assigned course of ID: ${assigned_course_id}`);
                    reject(error);
                    return;
                }
                console.log(`Deleted the assigned course of ID: ${assigned_course_id}`);
                resolve(results)
            })
        })
    }
    

    //   REPORT
    createReport(assignedCourseId, reportDate, reportDescription){
        return new Promise((resolve, reject) => {
            const query = 'INSERT INTO Report (assigned_course_id, report_date, report_description) VALUES (?, ?, ?)';

            db.DB.query(query, [assignedCourseId, reportDate, reportDescription], (error, results) =>{
                if (error) {
                    console.log("Error4: Could not create a new report")
                    reject(error);
                    return;
                }
                console.log('Report created successfully');
                resolve({
                    success: true,
                    message: 'Report created successfully',
                    result: results
                })
            });
        });
    }

    //delete report by report_id
    deleteReportById(report_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM Report WHERE report_id = ?';

            db.DB.query(query, [report_id], (error, results) =>{
                if (error) {
                    console.log("Error4: Could not create a new report")
                    reject(error);
                    return;
                }
                console.log('Report created successfully');
                resolve(results)
            });
        });
    }

    //get  report_id by assigned student id
    getReportData(assigned_student_id){
        return new Promise(async (resolve, reject) =>{
            try {
                const query = 'SELECT * FROM AssignedCourses WHERE assigned_course_id = ?';
                const [rows] = await db.DB.query(query, assigned_student_id);
                resolve({
                    success: true,
                    data: rows,
                    message: "Successfully got the report data of the assigned_student_id"
                })
            }
            catch {
                reject({
                    success: false,
                    message: "Failed to get the report_id assigned"
                })
            }
        })
    }

    //submit report
}

//get  assigned course data by student id
function getAllAssignedCourses(studentId){
    return new Promise(async (resolve, reject) =>{
        try {
            const query = 'SELECT * FROM AssignedCourses WHERE student_id = ?';
            const [rows] = await db.DB.query(query, studentId);
            resolve({
                success: true,
                data: rows,
                message: "Successfully got all the course_id assigned"
            })
        }
        catch {
            reject({
                success: false,
                message: "Failed to get all the course_id assigned"
            })
        }
    })
}

module.exports = {CourseService, getAllAssignedCourses};