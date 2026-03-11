const express = require("express");
const router = express.Router();

const authController = require("../controllers/authcontroller");
const { verifyToken } = require("../middleware/authmiddleware");

router.post("/login", authController.login);
router.post("/register", authController.registerStudent);
router.get("/me", verifyToken, authController.me);
router.post("/change-password", verifyToken, authController.changePassword);

module.exports = router;
