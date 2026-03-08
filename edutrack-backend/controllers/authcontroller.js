const jwt = require("jsonwebtoken");
const db = require("../config/db");
codex/fix-high-priority-issues-from-codex-review
const { hashPassword, verifyPassword } = require("../utils/password");


codex/assist-with-backend-implementation-zaxooy
const hashPassword = (password) =>
  crypto.createHash("sha256").update(password).digest("hex");
codex/assist-with-backend-implementation-zaxooy

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
 codex/fix-high-priority-issues-from-codex-review
      { id: user.id, role: user.role, email: user.email, username: user.username },

      { id: user.id, role: user.role, email: user.email },


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
main
codex/assist-with-backend-implementation-zaxooy
      process.env.JWT_SECRET || "edutrack_secret",
      { expiresIn: "7d" }
    );

    return res.status(200).json({
codex/assist-with-backend-implementation-zaxooy
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
 main
};
