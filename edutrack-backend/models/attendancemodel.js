const db = require("../config/db");

const Attendance = {

  saveAttendance: (data, callback) => {

    const sql = `
      INSERT INTO attendance
      (attendance_date, semester, subject, present_students, absent_students)
      VALUES (?, ?, ?, ?, ?)
    `;

    db.query(
      sql,
      [
        data.attendance_date,
        data.semester,
        data.subject,
        JSON.stringify(data.present_students),
        JSON.stringify(data.absent_students)
      ],
      callback
    );

  }

};

module.exports = Attendance;