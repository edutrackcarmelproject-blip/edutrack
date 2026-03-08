const express = require("express");
const router = express.Router();

const adminController = require("../controllers/admincontroller");
const { verifyToken, requireRole } = require("../middleware/authmiddleware");

router.use(verifyToken, requireRole("admin"));

router.post("/add-teacher", adminController.addTeacher);
router.post("/add-student", adminController.addStudent);
router.post("/approve-student", adminController.approveStudent);
router.post("/add-subject", adminController.addSubject);
router.post("/assign-teacher-subject", adminController.assignTeacherSubject);
router.get("/users", adminController.getUsers);
router.get("/subjects", adminController.getSubjects);

module.exports = router;
