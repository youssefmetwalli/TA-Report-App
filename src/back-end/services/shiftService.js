const db = require('./dbService');
const shiftsDto = require('../dto/shiftsDto'); // Adjust the path based on your project structure
require('dotenv').config();

NEEDS_TO_BREAK_HOURS = 6;
MAX_DAY_HOURS = 8;
MAX_WEEK_HOURS_JP = 40;
MAX_WEEK_HOURS_INT = 28;
MAX_MONTH_HOURS = 120;


//create a new shift
function addNewShift(shiftDto, student_status) {
  return new Promise(async(resolve, reject) => {
    try{
      //checks
      const isShiftValid = await checkShiftsValidity(shiftDto, student_status);
      if(isShiftValid){
        const query = 'INSERT INTO Shifts (date, start_time, end_time, break_time, working_hours, work_category_id, report_id) VALUES (?, ?, ?, ?, ?, ?, ?)';
      
        db.DB.query(
          query,
          [
            shiftDto.date,
            shiftDto.startTime,
            shiftDto.endTime,
            shiftDto.breakTime,
            shiftDto.workingHours,
            shiftDto.workCategoryId,
            shiftDto.reportId
          ],
          (error, results) => {
            if (error) {
              reject({
                success: false,
                error: error
              });
              return;
            }

            resolve({
              success: true,
              result: results
              });
          }
        );
      }
      else{
        console.log("the shift is not valid");
        resolve({success: false, message: "Wrong Input, Make sure the daily and weekly limits are ensured"});
      }
    }
    catch{
      console.log("error in service of adding the shift")
      reject({success: false, error: "Error 2: Internal server error"})
    }
    });
  }

  //update shift
  function updateShift(shiftDto, student_status, id) {
    return new Promise(async (resolve, reject) => {
      const query = 'UPDATE Shifts SET date = ?, start_time = ?, end_time = ?, break_time = ?, working_hours = ?, work_category_id = ? WHERE report_id = ? AND ID = ?';
      const isShiftValid = await checkShiftsValidity(shiftDto, student_status);
    
      if (isShiftValid)
      {
        db.DB.query(
        query,
        [
          shiftDto.date,
          shiftDto.startTime,
          shiftDto.endTime,
          shiftDto.breakTime,
          shiftDto.workingHours,
          shiftDto.workCategoryId,
          shiftDto.reportId,
          id
        ],
        (error, results) => {
          if (error) {
            reject({success: false, error: error});
          }

          resolve({success: true, result: results});
        }
      );
    }
    else {
      console.log("wrong input error!");
      reject({success: false, message: "Wrong Input, Make sure the daily and weekly limits are ensured"});
    }

    });
  }

  //delete shift by shift id
  function deleteShiftByShiftId(shift_id) {
    return new Promise(async (resolve, reject) => {
      const query = 'DELETE FROM Shifts WHERE ID = ?';
    
      db.DB.query(
        query,
        [shift_id],
        (error, results) => {
          if (error) {
            reject({success: false, message: `Internal server error, ${error}`});
            return;
          }

          resolve({success: true, result: results});
        }
      );
    });
  }

//delete shift by report id
function deleteShiftsByReportId(report_id) {
  return new Promise(async (resolve, reject) => {
    try{
      const query = 'DELETE FROM Shifts WHERE report_id = ?';
    
      db.DB.query(
        query,
        [report_id],
        (error, results) => {
          if (error) {
            console.log("ERROR: could not delete the shift")
            reject({
              success: false,
              error: error
            });
            return;
          }

          resolve({
            success: true,
            result: results
          });
        }
      );
    }
    catch{
      console.log("ERROR::S2:: internal server error");
      reject({
        success: false,
        error: error
      });
    }
  });
}

//get all shifts by report_id
function getAllShiftsByReportId(reportId){
  return new Promise(async (resolve, reject) => {
    try{
      const query = 'Select * FROM Shifts WHERE report_id = ?';
    
      db.DB.query(
        query,
        [reportId],
        (error, results) => {
          if (error) {
            console.log("ERROR: could not fetch all the shifts")
            reject({
              success: false,
              error: `internal server error: ${error}`
            });
          }

          resolve({
            success: true,
            result: results
          });
        }
      );
    }
    catch{
      console.log("ERROR::S3:: internal server error");
      reject({
        success: false,
        error: error
      });
    }
  });
}

//helper functions

