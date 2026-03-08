const db = require("../config/db");
const { hashPassword } = require("../utils/password");

const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

exports.addTeacher = async (req, res) => {
  try {
    const { name, email, username, password } = req.body;
    if (!name || !email || !username || !password) {
      return res.status(400).json({ success: false, message: "name, email, username and password are required" });
    }

    const exists = await query("SELECT id FROM users WHERE email = ? OR username = ?", [email, username]);
    if (exists.length > 0) {
      return res.status(409).json({ success: false, message: "Email or username already exists" });
    }

    const result = await query(
      "INSERT INTO users (name, email, username, password_hash, role, is_approved) VALUES (?, ?, ?, ?, 'teacher', 1)",
      [name, email, username, hashPassword(password)]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, username, role: "teacher" }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.updateTeacher = async (req, res) => {
  try {
    const teacherId = Number(req.params.id);
    const { name, email, username, password } = req.body;

    const teacherRows = await query("SELECT id FROM users WHERE id = ? AND role = 'teacher'", [teacherId]);
    if (teacherRows.length === 0) {
      return res.status(404).json({ success: false, message: "Teacher not found" });
    }

    if (email || username) {
      const dup = await query(
        "SELECT id FROM users WHERE (email = ? OR username = ?) AND id <> ? LIMIT 1",
        [email || "", username || "", teacherId]
      );
      if (dup.length > 0) {
        return res.status(409).json({ success: false, message: "Email or username already exists" });
      }
    }

    const updates = [];
    const params = [];

    if (name) {
      updates.push("name = ?");
      params.push(name);
    }
    if (email) {
      updates.push("email = ?");
      params.push(email);
    }
    if (username) {
      updates.push("username = ?");
      params.push(username);
    }
    if (password) {
      updates.push("password_hash = ?");
      params.push(hashPassword(password));
    }

    if (updates.length === 0) {
      return res.status(400).json({ success: false, message: "No fields provided" });
    }

    params.push(teacherId);
    await query(`UPDATE users SET ${updates.join(", ")} WHERE id = ? AND role = 'teacher'`, params);

    return res.status(200).json({ success: true, message: "Teacher updated" });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.deleteTeacher = async (req, res) => {
  try {
    const teacherId = Number(req.params.id);
    const result = await query("DELETE FROM users WHERE id = ? AND role = 'teacher'", [teacherId]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: "Teacher not found" });
    }

    return res.status(200).json({ success: true, message: "Teacher deleted" });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.addStudent = async (req, res) => {
  try {
    const { name, email, username, password, semester, admission_no, is_approved } = req.body;
    if (!name || !email || !username || !password || !semester || !admission_no) {
      return res.status(400).json({ success: false, message: "name, email, username, password, semester and admission_no are required" });
    }

    const exists = await query("SELECT id FROM users WHERE email = ? OR username = ? OR admission_no = ?", [
      email,
      username,
      admission_no
    ]);
    if (exists.length > 0) {
      return res.status(409).json({ success: false, message: "Email, username, or admission number already exists" });
    }

    const approved = Number(is_approved) === 1 ? 1 : 0;
    const result = await query(
      `INSERT INTO users (name, email, username, password_hash, role, is_approved, semester, admission_no)
       VALUES (?, ?, ?, ?, 'student', ?, ?, ?)`,
      [name, email, username, hashPassword(password), approved, semester, admission_no]
    );

    return res.status(201).json({
      success: true,
      data: { id: result.insertId, name, email, username, role: "student", semester, admission_no, is_approved: approved }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.updateStudent = async (req, res) => {
  try {
    const studentId = Number(req.params.id);
    const { name, email, username, password, semester, admission_no, is_approved } = req.body;

    const studentRows = await query("SELECT id FROM users WHERE id = ? AND role = 'student'", [studentId]);
    if (studentRows.length === 0) {
      return res.status(404).json({ success: false, message: "Student not found" });
    }

    if (email || username || admission_no) {
      const dup = await query(
        "SELECT id FROM users WHERE (email = ? OR username = ? OR admission_no = ?) AND id <> ? LIMIT 1",
        [email || "", username || "", admission_no || "", studentId]
      );
      if (dup.length > 0) {
        return res.status(409).json({ success: false, message: "Email, username, or admission number already exists" });
      }
    }

    const updates = [];
    const params = [];

    if (name) {
      updates.push("name = ?");
      params.push(name);
    }
    if (email) {
      updates.push("email = ?");
      params.push(email);
    }
    if (username) {
      updates.push("username = ?");
      params.push(username);
    }
    if (semester) {
      updates.push("semester = ?");
      params.push(semester);
    }
    if (admission_no) {
      updates.push("admission_no = ?");
      params.push(admission_no);
    }
    if (password) {
      updates.push("password_hash = ?");
      params.push(hashPassword(password));
    }
    if (is_approved !== undefined) {
      updates.push("is_approved = ?");
      params.push(Number(is_approved) === 1 ? 1 : 0);
    }

    if (updates.length === 0) {
      return res.status(400).json({ success: false, message: "No fields provided" });
    }

    params.push(studentId);
    await query(`UPDATE users SET ${updates.join(", ")} WHERE id = ? AND role = 'student'`, params);

    return res.status(200).json({ success: true, message: "Student updated" });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.deleteStudent = async (req, res) => {
  try {
    const studentId = Number(req.params.id);
    const result = await query("DELETE FROM users WHERE id = ? AND role = 'student'", [studentId]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: "Student not found" });
    }

    return res.status(200).json({ success: true, message: "Student deleted" });
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
    const { role, semester } = req.query;
    let sql = `SELECT id, name, email, username, role, is_approved, semester, admission_no, created_at
               FROM users WHERE 1=1`;
    const params = [];

    if (role) {
      sql += " AND role = ?";
      params.push(role);
    }
    if (semester) {
      sql += " AND semester = ?";
      params.push(semester);
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

exports.getAttendance = async (req, res) => {
  try {
    const { semester, subject_id } = req.query;

    let sql = `SELECT at.id, at.date, at.status,
                      st.id AS student_id, st.name AS student_name, st.admission_no, st.semester,
                      s.id AS subject_id, s.subject_name
               FROM attendance at
               JOIN users st ON st.id = at.student_id
               JOIN subjects s ON s.id = at.subject_id
               WHERE 1=1`;
    const params = [];

    if (semester) {
      sql += " AND st.semester = ?";
      params.push(semester);
    }
    if (subject_id) {
      sql += " AND s.id = ?";
      params.push(Number(subject_id));
    }

    sql += " ORDER BY at.date DESC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getMarks = async (req, res) => {
  try {
    const { semester, subject_id } = req.query;

    let sql = `SELECT m.id, m.exam_type, m.marks, m.created_at,
                      st.id AS student_id, st.name AS student_name, st.admission_no, st.semester,
                      s.id AS subject_id, s.subject_name
               FROM marks m
               JOIN users st ON st.id = m.student_id
               JOIN subjects s ON s.id = m.subject_id
               WHERE 1=1`;
    const params = [];

    if (semester) {
      sql += " AND st.semester = ?";
      params.push(semester);
    }
    if (subject_id) {
      sql += " AND s.id = ?";
      params.push(Number(subject_id));
    }

    sql += " ORDER BY m.created_at DESC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getPerformance = async (req, res) => {
  try {
    const { semester } = req.query;
    const params = [];

    let whereClause = "WHERE u.role = 'student'";
    if (semester) {
      whereClause += " AND u.semester = ?";
      params.push(semester);
    }

    const rows = await query(
      `SELECT u.id AS student_id, u.name AS student_name, u.admission_no, u.semester,
              ROUND(AVG(CASE WHEN at.status = 'present' THEN 1 ELSE 0 END) * 100, 2) AS attendance_percent,
              ROUND(AVG(m.marks), 2) AS average_marks
       FROM users u
       LEFT JOIN attendance at ON at.student_id = u.id
       LEFT JOIN marks m ON m.student_id = u.id
       ${whereClause}
       GROUP BY u.id, u.name, u.admission_no, u.semester
       ORDER BY u.semester, u.name`,
      params
    );

    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
