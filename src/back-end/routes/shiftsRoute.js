const express = require('express');
const router = express.Router();
const {
    addShiftRoute
} = require('../controllers/shiftsManagerController')

router.post('/add', addShiftRoute);
// router.get('/getAll', getAllAssignedCoursesRoute);
// router.delete('/delete', deleteAssignedCourseByCourseIdRoute)

module.exports = router;