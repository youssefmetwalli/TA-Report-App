const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const coursesRoutes = require('./routes/reportRoutes')
const db = require('./services/dbService');
const courseService = require('./services/courseService');
const assignedCourseDto = require('./dto/assignedCoursesDto');
const courseDto = require ('./dto/coursesDto');

// DB_PASSWORD="12345"
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

// Add routes for Reports, Shifts, and Courses
// app.use(express.json())
app.post('/course', (req, res)  => {
  try{
      //params and body
      const student_id = req.body.student_id;
      const prof_id = req.body.prof_id;
      const course_id = req.body.course_id;
      const status = req.body.prof_id;
      const max_hours = req.body.max_hours;
      const course_name = req.body.course_name;
      const quarter = req.body.quarter;
      const semester = req.body.semester

      //dto
      const assignedCourse = new assignedCourseDto(student_id, course_id, prof_id, status, max_hours);
      const newCourse = new courseDto(course_id, course_name, quarter, semester);

      //add and assign new course
      const addingCourse = courseService.addCourse(newCourse);
      const assigningCourse = courseService.assignCourseToStudent(assignedCourse);

      if (addingCourse.success) {
          res.json(addingCourse);
          if (assigningCourse.success) {
              res.json(assigningCourse);
          } else {
              res.status(500).json(addingCourse); // Adjust the status code as needed
          }
      } else {
          res.status(500).json(addingCourse); // Adjust the status code as needed
      }

  }
  catch{
      console.error(error);
      res.status(500).json({
          success: false,
          message: "Internal Server Error",
      });
    }
  });
// app.use('/shifts', shiftsRoutes);
app.use('/courses', coursesRoutes);

//get all assigned courses => courses that have reports BY student_id
app.get("/courses/assigned", (req, res) => {
  console.dir(req.body);
  db.DB.query("SELECT * FROM AssignedCourses WHERE student_id= ?",req.body.student_id, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//get reports given assigned course id
app.get("/courses/report", (req, res) => {
  console.dir(req.body);
  db.DB.query(`SELECT * FROM Report WHERE assigned_course_id=${req.body.assigned_id}`, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//get shifts with report_id

//add new course and  assigned course
//restrictions: course_id, student_id, prof_id must already be known in the database tables
app.post("/courses/add", (req, res) => {
  console.dir(req.body);

  const insertQuery = "INSERT INTO Courses (Name, Quarter, Semester, ID) VALUES (?, ?, ?, ?)";
  const values = [req.body.name, req.body.quarter, req.body.semester, req.body.id];

  db.DB.query(insertQuery, values, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "Internal Server Error" });
      return;
    }

    res.json({ result: results });
  });
});


app.post("/courses/assign", (req, res) => {
  console.dir(req.body);

  const insertQuery = "INSERT INTO AssignedCourses (student_id, course_id, prof_id, status, max_hours) VALUES (?, ?, ?, ?, ?)";
  const values = [req.body.student_id, req.body.course_id, req.body.prof_id, req.body.status, req.body.max_hours];

  db.DB.query(insertQuery, values, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).json({ error: "Internal Server Error" });
      return;
    }

    res.json({ result: results });
  });
});


//create new report
app.post("/report/create", (req, res) => {
  console.dir(req.body);
  db.DB.query(`INSERT INTO Report (assigned_course_id, report_date, report_description) VALUES (${req.body.assigned_id}, ${req.body.report_date}, ${req.body.prof_id}, ${req.body.report_description})`, (err, results) =>{
    if (err){
      throw err;
    }
    res.json({result:results});
  });
})

//delete report

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