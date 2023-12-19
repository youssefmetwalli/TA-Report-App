// services/usersService.js
const UsersDto = require('../dto/usersDto');
const db = require('./dbService');

class UsersManagerService {
  //add user
  addUser(usersDto){
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
      })
  };

  userExists(id, username) {
    try {
  
      // check if the user exists
      const [rows] = db.query(
        'SELECT * FROM Users WHERE ID = ? OR username = ?',
        [id, username]
      );

      // Return true if the user exists, false otherwise
      return rows.length > 0;
    } catch (error) {
      console.error('Error checking user existence:', error.message);
      return false; // Assume the user doesn't exist in case of an error
    }
  }

  //TODO login auth
  async loginUser(id, password) {
    try {
  
      // Use a prepared statement to check if the user with the provided ID and password exists
      const [rows] = await db.query(
        'SELECT * FROM Users WHERE ID = ? AND password = ?',
        [id, password]
      );

      // Return true if the user with the provided ID and password exists, false otherwise
      return rows.length > 0;
    } catch (error) {
      console.error('Error checking login:', error.message);
      return false; // Assume login fails in case of an error
    }
  }
}

//return student status given the student_id

module.exports = UsersManagerService;
