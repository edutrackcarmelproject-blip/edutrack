const express = require("express");
const router = express.Router();
const db = require("../config/db");

/// Add assignment grade
router.post("/add", (req, res) => {

  const { semester, subject, assignment, student, marks, feedback } = req.body;

  const sql = `
  INSERT INTO assignment_grades
  (semester, subject, assignment, student, marks, feedback)
  VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [semester, subject, assignment, student, marks, feedback],
    (err, result) => {

      if (err) {
        console.log(err);
        return res.status(500).json(err);
      }

      res.json({ message: "Assignment graded successfully" });

    }
  );

});

module.exports = router;