const db = require("../config/db");

codex/assist-with-backend-implementation-zaxooy
const query = (sql, params = []) =>
  new Promise((resolve, reject) => {
    db.query(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });

function subjectFilter(semester, subjectName) {
  let clause = "";
  const params = [];

  if (semester) {
    clause += " AND s.semester = ?";
    params.push(semester);
  }

  if (subjectName) {
    clause += " AND s.subject_name = ?";
    params.push(subjectName);
  }

  return { clause, params };
}

exports.getTeacherDashboard = async (req, res) => {
  try {
    const { semester, subject } = req.query;

    const filter = subjectFilter(semester, subject);

    const assignments = await query(
      `SELECT a.id AS assignment_id, a.title AS assignment_title, a.description, a.due_date, a.created_at,
              a.subject_id, s.subject_name AS subject, s.semester,
              a.teacher_id, u.name AS teacher_name
       FROM assignments a
       JOIN subjects s ON s.id = a.subject_id
       JOIN users u ON u.id = a.teacher_id
       WHERE a.teacher_id = ?${filter.clause}
       ORDER BY a.due_date ASC`,
      [req.user.id, ...filter.params]
    );

    const announcements = await query(
      `SELECT an.id AS announcement_id, an.title AS announcement_title, an.message, an.created_at,
              an.subject_id, s.subject_name AS subject, s.semester,
              an.teacher_id AS created_by, u.name AS teacher_name
       FROM announcements an
       JOIN subjects s ON s.id = an.subject_id
       JOIN users u ON u.id = an.teacher_id
       WHERE an.teacher_id = ?${filter.clause}
       ORDER BY an.created_at DESC`,
      [req.user.id, ...filter.params]
    );

    const timetable = await query(
      `SELECT t.id, s.semester, s.subject_name AS subject, t.day,
              CONCAT(DATE_FORMAT(t.start_time, '%H:%i'), ' - ', DATE_FORMAT(t.end_time, '%H:%i')) AS time,
              t.teacher_id
       FROM timetable t
       JOIN subjects s ON s.id = t.subject_id
       WHERE t.teacher_id = ?${filter.clause}
       ORDER BY FIELD(t.day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), t.start_time ASC`,
      [req.user.id, ...filter.params]
    );

    const attendance = await query(
      `SELECT at.id AS attendance_id, at.date AS attendance_date, at.status, at.student_id,
              st.name AS student_name, at.subject_id, s.subject_name AS subject, s.semester
       FROM attendance at
       JOIN users st ON st.id = at.student_id
       JOIN subjects s ON s.id = at.subject_id
       JOIN teacher_subjects ts ON ts.subject_id = s.id
       WHERE ts.teacher_id = ?${filter.clause}
       ORDER BY at.date DESC`,
      [req.user.id, ...filter.params]
    );

    const marks = await query(
      `SELECT m.id AS mark_id, m.exam_type, m.marks, m.created_at,
              m.student_id, st.name AS student_name, m.subject_id,
              s.subject_name AS subject, s.semester
       FROM marks m
       JOIN users st ON st.id = m.student_id
       JOIN subjects s ON s.id = m.subject_id
       JOIN teacher_subjects ts ON ts.subject_id = s.id
       WHERE ts.teacher_id = ?${filter.clause}
       ORDER BY m.created_at DESC`,
      [req.user.id, ...filter.params]
    );

    return res.status(200).json({
      role: "teacher",
      semester: semester || null,
      subject: subject || null,
      assignments,
      announcements,
      timetable,
      attendance,
      marks,
      assignment_grades: []
    });
  } catch (error) {
    return res.status(500).json({ message: "Database error" });
  }
};

exports.getStudentDashboard = async (req, res) => {
  try {
    const { semester, subject } = req.query;

    const studentRows = await query("SELECT id, name FROM users WHERE id = ? AND role = 'student'", [
      req.user.id
    ]);
    if (studentRows.length === 0) {
      return res.status(404).json({ message: "Student not found" });
    }

    const studentName = studentRows[0].name;
    const filter = subjectFilter(semester, subject);

    const assignments = await query(
      `SELECT a.id AS assignment_id, a.title AS assignment_title, a.description, a.due_date, a.created_at,
              a.subject_id, s.subject_name AS subject, s.semester,
              a.teacher_id, t.name AS teacher_name
       FROM assignments a
       JOIN subjects s ON s.id = a.subject_id
       JOIN users t ON t.id = a.teacher_id
       WHERE 1=1${filter.clause}
       ORDER BY a.due_date ASC`,
      [...filter.params]
    );

    const announcements = await query(
      `SELECT an.id AS announcement_id, an.title AS announcement_title, an.message, an.created_at,
              an.subject_id, s.subject_name AS subject, s.semester,
              an.teacher_id AS created_by, u.name AS teacher_name
       FROM announcements an
       JOIN subjects s ON s.id = an.subject_id
       JOIN users u ON u.id = an.teacher_id
       WHERE 1=1${filter.clause}
       ORDER BY an.created_at DESC`,
      [...filter.params]
    );

    const timetable = await query(
      `SELECT t.id, s.semester, s.subject_name AS subject, t.day,
              CONCAT(DATE_FORMAT(t.start_time, '%H:%i'), ' - ', DATE_FORMAT(t.end_time, '%H:%i')) AS time,
              t.teacher_id, u.name AS teacher_name
       FROM timetable t
       JOIN subjects s ON s.id = t.subject_id
       JOIN users u ON u.id = t.teacher_id
       WHERE 1=1${filter.clause}
       ORDER BY FIELD(t.day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), t.start_time ASC`,
      [...filter.params]
    );

    const marks = await query(
      `SELECT m.id AS mark_id, m.exam_type, m.marks, m.created_at,
              m.subject_id, s.subject_name AS subject, s.semester
       FROM marks m
       JOIN subjects s ON s.id = m.subject_id
       WHERE m.student_id = ?${filter.clause}
       ORDER BY m.created_at DESC`,
      [req.user.id, ...filter.params]
    );

    const attendance = await query(
      `SELECT at.id AS attendance_id, at.date AS attendance_date, at.status,
              at.subject_id, s.subject_name AS subject, s.semester
       FROM attendance at
       JOIN subjects s ON s.id = at.subject_id
       WHERE at.student_id = ?${filter.clause}
       ORDER BY at.date DESC`,
      [req.user.id, ...filter.params]
    );

    return res.status(200).json({
      role: "student",
      semester: semester || null,
      subject: subject || null,
      student_name: studentName,
      assignments,
      announcements,
      timetable,
      marks,
      assignment_grades: [],
      attendance
    });
  } catch (error) {
    return res.status(500).json({ message: "Database error" });
  }
};

exports.getTeacherDashboard = (req, res) => {
  const { semester, subject } = req.query;

  if (!semester || !subject) {
    return res.status(400).json({ message: "semester and subject are required" });
  }

  const queries = {
    assignments: {
      sql: "SELECT * FROM assignments WHERE semester = ? AND subject = ? ORDER BY due_date ASC",
      params: [semester, subject]
    },
    announcements: {
      sql: "SELECT * FROM announcement ORDER BY announcement_id DESC LIMIT 20",
      params: []
    },
    timetable: {
      sql: "SELECT * FROM timetable WHERE semester = ? ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), time ASC",
      params: [semester]
    },
    attendance: {
      sql: "SELECT * FROM attendance WHERE semester = ? AND subject = ? ORDER BY attendance_date DESC LIMIT 20",
      params: [semester, subject]
    },
    marks: {
      sql: "SELECT * FROM marks WHERE semester = ? AND subject = ? ORDER BY mark_id DESC LIMIT 50",
      params: [semester, subject]
    },
    assignment_grades: {
      sql: "SELECT * FROM assignment_grades WHERE semester = ? AND subject = ? ORDER BY assignment_grade_id DESC LIMIT 50",
      params: [semester, subject]
    }
  };

  runQueries(queries, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    results.attendance = (results.attendance || []).map((row) => ({
      ...row,
      present_students: safeJsonParse(row.present_students),
      absent_students: safeJsonParse(row.absent_students)
    }));

    return res.status(200).json({
      role: "teacher",
      semester,
      subject,
      ...results
    });
  });
};

