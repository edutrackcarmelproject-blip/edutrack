const db = require("../config/db");

const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

const parseFilters = async (req) => {
  const studentRows = await query("SELECT semester FROM users WHERE id = ? AND role = 'student'", [req.user.id]);
  const defaultSemester = studentRows.length ? studentRows[0].semester : null;

  const studentId = Number(req.user.id);
  const subjectId = req.query.subject_id ? Number(req.query.subject_id) : null;
  const semester = req.query.semester || defaultSemester || null;
  return { studentId, subjectId, semester };
};

exports.getSubjects = async (req, res) => {
  try {
    const filters = await parseFilters(req);
    if (!filters.semester) {
      return res.status(200).json({ success: true, data: [] });
    }

    const rows = await query(
      `SELECT id, subject_name, semester
       FROM subjects
       WHERE semester = ?
       ORDER BY subject_name ASC`,
      [filters.semester]
    );

    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getAnnouncements = async (req, res) => {
  try {
    const { subjectId, semester } = await parseFilters(req);

    let sql = `SELECT a.id, a.title, a.message, a.created_at,
                      a.teacher_id, u.name AS teacher_name,
                      a.subject_id, s.subject_name, s.semester
               FROM announcements a
               JOIN users u ON u.id = a.teacher_id
               JOIN subjects s ON s.id = a.subject_id
               WHERE 1=1`;
    const params = [];

    if (subjectId) {
      sql += " AND a.subject_id = ?";
      params.push(subjectId);
    }
    if (semester) {
      sql += " AND s.semester = ?";
      params.push(semester);
    }

    sql += " ORDER BY a.created_at DESC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getAssignments = async (req, res) => {
  try {
    const { subjectId, semester } = await parseFilters(req);

    let sql = `SELECT a.id, a.title, a.description, a.due_date, a.created_at,
                      a.teacher_id, u.name AS teacher_name,
                      a.subject_id, s.subject_name, s.semester
               FROM assignments a
               JOIN users u ON u.id = a.teacher_id
               JOIN subjects s ON s.id = a.subject_id
               WHERE 1=1`;
    const params = [];

    if (subjectId) {
      sql += " AND a.subject_id = ?";
      params.push(subjectId);
    }
    if (semester) {
      sql += " AND s.semester = ?";
      params.push(semester);
    }

    sql += " ORDER BY a.due_date ASC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getAttendance = async (req, res) => {
  try {
    const { studentId, subjectId, semester } = await parseFilters(req);

    let sql = `SELECT at.id, at.student_id, at.subject_id, at.date, at.status,
                      s.subject_name, s.semester
               FROM attendance at
               JOIN subjects s ON s.id = at.subject_id
               WHERE at.student_id = ?`;
    const params = [studentId];

    if (subjectId) {
      sql += " AND at.subject_id = ?";
      params.push(subjectId);
    }
    if (semester) {
      sql += " AND s.semester = ?";
      params.push(semester);
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
    const { studentId, subjectId, semester } = await parseFilters(req);

    let sql = `SELECT m.id, m.student_id, m.subject_id, m.exam_type, m.marks,
                      s.subject_name, s.semester
               FROM marks m
               JOIN subjects s ON s.id = m.subject_id
               WHERE m.student_id = ?`;
    const params = [studentId];

    if (subjectId) {
      sql += " AND m.subject_id = ?";
      params.push(subjectId);
    }
    if (semester) {
      sql += " AND s.semester = ?";
      params.push(semester);
    }

    sql += " ORDER BY m.created_at DESC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};

exports.getTimetable = async (req, res) => {
  try {
    const { subjectId, semester } = await parseFilters(req);

    let sql = `SELECT t.id, t.day, t.start_time, t.end_time,
                      t.subject_id, s.subject_name, s.semester,
                      t.teacher_id, u.name AS teacher_name
               FROM timetable t
               JOIN subjects s ON s.id = t.subject_id
               JOIN users u ON u.id = t.teacher_id
               WHERE 1=1`;
    const params = [];

    if (subjectId) {
      sql += " AND t.subject_id = ?";
      params.push(subjectId);
    }
    if (semester) {
      sql += " AND s.semester = ?";
      params.push(semester);
    }

    sql += " ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), start_time ASC";

    const rows = await query(sql, params);
    return res.status(200).json({ success: true, data: rows });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Database error" });
  }
};
