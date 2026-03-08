const express = require("express");
const router = express.Router();

const teacherController = require("../controllers/teachercontroller");
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.use(verifyToken, requireRole("teacher"));

router.post("/announcements", teacherController.createAnnouncement);
router.post("/assignments", teacherController.createAssignment);
router.post("/assignments/add", teacherController.createAssignment);
router.post("/attendance", teacherController.createAttendance);
router.post("/marks", teacherController.createMarks);
router.post("/timetable", teacherController.createTimetable);
router.post("/timetable/add", teacherController.createTimetable);

module.exports = router;
