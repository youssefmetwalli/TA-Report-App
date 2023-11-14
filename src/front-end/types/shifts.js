// shift type
//start_time(in 24:00 format), end_time(in 24:00 format), break_time in minutes


export const createShift = (date_time, start_time, end_time, break_time) => {
    // Convert time strings to Date objects for easier manipulation
    const startDate = new Date(`${date_time} ${start_time}`);
    const endDate = new Date(`${date_time} ${end_time}`);
  
    // Calculate shift hours in milliseconds
    const shiftMilliseconds = endDate - startDate - break_time * 60 * 1000;
  
    // Convert shift hours from milliseconds to hours
    const shift_hours = shiftMilliseconds / (60 * 60 * 1000);
  
    // Return an object with date and shift_hours properties
    return {
      date_time,
      start_time,
      end_time,
      break_time,
      shift_hours
    };
  };
  
  // Example usage
  export const shift = createShift('2023/12/31', '15:30', '15:30', 0);
  console.log(shift);
  