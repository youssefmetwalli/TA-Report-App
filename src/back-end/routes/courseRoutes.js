const express = require('express');
const router = express.Router();
const {
    getAllAssignedCoursesRoute,
    getAssignedCoursesBySubmitStatusRoute,
    getAssignedCoursesBySubmitStatusAndProfIdRoute,
    addCourseRoute,
    updateCourseRoute,
    deleteAssignedCourseByCourseIdRoute
} = require('../controllers/courseManagerController')

router.post('/add', addCourseRoute);
router.post('/getall', getAllAssignedCoursesRoute);
router.post('/submitted/getall', getAssignedCoursesBySubmitStatusRoute);
router.post('/faculty/submitted/get', getAssignedCoursesBySubmitStatusAndProfIdRoute);
router.put('/update', updateCourseRoute);
router.delete('/delete', deleteAssignedCourseByCourseIdRoute)

module.exports = router;