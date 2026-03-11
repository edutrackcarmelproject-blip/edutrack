const express = require("express");
const cors = require("cors");

const db = require("./config/db");
const authRouter = require("./routers/authrouters");
const adminRouter = require("./routers/adminrouters");
const teacherRouter = require("./routers/teacherrouters");
const studentRouter = require("./routers/studentrouters");
const dashboardRouter = require("./routers/dashboardrouters");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/api/health", (req, res) => {
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
