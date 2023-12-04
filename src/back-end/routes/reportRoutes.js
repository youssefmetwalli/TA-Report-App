const express = require('express');
const router = express.Router();
const {getAllCourses,
    getReportDataByAssignedId,
    addCourse } = require('../controllers/reportManagerController')

router.post('/:student_id', addCourse);
router.get('/:student_id', getAllCourses);

module.exports = router;