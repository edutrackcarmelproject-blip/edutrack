const express = require("express");
const router = express.Router();

const attendanceController = require("../controllers/attendancecontroller");

router.post("/", attendanceController.saveAttendance);
router.get("/", attendanceController.getAttendance);

module.exports = router;
