const db = require("../config/db");

const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

async function ensureTeacherSubject(teacherId, subjectId) {
  const rows = await query(
    "SELECT id FROM teacher_subjects WHERE teacher_id = ? AND subject_id = ?",
    [teacherId, subjectId]
  );
  return rows.length > 0;
}

exports.createAnnouncement = async (req, res) => {
  try {
    const { title, message, subject_id } = req.body;
    if (!title || !message || !subject_id) {
      return res.status(400).json({ success: false, message: "title, message and subject_id are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subject_id);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO announcements (title, message, teacher_id, subject_id) VALUES (?, ?, ?, ?)",
      [title, message, req.user.id, subject_id]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createAssignment = async (req, res) => {
  try {
    const { title, description, subject_id, due_date } = req.body;
    if (!title || !description || !subject_id || !due_date) {
      return res.status(400).json({ success: false, message: "title, description, subject_id and due_date are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subject_id);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO assignments (title, description, subject_id, teacher_id, due_date) VALUES (?, ?, ?, ?, ?)",
      [title, description, subject_id, req.user.id, due_date]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createAttendance = async (req, res) => {
  try {
    const { student_id, subject_id, date, status } = req.body;
    if (!student_id || !subject_id || !date || !status) {
      return res.status(400).json({ success: false, message: "student_id, subject_id, date and status are required" });
    }

    if (!["present", "absent"].includes(status)) {
      return res.status(400).json({ success: false, message: "status must be present or absent" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subject_id);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    await query(
      `INSERT INTO attendance (student_id, subject_id, date, status)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE status = VALUES(status)`,
      [student_id, subject_id, date, status]
    );

    return res.status(201).json({ success: true, data: { student_id, subject_id, date, status } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createMarks = async (req, res) => {
  try {
    const { student_id, subject_id, exam_type, marks } = req.body;
    if (!student_id || !subject_id || !exam_type || marks === undefined || marks === null) {
      return res.status(400).json({ success: false, message: "student_id, subject_id, exam_type and marks are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subject_id);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    await query(
      `INSERT INTO marks (student_id, subject_id, exam_type, marks)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE marks = VALUES(marks)`,
      [student_id, subject_id, exam_type, marks]
    );

    return res.status(201).json({ success: true, data: { student_id, subject_id, exam_type, marks } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createTimetable = async (req, res) => {
  try {
    const { subject_id, day, start_time, end_time } = req.body;
    if (!subject_id || !day || !start_time || !end_time) {
      return res.status(400).json({ success: false, message: "subject_id, day, start_time and end_time are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subject_id);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO timetable (subject_id, teacher_id, day, start_time, end_time) VALUES (?, ?, ?, ?, ?)",
      [subject_id, req.user.id, day, start_time, end_time]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
