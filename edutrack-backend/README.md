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

### Health
- `GET /api/health`

### Auth
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
