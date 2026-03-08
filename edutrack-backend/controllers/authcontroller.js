const jwt = require("jsonwebtoken");
const db = require("../config/db");
const { hashPassword, verifyPassword } = require("../utils/password");

const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

exports.login = async (req, res) => {
  try {
    const { email, username, password } = req.body;
    const credential = (email || username || "").trim();
    if (!credential || !password) {
      return res.status(400).json({ success: false, message: "username/email and password are required" });
    }

    const rows = await query(
      `SELECT id, name, email, username, password_hash, role, is_approved, semester, admission_no
       FROM users
       WHERE email = ? OR username = ?
       LIMIT 1`,
      [credential, credential]
    );

    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    const user = rows[0];
    if (!verifyPassword(password, user.password_hash)) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    if (user.role === "student" && Number(user.is_approved) !== 1) {
      return res.status(403).json({ success: false, message: "Student not approved by admin" });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role, email: user.email, username: user.username },
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
          username: user.username,
          role: user.role,
          semester: user.semester,
          admission_no: user.admission_no
        }
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.registerStudent = async (req, res) => {
  try {
    const { name, email, username, password, semester, admission_no } = req.body;
    if (!name || !email || !username || !password || !semester || !admission_no) {
      return res.status(400).json({ success: false, message: "name, email, username, password, semester and admission_no are required" });
    }

    const exists = await query("SELECT id FROM users WHERE email = ? OR username = ?", [email, username]);
    if (exists.length > 0) {
      return res.status(409).json({ success: false, message: "Email or username already exists" });
    }

    const result = await query(
      `INSERT INTO users (name, email, username, password_hash, role, is_approved, semester, admission_no)
       VALUES (?, ?, ?, ?, 'student', 0, ?, ?)`,
      [name, email, username, hashPassword(password), semester, admission_no]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, username, role: "student", semester, admission_no, is_approved: 0 }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.changePassword = async (req, res) => {
  try {
    const { current_password, new_password } = req.body;
    if (!current_password || !new_password) {
      return res.status(400).json({ success: false, message: "current_password and new_password are required" });
    }

    const rows = await query("SELECT password_hash FROM users WHERE id = ?", [req.user.id]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    if (!verifyPassword(current_password, rows[0].password_hash)) {
      return res.status(401).json({ success: false, message: "Current password is incorrect" });
    }

    await query("UPDATE users SET password_hash = ? WHERE id = ?", [hashPassword(new_password), req.user.id]);
    return res.status(200).json({ success: true, message: "Password updated" });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.me = async (req, res) => {
  try {
    const rows = await query(
      `SELECT id, name, email, username, role, is_approved, semester, admission_no, created_at
       FROM users WHERE id = ?`,
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
