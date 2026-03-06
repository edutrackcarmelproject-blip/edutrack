const db = require("../config/db");

exports.addAssignmentGrade = (req, res) => {
  const { semester, subject, assignment, student, marks, feedback } = req.body;

  if (!semester || !subject || !assignment || !student || marks === undefined || marks === null) {
    return res.status(400).json({
      message: "semester, subject, assignment, student and marks are required"
    });
  }

  const sql = `
    INSERT INTO assignment_grades
    (semester, subject, assignment, student, marks, feedback)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [semester, subject, assignment, student, marks, feedback || null], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(201).json({
      message: "Assignment graded successfully",
      grade_id: result.insertId
    });
  });
};

exports.getAssignmentGrades = (req, res) => {
  const { semester, subject, assignment, student } = req.query;

  let sql = "SELECT * FROM assignment_grades WHERE 1=1";
  const params = [];

  if (semester) {
    sql += " AND semester = ?";
    params.push(semester);
  }
  if (subject) {
    sql += " AND subject = ?";
    params.push(subject);
  }
  if (assignment) {
    sql += " AND assignment = ?";
    params.push(assignment);
  }
  if (student) {
    sql += " AND student = ?";
    params.push(student);
  }

  sql += " ORDER BY assignment_grade_id DESC";

  db.query(sql, params, (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(200).json(rows);
  });
};
