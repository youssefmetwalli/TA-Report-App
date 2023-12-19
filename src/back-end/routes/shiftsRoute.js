const express = require('express');
const router = express.Router();
const {
    addShiftRoute,
    updateShiftRoute,
    getAllShiftsByReportIdRoute,
    deleteShiftByShiftIdRoute,
    deleteShiftsByReportIdRoute
} = require('../controllers/shiftsManagerController')

router.post('/add', addShiftRoute);
router.put('/update', updateShiftRoute);
router.get('/all', getAllShiftsByReportIdRoute);
router.delete('/delete', deleteShiftByShiftIdRoute);
router.delete('/delete/all', deleteShiftsByReportIdRoute);

module.exports = router;