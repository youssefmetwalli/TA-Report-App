const express = require("express");
const cors = require('cors');
const app = express();
const session = require('express-session'); 
const coursesRoutes = require('./routes/courseRoutes');
const shiftsRoutes = require('./routes/shiftsRoute');
const reportRoutes = require('./routes/reportRoutes');
const usersRoutes = require('./routes/usersRoute');
const db = require('./services/dbService');
const { loginRoute } = require("./controllers/usersManagerController");

//TODO add session to keep a user logged in: https://hackernoon.com/how-to-use-session-in-nodejs

const port = 3000;



// app.use(bodyParser);
app.use(
  express.urlencoded({
    extended: true,
  })
);
app.use(express.json());
// Use CORS middleware
app.use(cors());

// Add session middleware
app.use(session({
  secret: 'wakanda', // Secret key to sign the session ID cookie
  resave: false, // Do not save session if unmodified
  saveUninitialized: false, // Do not create session until something is stored
  // You can customize other options as needed
}));

/* Error handler middleware */
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({ message: err.message });
  return;
});

//USERS
/********/
app.use('/login', loginRoute);

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