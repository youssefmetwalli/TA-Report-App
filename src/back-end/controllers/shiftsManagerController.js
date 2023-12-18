const {
    deleteShiftByShiftId,
    deleteShiftsByReportId,
    addNewShift,
    updateShift,
    getAllShiftsByReportId
} = require('../services/shiftService');
const shiftDto = require ('../dto/shiftsDto')

//create shift
const addShiftRoute = async function(req, res) {
    try{
        const date = req.body.date;
        const start_time = req.body.start_time;
        const end_time = req.body.end_time;
        const break_time = req.body.break_time;
        const work_category_id = req.body.work_category_id;
        const report_id = req.body.report_id;
        const student_status = req.body.student_status //Jp or Int
        const date_format = new Date(date);

        const newShift = new shiftDto(date_format, start_time, end_time, break_time, 0, work_category_id,report_id);
        console.log(newShift);
        const addingShift = await addNewShift(newShift, student_status);
        if(!addingShift.success){
            res.status(422).json(addingShift);
        }
        else{res.json(addingShift);}
    }
    catch{
        console.log("could not add the new shift! ERROR");
    }
}

//update shift [put]

module.exports = {
    addShiftRoute
}