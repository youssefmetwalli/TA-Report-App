const db = require('./dbService');
const shiftsDto = require('../dto/shiftsDto'); // Adjust the path based on your project structure

class ShiftService {

  addNewShift(shiftDto) {
    return new Promise((resolve, reject) => {
      const query = 'INSERT INTO Shifts (date, start_time, end_time, break_time, working_hours, work_category_id, report_id) VALUES (?, ?, ?, ?, ?, ?, ?)';
    
      this.connection.query(
        query,
        [
          shiftDto.date,
          shiftDto.startTime,
          shiftDto.endTime,
          shiftDto.breakTime,
          shiftDto.workingHours,
          shiftDto.workCategoryId,
          shiftDto.report_id
        ],
        (error, results) => {
          if (error) {
            reject(error);
            return;
          }

          resolve(results);
        }
      );
    });
  }

  //update shift
  updateShift(shiftDto) {
    return new Promise((resolve, reject) => {
      const query = 'UPDATE Shifts SET date = ?, start_time = ?, end_time = ?, break_time = ?, working_hours = ?, work_category_id = ? WHERE id = ?';
    
      this.connection.query(
        query,
        [
          shiftDto.date,
          shiftDto.startTime,
          shiftDto.endTime,
          shiftDto.breakTime,
          shiftDto.workingHours,
          shiftDto.workCategoryId,
          shiftDto.id
        ],
        (error, results) => {
          if (error) {
            reject(error);
            return;
          }

          resolve(results);
        }
      );
    });
  }

  //delete shift by shift id
  deleteShift(shiftId) {
    return new Promise((resolve, reject) => {
      const query = 'DELETE FROM Shifts WHERE id = ?';
    
      this.connection.query(
        query,
        [shiftId],
        (error, results) => {
          if (error) {
            reject(error);
            return;
          }

          resolve(results);
        }
      );
    });
  }

  //delete shift by report id
  deleteShift(reportId) {
    return new Promise((resolve, reject) => {
      const query = 'DELETE FROM Shifts WHERE report_id = ?';
    
      this.connection.query(
        query,
        [reportId],
        (error, results) => {
          if (error) {
            reject(error);
            return;
          }

          resolve(results);
        }
      );
    });
  }

  closeConnection() {
    this.connection.end();
  }
}

//get shift by report_id
function getShiftByReportId(){
  
}

module.exports = ShiftService;


//usage
const shiftService = new ShiftService();

// Example shift details using ShiftsDto
const shiftDto = new shiftsDto('2023-11-20', '08:00:00', '16:00:00', '01:00:00', 7, 1, null);

shiftService.addNewShift(shiftDto)
  .then((result) => {
    console.log('Shift added successfully:', result);
  })
  .catch((error) => {
    console.error('Error adding shift:', error);
  })
  .finally(() => {
    shiftService.closeConnection(); // Close the database connection
  });
