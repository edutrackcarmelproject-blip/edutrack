const express = require("express");
const cors = require("cors");

codex/assist-with-backend-implementation-zaxooy
const db = require("./config/db");
const authRouter = require("./routers/authrouters");
const adminRouter = require("./routers/adminrouters");
const teacherRouter = require("./routers/teacherrouters");
const studentRouter = require("./routers/studentrouters");
const assignmentRoutes = require("./routers/assignmentrouters");
const announcementRoutes = require("./routers/announcementrouters");
const attendanceRouters = require("./routers/attendancerouters");
const marksRouter = require("./routers/marksrouters");
const timetableRouter = require("./routers/timetablerouters");
const assignmentMarksRouter = require("./routers/assignmentmarkrouters");
const authRouter = require("./routers/authrouters");
 main
const dashboardRouter = require("./routers/dashboardrouters");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/health", (req, res) => {
codex/assist-with-backend-implementation-zaxooy
  res.status(200).json({ success: true, data: { status: "ok" } });
});

app.use("/api/auth", authRouter);
app.use("/api/admin", adminRouter);
app.use("/api/student", studentRouter);
app.use("/api", teacherRouter);
app.use("/api/dashboard", dashboardRouter);

app.use((req, res) => {
  res.status(404).json({ success: false, message: "Route not found" });
});

const PORT = Number(process.env.PORT || 5000);

async function startServer() {
  try {
    await db.initializeDatabase();
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Failed to initialize database:", error.message || error);
    process.exit(1);
  }
}

startServer();

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
 main
