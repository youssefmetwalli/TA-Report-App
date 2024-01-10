const express = require('express');
const router = express.Router();
const {
    createReportRoute,
    getReportByReportIdRoute,
    getReportsByAssignedIdRoute,
    deleteReportRoute
} = require('../controllers/reportManagerController')

router.post('/add', createReportRoute);
router.post('/getall', getReportsByAssignedIdRoute);
router.post('/get', getReportByReportIdRoute);
router.delete('/delete', deleteReportRoute);

module.exports = router;