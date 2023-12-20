require('dotenv').config();
const db = require('./dbService');
// const config = require('../config');
const courseDto = require('../dto/coursesDto')
const assignedCoursesDto = require('../dto/assignedCoursesDto')


/*--------COURSES---------*/

    //check if course in Courses table
   function doesCourseExist(course_id){
        return new Promise((resolve, reject) => {
            const query = 'SELECT COUNT(*) As count FROM Courses WHERE ID = ?';
            db.DB.query(query, course_id,(error, results)=>{
                if (error){
                    console.log("Internal serval error");
                    reject(error);
                }

                const course_count = results[0].count;
                const course_exists = course_count>0;

                resolve({
                    success: course_exists, // returns true if the course exists
                    result: results
                })
            })
        });
    };

    // add a new course of courseDTO type
    function addCourse(courseDto){
        return new Promise((resolve, reject) =>{

            doesCourseExist(courseDto.id).then((course_exists) => {
                if (course_exists.success) {
                    console.log(`course ${courseDto.id} already exists in the database`)
                    resolve({
                        success: false,
                        message: "course exists!"
                    })
                }
                else{
                    console.log('adding the course...');
                    const query = 'INSERT INTO Courses (Name, Month, Year, ID) VALUES (?, ?, ?, ?)';
                    const params = [courseDto.name, courseDto.month, courseDto.year, courseDto.id];
                    db.DB.query(query, params, (error, results) => {
                        if(error){
                            console.log("Error 2: Internal server adding a course. ", error);
                            reject(error);
                        }
                        console.log('Course added successfully:', results);
                        resolve({
                            success: true,
                            message: "course added!",
                            result: results
                        })
                    })
                }
            })
        })
    }

/*----------ASSIGNED COURSES---------*/

    //assign a new course
    function assignCourseToStudent(assignedCoursesDto) {
        return new Promise((resolve, reject) => {

            //check if course already assigned
            const check_query = 'SELECT COUNT(*) As count FROM AssignedCourses WHERE course_id = ? AND student_id = ?';
                    const params = [assignedCoursesDto.courseId, assignedCoursesDto.studentId];
                    db.DB.query(check_query, params,(error, results)=>{
                        if (error){
                            console.log("Internal serval error");
                            reject(error);
                            return;
                        }
                        console.log("the count is: "+ results[0].count)
                        console.log(results);
                        const assigned_count = results[0].count;
                        const course_assigned = assigned_count>0;
        
         if(course_assigned) //stops func if assigned else inserts
        {
            console.log("the course is already assigned !")
             resolve({
                success: (!course_assigned), // returns false if the course is already assigned
                result: results,
                message: "the course is already assigned !"
            });
            return;
        }

        const query = 'INSERT INTO AssignedCourses (student_id, course_id, prof_id, status, max_hours) VALUES (?, ?, ?, ?, ?)';
          
        db.DB.query(query, [assignedCoursesDto.studentId, assignedCoursesDto.courseId, assignedCoursesDto.profId, assignedCoursesDto.status, assignedCoursesDto.maxHours], (error, results) => {
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

        //automatically creates a report
        resolve(
            {
                success: true,
                message: "course assigned!",
                result: results
            }
        );
        });
        });
        });
    }

    // delete assigned course by assigned course id [auto deletes the report] for a specific student
    function deleteAssignedCourseById(assigned_course_id, student_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM AssignedCourses WHERE ID = ? AND student_id = ?';

            db.DB.query(query, [assigned_course_id, student_id], (error, results) => {
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

    // delete assigned course by course id and student_id [auto deletes the report which auto deletes all the shifts with that report_id]
    function deleteAssignedCourseByCourseId(course_id, student_id){
        return new Promise((resolve, reject) => {
            const query = 'DELETE FROM AssignedCourses WHERE course_id = ? and student_id = ? ';

            db.DB.query(query, [course_id, student_id], (error, results) => {
                if(error){
                    console.log(`Error 5: cannot delete the assigned course of course_id: ${course_id}`);
                    reject({
                        success: false,
                        error: error
                    });
                    return;
                }
                console.log(`Deleted the assigned course of course_id: ${course_id} for ${student_id}`);
                resolve({
                    success: true,
                    result: results
                })
            })
        })
    }

//get  assigned courses data by student id
function getAllAssignedCourses(student_id){
    return new Promise(async (resolve, reject) =>{
        try {
            const query = 'SELECT * FROM AssignedCourses WHERE student_id = ?';
            db.DB.query(query, student_id, (err, results) =>{
                if (err){
                  throw err;
                }
                resolve({
                    success: true,
                    result: results,
                    message: "Successfully got all the course_id assigned"
                });
            });
            
        }
        catch {
            reject({
                success: false,
                message: "Failed to get all the course data assigned"
            })
        }
    })
}
//get assigned_course_id by course_id NOT NECESSARY?
function getAssignedCourseId(course_id){
    return new Promise(async (resolve, reject) =>{
        try {
            const query = 'SELECT ID FROM AssignedCourses WHERE course_id = ?';
            db.DB.query(query, course_id, (err, results) =>{
                if (err){
                  throw err;
                }
                resolve({
                    success: true,
                    result: results,
                    message: "Successfully got the assigned_course_id"
                });
            });
            
        }
        catch {
            reject({
                success: false,
                message: "Failed to get the assigned_course_id"
            })
        }
    })
}

/*----------REPORT---------*/

    //create report
    function createReport(reportDto){
        return new Promise((resolve, reject) => {
            const query = 'INSERT INTO Report (assigned_course_id, report_date, report_description) VALUES (?, ?, ?)';

            db.DB.query(query, [reportDto.assignedCourseId, reportDto.reportDate, reportDto.reportDescription], (error, results) =>{
                if (error) {
                    console.log("Error4: Could not create a new report")
                    reject({success: false, result: error});
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
    function deleteReportById(report_id){
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

    //get  report data  by report id
    function getReportByReportId(report_id){
        return new Promise(async (resolve, reject) =>{
            try {
                const query = 'SELECT * FROM Report WHERE report_id = ?';
                db.DB.query(query, report_id, (error, results) =>{
                    if (error) {
                        console.log("Error4: Internal server error. Could not get the report")
                        reject({success: false, message: `Internal server error, ${error}`});
                    }
                    resolve({
                        success: true,
                        result: results,
                        message: "Successfully got the report data of the report_id"
                    })
                });
            }
            catch {
                reject({
                    success: false,
                    message: "Failed to get the report"
                })
            }
        })
    }

    //get  report data  by assigned course id
    function getReportsByAssignedId(assigned_course_id){
        return new Promise(async (resolve, reject) =>{
            try {
                const query = 'SELECT * FROM Report WHERE assigned_course_id = ?';
                db.DB.query(query, assigned_course_id, (error, results) =>{
                    if (error) {
                        console.log("Error4: Internal server error. Could not get the report")
                        reject({success: true, message: `Internal server error, ${error}`});
                    }
                    resolve({
                        success: true,
                        result: results,
                        message: "Successfully got the reports data of the assigned_course_id"
                    })
                });
            }
            catch {
                reject({
                    success: false,
                    message: "Failed to get the report"
                })
            }
        })
    }

    //submit report



module.exports = {
    getAllAssignedCourses,
    getAssignedCourseId,
    addCourse, 
    deleteAssignedCourseByCourseId, 
    deleteAssignedCourseById,
    assignCourseToStudent,
    createReport,
    deleteReportById,
    getReportByReportId,
    getReportsByAssignedId
};