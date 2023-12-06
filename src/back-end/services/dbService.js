const mysql = require('mysql');
const config = require('../config');

// async function query(sql, params) {
  const DB =  mysql.createConnection(config.db);
  // const [results, ] = await connection.execute(sql, params);
  DB.connect((err)=>{
    if (err){
      throw err;
    }
    console.log("mySQL connected.......")
  });

  // return results;
// }

module.exports = {
  DB
}