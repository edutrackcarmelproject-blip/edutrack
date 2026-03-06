const announcementModel = require("../models/announcementModel");

// POST - Add Announcement
exports.addAnnouncement = (req, res) => {
  const { announcement_title, message } = req.body;

  if (!announcement_title || !message) {
    return res.status(400).json({ message: "All fields required" });
  }

  announcementModel.createAnnouncement(req.body, (err, result) => {
    if (err) {
      console.log("DB ERROR:", err);
      return res.status(500).json({ message: "Database error" });
    }

    res.status(201).json({ message: "Announcement added successfully" });
  });
};

// GET - All Announcements
exports.getAnnouncements = (req, res) => {
  announcementModel.getAllAnnouncements((err, results) => {
    if (err) {
      console.log("DB ERROR:", err);
      return res.status(500).json({ message: "Database error" });
    }

    res.status(200).json(results);
  });
};