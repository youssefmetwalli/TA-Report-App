const express = require('express');
const router = express.Router();
const {
    getAllAssignedCoursesRoute,
    addCourseRoute,
    deleteAssignedCourseByCourseIdRoute
} = require('../controllers/courseManagerController')

router.post('/add', addCourseRoute);
router.get('/getAll', getAllAssignedCoursesRoute);
router.delete('/delete', deleteAssignedCourseByCourseIdRoute)

module.exports = router;