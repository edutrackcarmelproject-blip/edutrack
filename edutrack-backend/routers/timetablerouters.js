const express = require("express");
const router = express.Router();
const db = require("../config/db");

router.post("/add", (req, res) => {
  const { semester, subject, day, time } = req.body;

  if (!semester || !subject || !day || !time) {
    return res.status(400).json({ message: "semester, subject, day and time are required" });
  }

  const sql = "INSERT INTO timetable (semester, subject, day, time) VALUES (?, ?, ?, ?)";

  db.query(sql, [semester, subject, day, time], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(201).json({
      message: "Timetable added successfully",
      timetable_id: result.insertId
    });
  });
});

router.get("/all", (req, res) => {
  const { semester, day } = req.query;

  let sql = "SELECT * FROM timetable WHERE 1=1";
  const params = [];

  if (semester) {
    sql += " AND semester = ?";
    params.push(semester);
  }

  if (day) {
    sql += " AND day = ?";
    params.push(day);
  }

  sql += " ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), time ASC";

  db.query(sql, params, (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    return res.status(200).json(result);
  });
});

module.exports = router;
