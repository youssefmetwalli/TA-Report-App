const express = require('express');
const router = express.Router();
const {
    loginRoute
} = require('../controllers/usersManagerController')

router.post('/login', loginRoute);
// router.get('/getall', getReportsByAssignedIdRoute);
// router.get('/get', getReportByReportIdRoute);
// router.delete('/delete', deleteReportRoute);

module.exports = router;