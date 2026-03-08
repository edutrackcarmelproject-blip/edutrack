const express = require("express");
const router = express.Router();

const dashboardController = require("../controllers/dashboardcontroller");
codex/assist-with-backend-implementation-zaxooy
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.get("/teacher", verifyToken, requireRole("teacher"), dashboardController.getTeacherDashboard);
router.get("/student", verifyToken, requireRole("student"), dashboardController.getStudentDashboard);
router.get("/teacher", dashboardController.getTeacherDashboard);
router.get("/student", dashboardController.getStudentDashboard);
main

module.exports = router;
