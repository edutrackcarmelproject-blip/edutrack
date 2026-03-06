const express = require("express");
const router = express.Router();

const attendanceController = require("../controllers/attendancecontroller");

// POST /api/attendance
router.post("/", attendanceController.saveAttendance);

module.exports = router;