//get week_total_work_hours
function getTotalWeekWorkHours(first_last_days){
  return new Promise(async (resolve, reject) =>{
    try{
      const query = "SELECT SUM(working_hours) AS sum FROM Shifts WHERE date >=? and date <= ?";
    const first_day = new Date(first_last_days.firstDayOfWeek);
    const last_day = new Date(first_last_days.lastDayOfWeek);
    db.DB.query(
      query, 
      [first_day, last_day], 
      (error, results)=>{
        if (error){
          console.log("error 1: couldn't to get total_work_hours_week", error);
          reject({
            success: false,
            error: error
          })
        }
        const total_week_work_hours= results[0].sum; //the sum before adding the current date working hours
        console.log("am here")
        console.log(total_week_work_hours)
        console.log(results)
        resolve({
          success: true,
          result: total_week_work_hours
        })
    })
    }
    catch{
      console.log("error 4: cant get toal hours of weekly work")
      reject({
        success: false,
        error: "error getting total hours "
      })
    }
  })
}

// Convert time strings to minutes
function timeToMinutes(time) {
  console.log(time);
  console.log(typeof time)
  const [hours, minutes] = time.split(':').map(Number);
  return hours * 60 + minutes;
}

//return first and last days of the week' dates
function firstLastDaysOfWeekDates(today_date){
  const firstDayOfWeek = new Date(today_date.getFullYear(), today_date.getMonth(), today_date.getDate() - today_date.getDay()+1).toISOString();
  const lastDayOfWeek = new Date(today_date.getFullYear(), today_date.getMonth(), today_date.getDate() + (7 - today_date.getDay())).toISOString();
  return {
    lastDayOfWeek:lastDayOfWeek,
    firstDayOfWeek:firstDayOfWeek
  }

}

//daily check: return workingHours if valid
function dailyHoursCheck(shiftDto){
  // new Promise((resolve, reject) =>{
    try{
      if(shiftDto.breakTime == null){
      shiftDto.breakTime = "00:00";
    }
  
    shiftDto.workingHours = (timeToMinutes(shiftDto.endTime) - timeToMinutes(shiftDto.startTime) - timeToMinutes(shiftDto.breakTime))/60;
    console.log(shiftDto.workingHours)
  
    if(shiftDto.workingHours > MAX_DAY_HOURS){
      console.log("no more than 8 hours of daily work!!"); 
      // reject ({success: false, message: "no more than 8 hours of daily work!!"});
      return false;
    }
    console.log(timeToMinutes(shiftDto.breakTime));
    if (shiftDto.workingHours > NEEDS_TO_BREAK_HOURS){
      if (timeToMinutes(shiftDto.breakTime)<60){
        console.log("needs a break!!"); 
        // reject ({success: false, message: "you need at least 1 hour break"});
        return false;
      }
    }
    // resolve ({success: true, working_hours: shiftDto.workingHours});
    return true;
  }
  catch{
    console.log("error 8: internal server error")
    return false;
  }
}

//weekly check: return true  if valid
function weeklyHoursCheck(week_total_work_hours, today_work_hours, student_status ){
  // return new Promise ((resolve, reject) => {
    if(student_status == process.env.JAPANESE){
      if((week_total_work_hours+today_work_hours) > MAX_WEEK_HOURS_JP){
        console.log(`cannot go beyond ${MAX_WEEK_HOURS_JP} hours a week!`);
        // return ({success: false, message:`cannot go beyond ${MAX_WEEK_HOURS_JP} hours a week!`});
        return false;
      }
    }
    else if(student_status==process.env.INTERNATIONAL){
      if(week_total_work_hours+today_work_hours > MAX_WEEK_HOURS_INT){
        console.log(`cannot go beyond ${MAX_WEEK_HOURS_INT} hours a week!`);
        // return ({success: false, message:`cannot go beyond ${MAX_WEEK_HOURS_INT} hours a week!`});
        return false;
      }
    }
    return true;
  }

//check shift validity for all
async function checkShiftsValidity(shiftDto, student_status){
  // if daily check is ok
  const day_check = dailyHoursCheck(shiftDto);
  if(day_check){
    const first_last_days = firstLastDaysOfWeekDates(shiftDto.date);
    const total_week_work_hours = await getTotalWeekWorkHours(first_last_days);

    if(total_week_work_hours.success){
      const week_check = weeklyHoursCheck(total_week_work_hours.result,shiftDto.workingHours, student_status);
      return week_check; //return true if valid
    }
    console.log("error 9: internal server error while getting total week hours")
    return false;
  }
  return false;
}

module.exports = {
  deleteShiftByShiftId,
  deleteShiftsByReportId,
  addNewShift,
  updateShift,
  getAllShiftsByReportId
}

