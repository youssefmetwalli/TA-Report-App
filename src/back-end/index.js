const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const reportRoutes = require('./routes/reportRoutes')

// DB_PASSWORD="12345"
const port = 3000;
app.use(express.json());
app.use(
  express.urlencoded({
    extended: true,
  })
);

app.get("/", (req, res) => {
  res.json({ message: "ok" });
});

/* Error handler middleware */
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({ message: err.message });
  return;
});

// Add routes for Reports, Shifts, and Courses
app.use('/reports', reportRoutes);
// app.use('/shifts', shiftsRoutes);
// app.use('/courses', coursesRoutes);

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});