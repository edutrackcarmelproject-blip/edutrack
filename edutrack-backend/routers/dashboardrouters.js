const express = require("express");
const router = express.Router();

const dashboardController = require("../controllers/dashboardcontroller");
 codex/fix-high-priority-issues-from-codex-review

codex/assist-with-backend-implementation-zaxooy
 codex/assist-with-backend-implementation-zaxooy
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.get("/teacher", verifyToken, requireRole("teacher"), dashboardController.getTeacherDashboard);
router.get("/student", verifyToken, requireRole("student"), dashboardController.getStudentDashboard);
 codex/fix-high-priority-issues-from-codex-review

router.get("/teacher", dashboardController.getTeacherDashboard);
router.get("/student", dashboardController.getStudentDashboard);
main
 codex/assist-with-backend-implementation-zaxooy

module.exports = router;
