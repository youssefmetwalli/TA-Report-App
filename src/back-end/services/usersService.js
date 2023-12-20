// services/usersService.js
const UsersDto = require('../dto/usersDto');
const db = require('./dbService');

  //add user
  function addUser(usersDto){
    return new Promise((resolve, reject) =>{
      //check if the user already exists
      if (this.userExists(usersDto.ID, usersDto.username)){
        console.log("the user already exists");
        return 1;
      }
      // Insert user into the database
      const query = 'INSERT INTO Users (ID, username, password, role, status) VALUES (?, ?, ?, ?, ?)';
      const values = [usersDto.ID, usersDto.username, usersDto.password, usersDto.role, usersDto.status];

      db.query(query, values, (error, results) => {
        if (error) {
          console.error(error);
          console.log({ error: 'Internal Server Error' });
          reject(error);
          return;
        }

        console.log({ message: 'User added successfully' });
        resolve(results)
        })
      });
  }

  // check if the user exists
  function userExists(id, username) {
    return new Promise((resolve, reject)=>{
      try {
        db.DB.query(
          'SELECT * FROM Users WHERE ID = ?',
          [id, username],
          (error, results) => {
            if (error) {
              reject({success: false, message: `Internal server error, ${error}`});
              return;
            }
  
            resolve({success: true, result: results});
          });
      } catch (error) {
        console.error('Error checking user existence:', error.message);
        reject({success: false, message: `Internal server error, ${error}`}); // Assume the user doesn't exist in case of an error
      }
    });
  }

  //TODO login auth
  function loginUser(id, password) {
    return new Promise((resolve, reject)=>{
      try {
        // Use a prepared statement to check if the user with the provided ID and password exists
        db.DB.query(
          'SELECT * FROM Users WHERE ID = ? AND password = ?',
          [id, password], (error, results) => {
            if (error) {
              reject({success: false, message: `Internal server error, ${error}`});
              return;
            }
  
            resolve({success: true, result: results});
            console.log(results);
          });
      } catch (error) {
        console.error('Error checking login:', error.message);
        reject({success: false, message: `Internal server error, ${error}`}); 
      }
    })
    
  }


//return student status given the student_id

module.exports = {loginUser, userExists};
