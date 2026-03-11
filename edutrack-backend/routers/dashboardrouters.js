const express = require("express");
const router = express.Router();

const dashboardController = require("../controllers/dashboardcontroller");
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.get("/teacher", verifyToken, requireRole("teacher"), dashboardController.getTeacherDashboard);
router.get("/student", verifyToken, requireRole("student"), dashboardController.getStudentDashboard);

module.exports = router;
