const ReportsDto = require("../dto/reportsDto");
const{
    createReport,
    deleteReportById,
    getReportByReportId,
    getReportsByAssignedId
} = require("../services/courseService");


//create report
const createReportRoute = async function (req, res){
    try{
        const assigned_course_id = req.body.assigned_course_id; //change to course_id
        const report_date = req.body.report_date;
        const report_description = req.body.report_description;
        const newReport = new ReportsDto(assigned_course_id, report_date, report_description);
        const creatingReport = await createReport(newReport);

        if (creatingReport.success) {
            res.json(creatingReport);
        } else {
            res.status(500).json(creatingReport); // Adjust the status code as needed
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

//get report data given the report_id
const getReportByReportIdRoute =  async function (req, res) {
    try {
        const report_id = req.body.report_id;
        const result = await getReportByReportId(report_id);
        
        if (result.success) {
            res.json(result);
        } else {
            res.status(500).json(result); 
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

// get reports by assigned course id
const getReportsByAssignedIdRoute = async function(req, res){
    try{
        const assigned_course_id = req.body.assigned_course_id;
        const result = await getReportsByAssignedId(assigned_course_id);

        if (result.success) {
            res.json(result);
        } else {
            res.status(500).json(result); 
        }
    }
    catch(error){
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

const deleteReportRoute = async function(req, res){
    try{
        const report_id = req.body.report_id;
        const result = await deleteReportById(report_id);

        if (result.success) {
            res.json(result);
        } else {
            res.status(500).json(result); 
        }
    }
    catch(error){
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Internal Server Error",
        });
    }
}

module.exports = {
    getReportByReportIdRoute,
    getReportsByAssignedIdRoute,
    createReportRoute,
    deleteReportRoute
}