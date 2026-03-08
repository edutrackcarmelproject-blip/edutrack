const express = require("express");
const router = express.Router();

const authController = require("../controllers/authcontroller");
const { verifyToken } = require("../middleware/authmiddleware");

 codex/assist-with-backend-implementation-zaxooy
router.post("/login", authController.login);
router.post("/register", authController.registerStudent);
router.get("/me", verifyToken, authController.me);
router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/me", verifyToken, authController.getMe);
main

module.exports = router;
