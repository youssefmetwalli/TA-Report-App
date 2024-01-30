const {
    addCourse,
    updateAssignedCourse,
    assignCourseToStudent,
    getAllAssignedCourses, 
    getAssignedCourseId,
    getAssignedCoursesBySubmitStatus,
    getAssignedCoursesBySubmitStatusAndProfId,
    deleteAssignedCourseByCourseId,
    createReport
} = require('../services/courseService');
const assignedCourseDto = require('../dto/assignedCoursesDto');
const courseDto = require ('../dto/coursesDto');
const reportDto = require('../dto/reportsDto');


//get all the assigned courses data for the student_id
const getAllAssignedCoursesRoute = async function (req, res) {
    try {
        const student_id = req.body.id;

        if (!student_id) {
            return res.status(400).json({
                success: false,
                message: "Missing 'id' in the request body",
            });
        }

        const result = await getAllAssignedCourses(student_id);

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
};

const getAssignedCoursesBySubmitStatusRoute = async function (req, res) {
    try {
        const submit_status = req.body.submit_status;

        if (!submit_status) {
            return res.status(400).json({
                success: false,
                message: "Missing 'submit_status' in the request body",
            });
        }

        const result = await getAssignedCoursesBySubmitStatus(submit_status);

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
};

const getAssignedCoursesBySubmitStatusAndProfIdRoute = async function (req, res) {
    try {
        const submit_status = req.body.submit_status;
        const prof_id = req.body.prof_id;

        if (!submit_status) {
            return res.status(400).json({
                success: false,
                message: "Missing 'submit_status' in the request body",
            });
        }

        const result = await getAssignedCoursesBySubmitStatusAndProfId(submit_status, prof_id);

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
};

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
        const assignedCourse = new assignedCourseDto(student_id, course_id, course_name, prof_id, status, max_hours);
        const newCourse = new courseDto(course_id, course_name);

        //add and assign new course
        const addingCourse = await addCourse(newCourse);
        if (addingCourse.success) {
            console.log("Added the new course in the course database");
        }
        else{
            console.log("This course is already added in the course database");
        }
        const assigningCourse = await assignCourseToStudent(assignedCourse);
        console.log(assigningCourse)

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
            const newReport = new reportDto(assigned_course_id.result[0].ID, date, "new report", year, month)
            const createNewReport = await createReport(newReport);
            if(!createNewReport.success){
                console.log(createNewReport);
                res.status(422).json(createNewReport);

            }
            else{
            res.json(createNewReport);
            }
        }
        else {
                console.log(assigningCourse); 
        }

    }
    catch{
        res.status(500).json("Internal server error!");
        console.error("May be invalid input, internal server error");
    }
}

//updating assigned courses
const updateCourseRoute = async function (req, res)  {
    try{
        //params and body
        // const student_id = req.body.student_id;
        const id = req.body.id; 
        // const prof_id = req.body.prof_id;
        // const course_id = req.body.course_id;
        // const status = req.body.status;
        // const max_hours = req.body.max_hours;
        // const course_name = req.body.course_name;
        // const month = req.body.month;
        // const year = req.body.year;
        const submit_status = req.body.submit_status;

        const assigned_id = parseInt(id);

        //dto
        // const assignedCourse = new assignedCourseDto(course_id, course_name, prof_id, status, max_hours, submit_status);
        // const newCourse = new courseDto(course_id, course_name);

        //add and assign new course
        // const addingCourse = await addCourse(newCourse);
        // if (addingCourse.success) {
        //     console.log("Added the new course in the course database");
        // }
        // else{
        //     console.log("This course is already added in the course database");
        // }
        const updatingCourse = await updateAssignedCourse(submit_status, assigned_id);
        console.log(updatingCourse)

        if (updatingCourse.success) {
            //if assigned a course, create a new report
            //get assigned_course_id
            // const assigned_course_id = await getAssignedCourseId(course_id)
            // if(!assigned_course_id.success){
            //     console.log(assigned_course_id);
            //     res.status(500).json(assigningCourse);
            // }
            // // console.log(assigned_course_id);
            // const date = new Date();
            // const newReport = new reportDto(assigned_course_id.result[0].ID, date, "new report", year, month)
            // const createNewReport = await createReport(newReport);
            // if(!createNewReport.success){
            //     console.log(createNewReport);
            //     res.status(422).json(createNewReport);

            // }
            // else{
            res.json(updatingCourse);
            }
        // }
        else {
            res.status(422).json(updatingCourse);
        }

    }
    catch{
        res.status(500).json("Internal server error!");
        console.error("May be invalid input, internal server error");
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
    getAssignedCoursesBySubmitStatusRoute,
    getAssignedCoursesBySubmitStatusAndProfIdRoute,
    addCourseRoute,
    updateCourseRoute,
    deleteAssignedCourseByCourseIdRoute
};