exports.getStudentDashboard = (req, res) => {
  const { semester, subject, student_name } = req.query;

  if (!semester || !subject || !student_name) {
    return res.status(400).json({ message: "semester, subject and student_name are required" });
  }

  const queries = {
    assignments: {
      sql: "SELECT * FROM assignments WHERE semester = ? AND subject = ? ORDER BY due_date ASC",
      params: [semester, subject]
    },
    announcements: {
      sql: "SELECT * FROM announcement ORDER BY announcement_id DESC LIMIT 20",
      params: []
    },
    timetable: {
      sql: "SELECT * FROM timetable WHERE semester = ? ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), time ASC",
      params: [semester]
    },
    marks: {
      sql: "SELECT * FROM marks WHERE semester = ? AND subject = ? AND student_name = ? ORDER BY mark_id DESC LIMIT 20",
      params: [semester, subject, student_name]
    },
    assignment_grades: {
      sql: "SELECT * FROM assignment_grades WHERE semester = ? AND subject = ? AND student = ? ORDER BY assignment_grade_id DESC LIMIT 20",
      params: [semester, subject, student_name]
    },
    attendance: {
      sql: "SELECT * FROM attendance WHERE semester = ? AND subject = ? ORDER BY attendance_date DESC LIMIT 50",
      params: [semester, subject]
    }
  };

  runQueries(queries, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: "Database error" });
    }

    const attendanceSummary = (results.attendance || []).map((row) => {
      const present = safeJsonParse(row.present_students);
      const absent = safeJsonParse(row.absent_students);
      return {
        attendance_id: row.attendance_id,
        attendance_date: row.attendance_date,
        semester: row.semester,
        subject: row.subject,
        status: present.includes(student_name) ? "present" : absent.includes(student_name) ? "absent" : "not_marked"
      };
    });

    return res.status(200).json({
      role: "student",
      semester,
      subject,
      student_name,
      assignments: results.assignments,
      announcements: results.announcements,
      timetable: results.timetable,
      marks: results.marks,
      assignment_grades: results.assignment_grades,
      attendance: attendanceSummary
    });
  });
};

function runQueries(queryMap, callback) {
  const keys = Object.keys(queryMap);
  const output = {};
  let pending = keys.length;
  let failed = false;

  if (pending === 0) {
    return callback(null, output);
  }

  keys.forEach((key) => {
    const { sql, params } = queryMap[key];
    db.query(sql, params, (err, rows) => {
      if (failed) {
        return;
      }

      if (err) {
        failed = true;
        return callback(err);
      }

      output[key] = rows;
      pending -= 1;

      if (pending === 0) {
        return callback(null, output);
      }
    });
  });
}

function safeJsonParse(value) {
  try {
    return JSON.parse(value || "[]");
  } catch (error) {
    return [];
  }
}
main
