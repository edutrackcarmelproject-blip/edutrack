const db = require("../config/db");

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
