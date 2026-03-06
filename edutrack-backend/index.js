const express = require("express");
const cors = require("cors");

const assignmentRoutes = require("./routers/assignmentrouters");
const announcementRoutes = require("./routers/announcementrouters");
const attendanceRouters = require("./routers/attendancerouters");
const marksRouter = require("./routers/marksrouters");
const timetableRouter = require("./routers/timetablerouters");
const assignmentMarksRouter = require("./routers/assignmentmarkrouters");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/announcement", announcementRoutes);
app.use("/api/assignments", assignmentRoutes);
app.use("/api/attendance", attendanceRouters);
app.use("/api/marks", marksRouter);
app.use("/api/timetable", timetableRouter);
app.use("/api/assignment-marks", assignmentMarksRouter);
app.listen(5000, () => {
  console.log("Server running on port 5000");
});