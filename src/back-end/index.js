const express = require("express");
const app = express();
const coursesRoutes = require('./routes/courseRoutes');
const shiftsRoutes = require('./routes/shiftsRoute');
const reportRoutes = require('./routes/reportRoutes');
const usersRoutes = require('./routes/usersRoute');
const db = require('./services/dbService');
const { loginRoute } = require("./controllers/usersManagerController");

const port = 3000;

// app.use(bodyParser);
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(express.json());

//get all users
// app.get("/", (req, res) => {
//   console.dir(req.body);
//   db.DB.query("SELECT * FROM Users", (err, results) =>{
//     if (err){
//       throw err;
//     }
//     res.json({result:results});
//   });
// })

/* Error handler middleware */
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({ message: err.message });
  return;
});

//USERS
/********/
app.use('/', loginRoute);

//get all assigned courses BY student_id and assign new course. report is created automatically
//restrictions:  student_id, prof_id must already be known in the database tables
app.use('/courses', coursesRoutes);

//SHIFTS
/********/
app.use('/shifts', shiftsRoutes);

//REPORT
/********/
app.use('/reports', reportRoutes);
//submit report

app.listen(port, () => {
  console.log(`TA Report app listening at http://localhost:${port}`);
});