const express = require("express");
const router = express.Router();

const adminController = require("../controllers/admincontroller");
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.use(verifyToken, requireRole("admin"));

router.post("/add-teacher", adminController.addTeacher);
router.put("/teachers/:id", adminController.updateTeacher);
router.delete("/teachers/:id", adminController.deleteTeacher);

router.post("/add-student", adminController.addStudent);
router.put("/students/:id", adminController.updateStudent);
router.delete("/students/:id", adminController.deleteStudent);
router.post("/approve-student", adminController.approveStudent);

router.post("/add-subject", adminController.addSubject);
router.post("/assign-teacher-subject", adminController.assignTeacherSubject);

router.get("/users", adminController.getUsers);
router.get("/subjects", adminController.getSubjects);
router.get("/attendance", adminController.getAttendance);
router.get("/marks", adminController.getMarks);
router.get("/performance", adminController.getPerformance);

module.exports = router;
