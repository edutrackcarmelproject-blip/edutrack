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

async function resolveSubjectId({ subject_id, semester, subject }) {
  if (subject_id) return Number(subject_id);
  if (!semester || !subject) return null;

  const rows = await query("SELECT id FROM subjects WHERE semester = ? AND subject_name = ? LIMIT 1", [
    semester,
    subject
  ]);

  return rows.length ? Number(rows[0].id) : null;
}

exports.createAnnouncement = async (req, res) => {
  try {
    const { title, message, subject_id } = req.body;
    if (!title || !message) {
      return res.status(400).json({ success: false, message: "title and message are required" });
    }

    let resolvedSubjectId = subject_id;

    if (!resolvedSubjectId) {
      const assigned = await query(
        "SELECT subject_id FROM teacher_subjects WHERE teacher_id = ? ORDER BY subject_id ASC LIMIT 1",
        [req.user.id]
      );
      if (assigned.length === 0) {
        return res.status(400).json({ success: false, message: "subject_id is required for unassigned teacher" });
      }
      resolvedSubjectId = assigned[0].subject_id;
    }

    const allowed = await ensureTeacherSubject(req.user.id, resolvedSubjectId);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO announcements (title, message, teacher_id, subject_id) VALUES (?, ?, ?, ?)",
      [title, message, req.user.id, resolvedSubjectId]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createAssignment = async (req, res) => {
  try {
    const title = req.body.title || req.body.assignment_title;
    const description = req.body.description;
    const due_date = req.body.due_date;
    const subjectId = await resolveSubjectId(req.body);

    if (!title || !description || !subjectId || !due_date) {
      return res.status(400).json({ success: false, message: "title, description, subject_id and due_date are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subjectId);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO assignments (title, description, subject_id, teacher_id, due_date) VALUES (?, ?, ?, ?, ?)",
      [title, description, subjectId, req.user.id, due_date]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createAttendance = async (req, res) => {
  try {
    const subjectId = await resolveSubjectId(req.body);
    const date = req.body.date || req.body.attendance_date;

    if (!subjectId || !date) {
      return res.status(400).json({ success: false, message: "subject_id and date are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subjectId);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    if (Array.isArray(req.body.present_students) || Array.isArray(req.body.absent_students)) {
      const presentStudents = Array.isArray(req.body.present_students) ? req.body.present_students : [];
      const absentStudents = Array.isArray(req.body.absent_students) ? req.body.absent_students : [];

      const students = await query(
        "SELECT id, name FROM users WHERE role = 'student' AND name IN (?)",
        [[...presentStudents, ...absentStudents]]
      );
      const nameToId = new Map(students.map((s) => [s.name, s.id]));

      for (const name of presentStudents) {
        const studentId = nameToId.get(name);
        if (!studentId) continue;
        await query(
          `INSERT INTO attendance (student_id, subject_id, date, status)
           VALUES (?, ?, ?, 'present')
           ON DUPLICATE KEY UPDATE status = VALUES(status)`,
          [studentId, subjectId, date]
        );
      }

      for (const name of absentStudents) {
        const studentId = nameToId.get(name);
        if (!studentId) continue;
        await query(
          `INSERT INTO attendance (student_id, subject_id, date, status)
           VALUES (?, ?, ?, 'absent')
           ON DUPLICATE KEY UPDATE status = VALUES(status)`,
          [studentId, subjectId, date]
        );
      }

      return res.status(201).json({ success: true });
    }

    const { student_id, status } = req.body;
    if (!student_id || !status || !["present", "absent"].includes(status)) {
      return res.status(400).json({ success: false, message: "student_id and valid status are required" });
    }

    await query(
      `INSERT INTO attendance (student_id, subject_id, date, status)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE status = VALUES(status)`,
      [student_id, subjectId, date, status]
    );

    return res.status(201).json({ success: true, data: { student_id, subject_id: subjectId, date, status } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createMarks = async (req, res) => {
  try {
    const subjectId = await resolveSubjectId(req.body);

    if (!subjectId) {
      return res.status(400).json({ success: false, message: "subject_id is required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subjectId);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    if (Array.isArray(req.body.marksList)) {
      for (const row of req.body.marksList) {
        if (!row.student_id || row.marks === undefined || row.marks === null) continue;
        await query(
          `INSERT INTO marks (student_id, subject_id, exam_type, marks)
           VALUES (?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE marks = VALUES(marks)`,
          [row.student_id, subjectId, row.exam_type || "internal", row.marks]
        );
      }
      return res.status(201).json({ success: true });
    }

    const { student_id, exam_type, marks } = req.body;
    if (!student_id || !exam_type || marks === undefined || marks === null) {
      return res.status(400).json({ success: false, message: "student_id, exam_type and marks are required" });
    }

    await query(
      `INSERT INTO marks (student_id, subject_id, exam_type, marks)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE marks = VALUES(marks)`,
      [student_id, subjectId, exam_type, marks]
    );

    return res.status(201).json({ success: true, data: { student_id, subject_id: subjectId, exam_type, marks } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.createTimetable = async (req, res) => {
  try {
    const subjectId = await resolveSubjectId(req.body);
    const { day } = req.body;

    let start_time = req.body.start_time;
    let end_time = req.body.end_time;

    if ((!start_time || !end_time) && req.body.time) {
      const [start, end] = String(req.body.time).split("-").map((v) => v.trim());
      start_time = start;
      end_time = end;
    }

    if (!subjectId || !day || !start_time || !end_time) {
      return res.status(400).json({ success: false, message: "subject_id, day, start_time and end_time are required" });
    }

    const allowed = await ensureTeacherSubject(req.user.id, subjectId);
    if (!allowed) {
      return res.status(403).json({ success: false, message: "Teacher is not assigned to this subject" });
    }

    const result = await query(
      "INSERT INTO timetable (subject_id, teacher_id, day, start_time, end_time) VALUES (?, ?, ?, ?, ?)",
      [subjectId, req.user.id, day, start_time, end_time]
    );

    return res.status(201).json({ success: true, data: { id: result.insertId } });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
