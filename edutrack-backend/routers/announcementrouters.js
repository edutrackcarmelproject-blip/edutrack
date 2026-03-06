const express = require("express");
const router = express.Router();
const announcementController = require("../controllers/announcementcontroller");

router.post("/add", announcementController.addAnnouncement);
router.get("/", announcementController.getAnnouncements);

module.exports = router;
const db = require("../config/db"); // your mysql connection file

// GET all announcements
router.get("/", (req, res) => {
  const sql = "SELECT announcement_title, message, created_at FROM announcement ORDER BY created_at DESC";

  db.query(sql, (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: "Database error" });
    }
    res.json(result);
  });
});

module.exports = router;