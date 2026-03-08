const crypto = require("crypto");
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

exports.addTeacher = async (req, res) => {
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
      "INSERT INTO users (name, email, password_hash, role, is_approved) VALUES (?, ?, ?, 'teacher', 1)",
      [name, email, hashPassword(password)]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, role: "teacher" }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.addStudent = async (req, res) => {
  try {
    const { name, email, password, is_approved } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: "name, email and password are required" });
    }

    const exists = await query("SELECT id FROM users WHERE email = ?", [email]);
    if (exists.length > 0) {
      return res.status(409).json({ success: false, message: "Email already exists" });
    }

    const approved = Number(is_approved) === 1 ? 1 : 0;
    const result = await query(
      "INSERT INTO users (name, email, password_hash, role, is_approved) VALUES (?, ?, ?, 'student', ?)",
      [name, email, hashPassword(password), approved]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, role: "student", is_approved: approved }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.approveStudent = async (req, res) => {
  try {
    const { student_id } = req.body;
    if (!student_id) {
      return res.status(400).json({ success: false, message: "student_id is required" });
    }

    const result = await query(
      "UPDATE users SET is_approved = 1 WHERE id = ? AND role = 'student'",
      [student_id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: "Student not found" });
    }

    return res.status(200).json({ success: true, data: { student_id, is_approved: 1 } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.addSubject = async (req, res) => {
  try {
    const { subject_name, semester, teacher_id } = req.body;
    if (!subject_name || !semester) {
      return res.status(400).json({ success: false, message: "subject_name and semester are required" });
    }

    const result = await query(
      "INSERT INTO subjects (subject_name, semester) VALUES (?, ?)",
      [subject_name, semester]
    );

    const subjectId = result.insertId;

    if (teacher_id) {
      await query(
        "INSERT IGNORE INTO teacher_subjects (teacher_id, subject_id) VALUES (?, ?)",
        [teacher_id, subjectId]
      );
    }

    return res.status(201).json({
      success: true,
      data: { id: subjectId, subject_name, semester, teacher_id: teacher_id || null }
    });
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ success: false, message: "Subject already exists for this semester" });
    }
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.assignTeacherSubject = async (req, res) => {
  try {
    const { teacher_id, subject_id } = req.body;
    if (!teacher_id || !subject_id) {
      return res.status(400).json({ success: false, message: "teacher_id and subject_id are required" });
    }

    await query("INSERT IGNORE INTO teacher_subjects (teacher_id, subject_id) VALUES (?, ?)", [teacher_id, subject_id]);
    return res.status(200).json({ success: true, data: { teacher_id, subject_id } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getUsers = async (req, res) => {
  try {
    const { role } = req.query;
    let sql = "SELECT id, name, email, role, is_approved, created_at FROM users";
    const params = [];

    if (role) {
      sql += " WHERE role = ?";
      params.push(role);
    }
    sql += " ORDER BY id ASC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getSubjects = async (req, res) => {
  try {
    const rows = await query(
      `SELECT s.id, s.subject_name, s.semester,
              ts.teacher_id, u.name AS teacher_name
       FROM subjects s
       LEFT JOIN teacher_subjects ts ON ts.subject_id = s.id
       LEFT JOIN users u ON u.id = ts.teacher_id
       ORDER BY s.semester, s.subject_name`
    );

    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
