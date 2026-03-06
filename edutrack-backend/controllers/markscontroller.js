const db = require("../config/db");

exports.saveMarks = (req, res) => {

  const { semester, subject, marksList } = req.body;

  const values = marksList.map(student => [
    student.name,
    semester,
    subject,
    student.marks
  ]);

  const sql = `
    INSERT INTO marks (student_name, semester, subject, marks)
    VALUES ?
  `;

  db.query(sql, [values], (err, result) => {

    if (err) {
      console.log(err);
      return res.status(500).json({ message: "Database error" });
    }

    res.status(200).json({ message: "Marks saved successfully" });
  });
};