const {
    addCourse, 
    assignCourseToStudent,
    getAllAssignedCourses, 
    getAssignedCourseId,
    deleteAssignedCourseByCourseId,
    createReport
} = require('../services/courseService');
const assignedCourseDto = require('../dto/assignedCoursesDto');
const courseDto = require ('../dto/coursesDto');
const reportDto = require('../dto/reportsDto');


//get all the assigned courses data for the student_id
const getAllAssignedCoursesRoute = async function (req, res) {
    try {
        // const { params } = req; // Assuming studentId is in the route parameters
        const student_id  = req.body.student_id;
        const result =  await getAllAssignedCourses(student_id);

        if (result.success) {
            res.json(result);
        } else {
            res.status(500).json(result); // Adjust the status code as needed
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

//add a course and assign to a student
const addCourseRoute = async function (req, res)  {
    try{
        //params and body
        const student_id = req.body.student_id;
        const prof_id = req.body.prof_id;
        const course_id = req.body.course_id;
        const status = req.body.status;
        const max_hours = req.body.max_hours;
        const course_name = req.body.course_name;
        const month = req.body.month;
        const year = req.body.year

        //dto
        const assignedCourse = new assignedCourseDto(student_id, course_id, prof_id, status, max_hours);
        const newCourse = new courseDto(course_id, course_name, month, year);

        //add and assign new course
        const addingCourse = await addCourse(newCourse);
        const assigningCourse = await assignCourseToStudent(assignedCourse);
        console.log(assigningCourse)

        if (addingCourse.success) {
            console.log("Added the new course in the course database");
        }
        else{
            console.log("This course is already added in the course database");
        }
        if (assigningCourse.success) {
            //if assigned a course, create a new report

            //get assigned_course_id
            const assigned_course_id = await getAssignedCourseId(course_id)
            if(!assigned_course_id.success){
                console.log(assigned_course_id);
                res.status(500).json(assigningCourse);
            }
            // console.log(assigned_course_id);
            const date = new Date();
            const newReport = new reportDto(assigned_course_id.result[0].ID, date, "new report")
            const createNewReport = await createReport(newReport);
            if(!createNewReport.success){
                res.status(500).json(createNewReport);
            }
            res.json(assigningCourse);
        }
        else {
                res.status(500).json(assigningCourse); // Adjust the status code as needed
        }

    }
    catch{
        console.error("internal server error");
    }
}

//delete assigned course by course_id and student_id
const deleteAssignedCourseByCourseIdRoute = async function(req, res){
    try{
        const course_id = req.body.course_id;
        const student_id = req.body.student_id;
        const deletingAssignedCourse = await deleteAssignedCourseByCourseId(course_id, student_id);
        if(!deletingAssignedCourse.success){
            console.log("ERROR: Could not delete this course")
            res.status(500).json(deletingAssignedCourse);
        }
        res.json(deletingAssignedCourse);
    }
    catch{
        console.log("internal server error")
        res.status(500).json("internal server error");
    }
}

//TODO remove  month, year from courses table and add them on reports table instead

module.exports = {
    getAllAssignedCoursesRoute,
    addCourseRoute,
    deleteAssignedCourseByCourseIdRoute
};