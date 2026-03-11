const express = require("express");
const router = express.Router();

const studentController = require("../controllers/studentcontroller");
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.use(verifyToken, requireRole("student"));

router.get("/subjects", studentController.getSubjects);
router.get("/announcements", studentController.getAnnouncements);
router.get("/assignments", studentController.getAssignments);
router.get("/attendance", studentController.getAttendance);
router.get("/marks", studentController.getMarks);
router.get("/timetable", studentController.getTimetable);

module.exports = router;
