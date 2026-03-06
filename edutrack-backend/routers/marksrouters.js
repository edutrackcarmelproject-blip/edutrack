const express = require("express");
const router = express.Router();

const marksController = require("../controllers/markscontroller");

router.post("/", marksController.saveMarks);

module.exports = router;