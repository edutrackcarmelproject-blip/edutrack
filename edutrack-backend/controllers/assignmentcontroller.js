const Assignment = require("../models/assignmentmodel");

// Add Assignment (Teacher)
exports.addAssignment = (req, res) => {
  const { semester, subject, assignment_title, description, due_date } = req.body;

  if (!semester || !subject || !assignment_title || !description || !due_date) {
    return res.status(400).json({ message: "All fields are required" });
  }

  Assignment.createAssignment(req.body, (err, result) => {
    if (err) {
      console.log(err);
      return res.status(500).json({ message: "Database error" });
    }

    res.status(201).json({ message: "Assignment added successfully" });
  });
};


// Get All Assignments
exports.getAssignments = (req, res) => {
  Assignment.getAllAssignments((err, result) => {
    if (err) {
      return res.status(500).json({ message: "Database error" });
    }

    res.json(result);
  });
};


// Filter by Semester & Subject
exports.getFilteredAssignments = (req, res) => {
  const { semester, subject } = req.query;

  if (!semester || !subject) {
    return res.status(400).json({ message: "Semester and Subject required" });
  }

  Assignment.getByFilter(semester, subject, (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Database error" });
    }

    res.json(result);
  });
};
