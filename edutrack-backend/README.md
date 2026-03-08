# EduTrack Backend (Node.js + MySQL)

## Quick Start
```bash
cd edutrack-backend
npm install
npm start
```

Backend URL: `http://localhost:5000`

## Environment
- `PORT` (default `5000`)
- `DB_HOST` (default `localhost`)
- `DB_USER` (default `root`)
- `DB_PASSWORD` (default `1234`)
- `DB_NAME` (default `edutrack`)
- `DB_CONNECTION_LIMIT` (default `10`)
- `JWT_SECRET` (default `edutrack_secret`)

## Auto DB + Schema setup
On startup backend automatically:
1. creates DB if missing
2. runs `schema.sql`
3. seeds demo records (admin/teachers/students/subjects)

## Demo Credentials
(All passwords are `1234`)
- Admin: `admin@edutrack.com`
- Teacher: `teacher1@edutrack.com`
- Student: `student1@edutrack.com`

## API Response Contract
All APIs return JSON like:
```json
{
  "success": true,
  "data": {}
}
```

## Endpoints
=======
## 1) Setup

```bash
cd edutrack-backend
npm install
```

Create DB tables:

```bash
mysql -u root -p < schema.sql
```

Run server:

```bash
node index.js
```

Server URL: `http://localhost:5000`

## 2) Environment Variables

- `PORT` (default: `5000`)
- `DB_HOST` (default: `localhost`)
- `DB_USER` (default: `root`)
- `DB_PASSWORD` (default: `1234`)
- `DB_NAME` (default: `edutrack`)
- `DB_CONNECTION_LIMIT` (default: `10`)
- `JWT_SECRET` (default: `edutrack_secret`)

## 3) APIs
main

### Health
- `GET /api/health`

### Auth
<<<<<< codex/assist-with-backend-implementation-zaxooy
- `POST /api/auth/login`
- `POST /api/auth/register` (student self-register, pending approval)
- `GET /api/auth/me`

### Admin (JWT role: admin)
- `POST /api/admin/add-teacher`
- `POST /api/admin/add-student`
- `POST /api/admin/approve-student`
- `POST /api/admin/add-subject`
- `POST /api/admin/assign-teacher-subject`
- `GET /api/admin/users`
- `GET /api/admin/subjects`

### Teacher (JWT role: teacher)
- `POST /api/announcements`
- `POST /api/assignments`
- `POST /api/attendance`
- `POST /api/marks`
- `POST /api/timetable`

### Student (JWT role: student)
- `GET /api/student/announcements?subject_id=&semester=`
- `GET /api/student/assignments?subject_id=&semester=`
- `GET /api/student/attendance?student_id=&subject_id=&semester=`
- `GET /api/student/marks?student_id=&subject_id=&semester=`
- `GET /api/student/timetable?subject_id=&semester=`

## End-to-end flow
Admin -> creates teachers/students/subjects and mapping ->
Teacher -> adds announcements/assignments/attendance/marks/timetable ->
Student -> reads own data from student endpoints.
=======
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me` (Bearer token)

### Announcements
- `POST /api/announcement/add`
- `GET /api/announcement`

### Assignments
- `POST /api/assignments/add`
- `GET /api/assignments`
- `GET /api/assignments/filter?semester=...&subject=...`

### Attendance
- `POST /api/attendance`
- `GET /api/attendance?semester=...&subject=...&attendance_date=YYYY-MM-DD`

### Marks
- `POST /api/marks`
- `GET /api/marks?semester=...&subject=...&student_name=...`

### Timetable
- `POST /api/timetable/add`
- `GET /api/timetable/all?semester=...&day=...`

### Assignment Grades
- `POST /api/assignment-marks/add`
- `GET /api/assignment-marks?semester=...&subject=...&assignment=...&student=...`


### Teacher/Student Dashboard Data (single-call endpoints)
- `GET /api/dashboard/teacher?semester=...&subject=...`
- `GET /api/dashboard/student?semester=...&subject=...&student_name=...`

These endpoints are designed for fast Flutter integration:
- Teacher endpoint returns assignments, attendance, marks, assignment grades, timetable and announcements.
- Student endpoint returns the same academic data filtered for the given student and converts attendance arrays into per-day `present/absent/not_marked` status.

## 4) Notes for Flutter Team

- Keep backend base URL in one place in Flutter (e.g., constants file).
- Save JWT token after login and send with `Authorization: Bearer <token>`.
- Use query parameters for filtered list screens.

- To show same teacher-entered data on both teacher and student pages, always write with POST APIs and read through either module GET APIs or `/api/dashboard/*` endpoints.
main
