const express = require("express");
const router = express.Router();

const authController = require("../controllers/authcontroller");
const { verifyToken } = require("../middleware/authmiddleware");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/me", verifyToken, authController.getMe);

module.exports = router;
