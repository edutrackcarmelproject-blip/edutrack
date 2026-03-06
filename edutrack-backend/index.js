const express = require("express");
const cors = require("cors");

const assignmentRoutes = require("./routers/assignmentrouters");
const announcementRoutes = require("./routers/announcementrouters");
const attendanceRouters = require("./routers/attendancerouters");
const marksRouter = require("./routers/marksrouters");
const timetableRouter = require("./routers/timetablerouters");
const assignmentMarksRouter = require("./routers/assignmentmarkrouters");
const authRouter = require("./routers/authrouters");
const dashboardRouter = require("./routers/dashboardrouters");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.use("/api/auth", authRouter);
app.use("/api/dashboard", dashboardRouter);
app.use("/api/announcement", announcementRoutes);
app.use("/api/assignments", assignmentRoutes);
app.use("/api/attendance", attendanceRouters);
app.use("/api/marks", marksRouter);
app.use("/api/timetable", timetableRouter);
app.use("/api/assignment-marks", assignmentMarksRouter);

const PORT = Number(process.env.PORT || 5000);
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
