const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const db = require("../config/db");


const allowedRoles = ["student", "teacher", "admin"];

const hashPassword = (password) => {
  return crypto.createHash("sha256").update(password).digest("hex");
};

exports.register = (req, res) => {
  const { name, email, password, role } = req.body;

  if (!name || !email || !password || !role) {
    return res.status(400).json({ message: "name, email, password and role are required" });
  }

  if (!allowedRoles.includes(role)) {
    return res.status(400).json({ message: "role must be student, teacher, or admin" });
  }

  const checkSql = "SELECT user_id FROM users WHERE email = ?";
  db.query(checkSql, [email], (checkErr, users) => {
    if (checkErr) {
      return res.status(500).json({ message: "Database error" });
    }

    if (users.length > 0) {
      return res.status(409).json({ message: "User already exists" });
    }

    const hashedPassword = hashPassword(password);
    const insertSql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";

    db.query(insertSql, [name, email, hashedPassword, role], (insertErr, result) => {
      if (insertErr) {
        return res.status(500).json({ message: "Database error" });
      }

      return res.status(201).json({
        message: "User registered successfully",
        user_id: result.insertId
      });
    });
  });
};

exports.login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "email and password are required" });
  }

  const sql = "SELECT user_id, name, email, password_hash, role FROM users WHERE email = ?";

  db.query(sql, [email], (err, users) => {
    if (err) {
      return res.status(500).json({ message: "Database error" });
    }

    if (users.length === 0) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const user = users[0];
    const hashedPassword = hashPassword(password);

    if (user.password_hash !== hashedPassword) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = jwt.sign(
      {
        user_id: user.user_id,
        email: user.email,
        role: user.role
      },
      process.env.JWT_SECRET || "edutrack_secret",
      { expiresIn: "7d" }
    );

    return res.status(200).json({
      message: "Login successful",
      token,
      user: {
        user_id: user.user_id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    });
  });
};


exports.getMe = (req, res) => {
  const sql = "SELECT user_id, name, email, role, created_at FROM users WHERE user_id = ?";

  db.query(sql, [req.user.user_id], (err, users) => {
    if (err) {
      return res.status(500).json({ message: "Database error" });
    }

    if (users.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    return res.status(200).json(users[0]);
  });
};
