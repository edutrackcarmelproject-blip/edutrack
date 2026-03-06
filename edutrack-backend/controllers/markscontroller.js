const db = require("../config/db");

exports.saveMarks = (req, res) => {
  const { semester, subject, marksList } = req.body;

  if (!semester || !subject || !Array.isArray(marksList) || marksList.length === 0) {
    return res.status(400).json({ message: "semester, subject and marksList[] are required" });
  }

  const invalid = marksList.find((student) => !student.name || student.marks === undefined || student.marks === null);
  if (invalid) {
    return res.status(400).json({ message: "Each marksList item needs name and marks" });
  }

  const values = marksList.map((student) => [student.name, semester, subject, student.marks]);

  const sql = `
    INSERT INTO marks (student_name, semester, subject, marks)
    VALUES ?
  `;

  db.query(sql, [values], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(201).json({
      message: "Marks saved successfully",
      inserted_count: result.affectedRows
    });
  });
};

exports.getMarks = (req, res) => {
  const { semester, subject, student_name } = req.query;

  let sql = "SELECT * FROM marks WHERE 1=1";
  const params = [];

  if (semester) {
    sql += " AND semester = ?";
    params.push(semester);
  }
  if (subject) {
    sql += " AND subject = ?";
    params.push(subject);
  }
  if (student_name) {
    sql += " AND student_name = ?";
    params.push(student_name);
  }

  sql += " ORDER BY mark_id DESC";

  db.query(sql, params, (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(200).json(rows);
  });
};
