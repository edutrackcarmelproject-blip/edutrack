const db = require("../config/db");

// Create Assignment
exports.createAssignment = (data, callback) => {
  const sql = `
    INSERT INTO assignments
    (semester, subject, assignment_title, description, due_date)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [
      data.semester,
      data.subject,
      data.assignment_title,
      data.description,
      data.due_date
    ],
    callback
  );
};

// Get All Assignments
exports.getAllAssignments = (callback) => {
  const sql = "SELECT * FROM assignments ORDER BY due_date ASC";
  db.query(sql, callback);
};

// Get Assignments by Semester & Subject
exports.getByFilter = (semester, subject, callback) => {
  const sql = `
    SELECT * FROM assignments
    WHERE semester = ? AND subject = ?
    ORDER BY due_date ASC
  `;
  db.query(sql, [semester, subject], callback);
};
