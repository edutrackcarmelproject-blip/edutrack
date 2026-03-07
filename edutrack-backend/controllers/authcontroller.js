const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const db = require("../config/db");

const hashPassword = (password) =>
  crypto.createHash("sha256").update(password).digest("hex");

const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: "email and password are required" });
    }

    const rows = await query(
      "SELECT id, name, email, password_hash, role, is_approved FROM users WHERE email = ?",
      [email]
    );

    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    const user = rows[0];
    if (user.password_hash !== hashPassword(password)) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    if (user.role === "student" && Number(user.is_approved) !== 1) {
      return res.status(403).json({ success: false, message: "Student not approved by admin" });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role, email: user.email },
      process.env.JWT_SECRET || "edutrack_secret",
      { expiresIn: "7d" }
    );

    return res.status(200).json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.registerStudent = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: "name, email and password are required" });
    }

    const exists = await query("SELECT id FROM users WHERE email = ?", [email]);
    if (exists.length > 0) {
      return res.status(409).json({ success: false, message: "Email already exists" });
    }

    const result = await query(
      "INSERT INTO users (name, email, password_hash, role, is_approved) VALUES (?, ?, ?, 'student', 0)",
      [name, email, hashPassword(password)]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, role: "student", is_approved: 0 }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.me = async (req, res) => {
  try {
    const rows = await query(
      "SELECT id, name, email, role, is_approved, created_at FROM users WHERE id = ?",
      [req.user.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    return res.status(200).json({ success: true, data: rows[0] });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
