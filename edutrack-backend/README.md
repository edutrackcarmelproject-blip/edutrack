# EduTrack Backend (Node.js + MySQL)

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

### Health
- `GET /api/health`

### Auth
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
