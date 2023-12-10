const express = require("express");
const app = express();
const coursesRoutes = require('./routes/courseRoutes')
const db = require('./services/dbService');

const port = 3000;

// app.use(bodyParser);
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(express.json());

//get all users
app.get("/", (req, res) => {
  console.dir(req.body);
  db.DB.query("SELECT * FROM Users", (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

/* Error handler middleware */
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({ message: err.message });
  return;
});


//get all assigned courses BY student_id and assign new course. report is created automatically
//restrictions: course_id, student_id, prof_id must already be known in the database tables
app.use('/courses', coursesRoutes);




//add new shift
app.post("/shift/add", (req, res) => {
  console.dir(req.body);
  db.DB.query(`INSERT INTO Shifts (date, start_time, end_time, break_time, working_hours, work_category_id, report_id) VALUES (${req.body.date}, ${req.body.start_time}, ${req.body.end_time}, ${req.body.break_time}, ${req.body.working_hours}, ${req.body.work_category_id}, ${req.body.report_id})`, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//update shift given shift_id
app.put("/shift/update", (req, res) => {
  console.dir(req.body);
  db.DB.query(`UPDATE Shifts SET date = ${req.body.date}, start_time = ${req.body.start_time}, end_time = ${req.body.end_time}, working_hours = ${req.body.working_hours}, work_category_id = ${req.body.work_category_id} WHERE id = ${req.body.id}`, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//delete shift given shift_id
app.delete("/shift/delete", (req, res) => {
  console.dir(req.body);
  db.DB.query(`DELETE FROM Shifts WHERE id = ${req.body.id}`, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//submit report

app.listen(port, () => {
  console.log(`TA Report app listening at http://localhost:${port}`);
});