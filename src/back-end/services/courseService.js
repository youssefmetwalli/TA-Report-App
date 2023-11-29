require('dotenv').config();
const db = require('./db');
// const config = require('../config');
const courseDto = require('../dto/coursesDto')

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
    addCourse(course){
        return new Promise((resolve, reject) =>{

            this.doesCourseExist(course.id).then((course_exists) => {
                if (courseExists) {
                    console.log(`course ${course.id} already exists in the database`)
                }
                else{
                    console.log('adding the course...');
                    const query = `INSERT INTO Courses (Name, Quarter, Semester, ID) VALUES (${course.name}, ${course.quarter}, ${course.semester}, ${course.id})`;
                    db.query(query, (error, results) => {
                        if(error){
                            console.log("Error 2: Internal server adding a course. ", error);
                            reject(error);
                            return;
                        }
                        console.log('Course added successfully:', result);
                        resolve(results)
                    })
                }
            }).finally(() => {
                connection.end(); // Close the database connection
              });
        })
    }

    assignCourseToStudent(assignedCoursesDto) {
        return new Promise((resolve, reject) => {
          const query = 'INSERT INTO Assigned_courses (student_id, course_id, prof_id, status, max_hours) VALUES (?, ?, ?, ?, ?)';
          
          connection.query(query, [assignedCoursesDto.studentId, assignedCoursesDto.courseId, assignedCoursesDto.professorId, assignedCoursesDto.status, assignedCoursesDto.maxHours], (error, results) => {
            if (error) {
              console.log("Error 3: Internal server assigning a course. ", error);
              reject(error);
              return;
            }
            console.log('Course assigned to student successfully:', result);
            resolve(results);
          });
        });
      }

    //   REPORT
}