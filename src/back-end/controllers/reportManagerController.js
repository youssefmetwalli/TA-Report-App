const courseService = require('../services/courseService')
const assignedCourseDto = require('../dto/assignedCoursesDto')
const courseDto = require ('../dto/coursesDto')


//get all the assigned courses data for the student_id
const getAllCourses = async (req, res) => {
    try {
        const { params } = req; // Assuming studentId is in the route parameters
        const { studentId } = params;
        const result = await courseService.getAllAssignedCourses(studentId);
        
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

//get report data given the assigned_course_id
const getReportDataByAssignedId = async (req, res) =>{
    try {
        const assigned_course_id = req.body.assigned_course_id;
        const result = await courseService.getReportData(assigned_course_id);
        
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

//add a course
const addCourse = async(req, res, next) => {
    try{
        //params and body
        const student_id = req.params.studentId;
        const prof_id = req.body.prof_id;
        const course_id = req.body.course_id;
        const status = req.body.prof_id;
        const max_hours = req.max_hours;
        const course_name = req.course_name;
        const quarter = req.quarter;
        const semester = req.semester

        //dto
        const assignedCourse = new assignedCourseDto(student_id, course_id, prof_id, status, max_hours);
        const newCourse = new courseDto(course_id, course_name, quarter, semester);

        //add and assign new course
        const addingCourse = courseService.addCourse(courseDto);
        const assigningCourse = courseService.assignCourseToStudent(assignedCourse);

        if (addingCourse.success) {
            res.json(addingCourse);
            if (assigningCourse.success) {
                res.json(assigningCourse);
            } else {
                res.status(500).json(addingCourse); // Adjust the status code as needed
            }
        } else {
            res.status(500).json(addingCourse); // Adjust the status code as needed
        }

    }
    catch{
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

//get report data given the report id
// const getReportDataByReportId = async (req, res) =>{
//     try {
//         const report_id = req.body;
//         const result = await courseService.getAllAssignedCourses(assigned_course_id);
        
//         if (result.success) {
//             res.json(result);
//         } else {
//             res.status(500).json(result); // Adjust the status code as needed
//         }
//     } catch (error) {
//         console.error(error);
//         res.status(500).json({
//             success: false,
//             message: "Internal Server Error",
//         });
//     }
// }

module.exports = {
    getAllCourses,
    getReportDataByAssignedId,
    addCourse
};