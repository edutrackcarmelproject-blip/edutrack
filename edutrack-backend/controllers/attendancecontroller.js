const db = require("../config/db");

exports.saveAttendance = (req, res) => {
  const {
    attendance_date,
    semester,
    subject,
    present_students,
    absent_students
  } = req.body;

  if (!attendance_date || !semester || !subject || !Array.isArray(present_students) || !Array.isArray(absent_students)) {
    return res.status(400).json({
      message: "attendance_date, semester, subject, present_students[], absent_students[] are required"
    });
  }

  const sql = `
    INSERT INTO attendance
    (attendance_date, semester, subject, present_students, absent_students)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [attendance_date, semester, subject, JSON.stringify(present_students), JSON.stringify(absent_students)],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ message: "Database error" });
      }

      return res.status(201).json({
        message: "Attendance saved successfully",
        attendance_id: result.insertId
      });
    }
  );
};

exports.getAttendance = (req, res) => {
  const { semester, subject, attendance_date } = req.query;

  let sql = "SELECT * FROM attendance WHERE 1=1";
  const params = [];

  if (semester) {
    sql += " AND semester = ?";
    params.push(semester);
  }
  if (subject) {
    sql += " AND subject = ?";
    params.push(subject);
  }
  if (attendance_date) {
    sql += " AND attendance_date = ?";
    params.push(attendance_date);
  }

  sql += " ORDER BY attendance_date DESC, attendance_id DESC";

  db.query(sql, params, (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    const formatted = rows.map((row) => ({
      ...row,
      present_students: safeJsonParse(row.present_students),
      absent_students: safeJsonParse(row.absent_students)
    }));

    return res.status(200).json(formatted);
  });
};

function safeJsonParse(value) {
  try {
    return JSON.parse(value || "[]");
  } catch (error) {
    return [];
  }
}
