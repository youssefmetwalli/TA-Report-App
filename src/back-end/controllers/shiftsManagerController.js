const {
    deleteShiftByShiftId,
    deleteShiftsByReportId,
    addNewShift,
    updateShift,
    getAllShiftsByReportId
} = require('../services/shiftService');
const shiftDto = require ('../dto/shiftsDto')

const {userExists} = require('../services/usersService');

//create shift
const addShiftRoute = async function(req, res) {
    try{
        const date = req.body.date;
        const start_time = req.body.start_time;
        const end_time = req.body.end_time;
        const break_time = req.body.break_time;
        const work_category = req.body.work_category;
        const report_id = req.body.report_id;
        const student_id = req.body.student_id;
        const date_format = new Date(date);

        const student_status = (await userExists(student_id)).result; //Jp:1 or Int:0

        const newShift = new shiftDto(date_format, start_time, end_time, break_time, 0, work_category,report_id);
        const addingShift = await addNewShift(newShift, student_status);
        console.log(addingShift);
        if(!addingShift.success){
            res.status(422).json(addingShift);
        }
        else{res.json(addingShift);}
    }
    catch{
        console.log("could not add the new shift! ERROR");
        res.status(500).json({success:"false", message:"Similar work already exits"});
    }
};

//update shift
const updateShiftRoute = async function(req, res){
    try
    {
        const date = req.body.date;
        const start_time = req.body.start_time;
        const end_time = req.body.end_time;
        const break_time = req.body.break_time;
        const work_category = req.body.work_category;
        const report_id = req.body.report_id;
        const student_id = req.body.student_id;
        const shift_id = req.body.shift_id;
        const date_format = new Date(date);

        const student_status = await userExist(student_id); //Jp:1 or Int:0
        console.log(student_status);

        const newShift = new shiftDto(date_format, start_time, end_time, break_time, 0, work_category,report_id);
        const updatedShift = await updateShift(newShift, student_status, shift_id);
        if(!updatedShift.success){
            res.status(422).json(updatedShift);
        }
        else{res.json(updatedShift);}
    }
    catch
    {
        console.log("could not add the new shift! ERROR");
        res.status(500).json("Error updating the shift");
    }
}

//get all shifts
const getAllShiftsByReportIdRoute = async function(req, res){
    try{
        const report_id = req.body.report_id;
        const shifts = await getAllShiftsByReportId(report_id);
        if(shifts.success){
            res.json(shifts);
        }
        else{res.status(500).json(shifts);};
    }
    catch{
        console.log("error:: could not get all the reports by report_id");
        res.status(500).json("Internal server error");

    }
}

//delete shift by shift id
const deleteShiftByShiftIdRoute = async function (req, res){
    try{
        const shift_id = req.body.shift_id;
        const deleting = await deleteShiftByShiftId(shift_id);
        console.log(deleting);
        if(deleting.success){
            res.json(deleting);
        }
        else {res.status(500).json(deleting);};
    }
    catch{
        console.log("Internal server error, cannot delete the shift");
        res.status(500).json("Internal server error, cannot delete the shift");
    }
}

//delete shifts by report id
const deleteShiftsByReportIdRoute = async function (req, res){
    try{
        const report_id = req.body.report_id;
        const deleting = await deleteShiftsByReportId(report_id);
        if(deleting.success){
            res.json(deleting);
        }
        else {res.status(500).json(deleting);};
    }
    catch{
        console.log("Internal server error, cannot delete the shifts");
        res.status(500).json("Internal server error, cannot delete the shifts");
    }
}

module.exports = {
    addShiftRoute,
    updateShiftRoute,
    getAllShiftsByReportIdRoute,
    deleteShiftByShiftIdRoute,
    deleteShiftsByReportIdRoute
}