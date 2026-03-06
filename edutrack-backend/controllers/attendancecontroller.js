const db = require("../config/db");

exports.saveAttendance = (req, res) => {

  const {
    attendance_date,
    semester,
    subject,
    present_students,
    absent_students
  } = req.body;

  const sql = `
    INSERT INTO attendance
    (attendance_date, semester, subject, present_students, absent_students)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [
      attendance_date,
      semester,
      subject,
      JSON.stringify(present_students),
      JSON.stringify(absent_students)
    ],
    (err, result) => {

      if (err) {
        console.log(err);
        return res.status(500).json({ message: "Database error" });
      }

      res.status(200).json({ message: "Attendance saved successfully" });

    }
  );
};