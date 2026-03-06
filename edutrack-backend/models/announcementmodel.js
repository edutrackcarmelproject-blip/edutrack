const db = require("../config/db");

// Insert Announcement
exports.createAnnouncement = (data, callback) => {
  const sql = `
    INSERT INTO announcement (announcement_title, message)
    VALUES (?, ?)
  `;

  db.query(sql, [data.announcement_title, data.message], callback);
};

// Get All Announcements
exports.getAllAnnouncements = (callback) => {
  const sql = "SELECT * FROM announcement ORDER BY announcement_id DESC";
  db.query(sql, callback);
};