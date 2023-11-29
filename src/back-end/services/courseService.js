require('dotenv').config();
const db = require('./dbService');
// const config = require('../config');
const courseDto = require('../dto/coursesDto')
const assignedCoursesDto = require('../dto/assignedCoursesDto')

class CourseService{
    constructor(connection){
        this.connection = connection;
    };

    doesCourseExist(course_id){
        return new Promise((resolve, reject) => {
            const query = `SELECT COUNT(*) As count FROM Courses WHERE ID = ${course_id}`;
            db.query(query, (error, results)=>{
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
                }
                else{
                    console.log('adding the course...');
                    const query = `INSERT INTO Courses (Name, Quarter, Semester, ID) VALUES (${courseDto.name}, ${courseDto.quarter}, ${courseDto.semester}, ${courseDto.id})`;
                    db.query(query, (error, results) => {
                        if(error){
                            console.log("Error 2: Internal server adding a course. ", error);
                            reject(error);
                            return;
                        }
                        console.log('Course added successfully:', results);
                        resolve(results)
                    })
                }
            }).finally(() => {
                db.end(); // Close the database connection
              });
        })
    }

    //ASSIGNED COURSES
    assignCourseToStudent(assignedCoursesDto) {
        return new Promise((resolve, reject) => {
          const query = 'INSERT INTO Assigned_courses (student_id, course_id, prof_id, status, max_hours) VALUES (?, ?, ?, ?, ?)';
          
          dp.query(query, [assignedCoursesDto.studentId, assignedCoursesDto.courseId, assignedCoursesDto.professorId, assignedCoursesDto.status, assignedCoursesDto.maxHours], (error, results) => {
            if (error) {
              console.log("Error 3: Internal server assigning a course. ", error);
              reject(error);
              return;
            }
            console.log('Course assigned to student successfully:', results);
            resolve(results);
          });
        });
      }

    
    deleteAssignedCourse(assigned_course_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM AssignedCourses WHERE ID = ?';

            db.query(query, [assigned_course_id], (error, results) => {
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

            db.query(query, [assignedCourseId, reportDate, reportDescription], (error, results) =>{
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

    //delete report by report_id
    deleteReportById(report_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM Report WHERE report_id = ?';

            db.query(query, [report_id], (error, results) =>{
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

    //submit report
}