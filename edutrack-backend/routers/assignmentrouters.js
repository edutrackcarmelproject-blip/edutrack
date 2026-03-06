const express = require("express");
const router = express.Router();
const assignmentController = require("../controllers/assignmentcontroller");

// POST - Add Assignment
router.post("/add", assignmentController.addAssignment);

// GET - All Assignments
router.get("/", assignmentController.getAssignments);

// GET - Filter by semester & subject
router.get("/filter", assignmentController.getFilteredAssignments);

module.exports = router;
