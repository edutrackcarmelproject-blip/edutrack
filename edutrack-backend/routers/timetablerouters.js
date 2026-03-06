const express = require("express");
const router = express.Router();
const db = require("../config/db");

/// Add timetable
router.post("/add", (req, res) => {

  const { semester, subject, day, time } = req.body;

  const sql =
    "INSERT INTO timetable (semester, subject, day, time) VALUES (?, ?, ?, ?)";

  db.query(sql, [semester, subject, day, time], (err, result) => {

    if (err) {
      console.log(err);
      return res.status(500).json(err);
    }

    res.json({ message: "Timetable added successfully" });
  });

});


/// Get timetable
router.get("/all", (req, res) => {

  const sql = "SELECT * FROM timetable";

  db.query(sql, (err, result) => {

    if (err) {
      console.log(err);
      return res.status(500).json(err);
    }

    res.json(result);
  });

});

module.exports = router;