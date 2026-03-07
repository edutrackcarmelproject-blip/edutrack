const express = require("express");
const router = express.Router();
const announcementController = require("../controllers/announcementcontroller");

router.post("/add", announcementController.addAnnouncement);
router.get("/", announcementController.getAnnouncements);

module.exports = router;
