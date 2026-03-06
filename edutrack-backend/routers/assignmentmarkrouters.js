const express = require("express");
const router = express.Router();

const assignmentMarksController = require("../controllers/assignmentmarkscontroller");

router.post("/add", assignmentMarksController.addAssignmentGrade);
router.get("/", assignmentMarksController.getAssignmentGrades);

module.exports = router;
