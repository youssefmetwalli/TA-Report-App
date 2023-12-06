const express = require('express');
const router = express.Router();
const {getAllAssignedCoursesRoute,
    addCourseRoute } = require('../controllers/reportManagerController')

router.post('/:student_id', addCourseRoute);
router.get('/assigned/route', getAllAssignedCoursesRoute);

module.exports = router;