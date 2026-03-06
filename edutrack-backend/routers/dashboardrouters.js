const express = require("express");
const router = express.Router();

const dashboardController = require("../controllers/dashboardcontroller");

router.get("/teacher", dashboardController.getTeacherDashboard);
router.get("/student", dashboardController.getStudentDashboard);

module.exports = router;
