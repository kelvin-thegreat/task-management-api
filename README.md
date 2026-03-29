# Task Management API (Laravel + MySQL)

## Overview

This project is a Task Management REST API built using Laravel and MySQL as part of a take-home assignment.

It supports task creation, listing, status updates, deletion, and a daily report feature.

---

## Tech Stack

- Laravel (PHP Framework)
- MySQL (Database)
- C
- RESTful API

---

## 🗄️ Database Schema

### Table: `tasks`

| Column      | Type      | Description                         |
|------------|----------|-------------------------------------|
| id         | integer  | Primary Key                         |
| title      | string   | Task title                          |
| due_date   | date     | Deadline                            |
| priority   | enum     | low, medium, high                   |
| status     | enum     | pending, in_progress, done          |
| created_at | timestamp| Laravel default                     |
| updated_at | timestamp| Laravel default                     |

---

## 🚀 Setup Instructions (Local)

### 1. Clone Repository
```bash
git clone https://github.com/kelvin-thegreat/task-management-api.git
cd task-api
```

### 2. Install Dependencies

```bash
composer install
```

### 3. Setup Environment

```bash
cp .env.example .env
```

Update `.env` with your MySQL credentials:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=task_api
DB_USERNAME=root
DB_PASSWORD=
```

### 4. Generate App Key

```bash
php artisan key:generate
```

### 5. Run Migrations

```bash
php artisan migrate
```

### 6. Start Server

```bash
php artisan serve
```

---

## API Endpoints

---

### 1️ Create Task

**POST** `/api/tasks`

#### Rules:

* `title` must be unique per `due_date`
* `priority`: low | medium | high
* `due_date` must be today or future

#### Example Request:

```json
{
  "title": "Finish assignment",
  "due_date": "2026-04-01",
  "priority": "high"
}
```

#### Response:

```json
{
  "id": 1,
  "title": "Finish assignment",
  "due_date": "2026-04-01",
  "priority": "high",
  "status": "pending"
}
```

---

### 2️ List Tasks

**GET** `/api/tasks`

#### Features:

* Sorted by:

  * Priority (high → low)
  * Then due_date (ascending)
* Optional filter:

```
/api/tasks?status=pending
```

#### Empty Response:

```json
{
  "message": "No tasks found"
}
```

---

### 3️ Update Task Status

**PATCH** `/api/tasks/{id}/status`

#### Rules:

* Allowed transitions:

  * pending → in_progress → done
* Cannot:

  * Skip states
  * Revert backward

#### Example Request:

```json
{
  "status": "in_progress"
}
```

---

### 4️ Delete Task

**DELETE** `/api/tasks/{id}`

#### Rules:

* Only tasks with status `done` can be deleted
* Otherwise returns:

```json
{
  "error": "Only completed tasks can be deleted"
}
```

---

### 5 Daily Report (Bonus)

**GET** `/api/tasks/report?date=YYYY-MM-DD`

#### Example:

```
/api/tasks/report?date=2026-03-28
```

#### Response:

```json
{
  "date": "2026-03-28",
  "summary": {
    "high": {"pending": 2, "in_progress": 1, "done": 0},
    "medium": {"pending": 1, "in_progress": 0, "done": 3},
    "low": {"pending": 0, "in_progress": 0, "done": 1}
  }
}
```

---

## 🎨 Frontend Integration (Placeholder)

This API is designed to be consumed by a frontend application (e.g., React, Vue.js, or mobile app).

### Suggested UI Features:
- Task list with sorting and filtering
- Create/edit task forms with validation
- Status update buttons with progress flow
- Daily report dashboard
- Responsive design for mobile/desktop

### Integration Notes:
- Use the API endpoints documented above
- Handle authentication if added later
- Implement client-side validation matching server rules
- Use libraries like Axios or Fetch for HTTP requests

*(This section is a placeholder for future UI development)*

---

## Deployment Instructions

You can deploy using platforms like:

### Option 1: Railway

1. Create a new project on Railway
2. Add MySQL database
3. Set environment variables from `.env`
4. Run:

```
php artisan migrate --force
```

---

### Option 2: Render

1. Create a Web Service
2. Connect GitHub repo
3. Add MySQL database
4. Set environment variables
5. Deploy and run migrations

---

## Testing the API

### Using Postman

Postman is a popular tool for testing REST APIs. Here's how to use it for this project:

1. **Download and Install Postman**: Get it from [postman.com](https://www.postman.com/downloads/).

2. **Set Up Environment**:
   - Create a new environment in Postman.
   - Add a variable `base_url` with value `http://localhost:8000` (for local testing) or your deployed URL.

3. **Create Requests for Each Endpoint**:

   - **Create Task**:
     - Method: POST
     - URL: `{{base_url}}/api/tasks`
     - Headers: `Content-Type: application/json`
     - Body (raw JSON):
       ```json
       {
         "title": "Finish assignment",
         "due_date": "2026-04-01",
         "priority": "high"
       }
       ```
     - Expected: 201 Created with task data.

   - **List Tasks**:
     - Method: GET
     - URL: `{{base_url}}/api/tasks` (or `{{base_url}}/api/tasks?status=pending` for filtering)
     - Headers: None required
     - Expected: 200 OK with array of tasks or message if empty.

   - **Update Task Status**:
     - Method: PATCH
     - URL: `{{base_url}}/api/tasks/{id}/status` (replace {id} with actual task ID)
     - Headers: `Content-Type: application/json`
     - Body:
       ```json
       {
         "status": "in_progress"
       }
       ```
     - Expected: 200 OK or 422 if invalid transition.

   - **Delete Task**:
     - Method: DELETE
     - URL: `{{base_url}}/api/tasks/{id}`
     - Expected: 204 No Content if successful, 403 if not done.

   - **Daily Report**:
     - Method: GET
     - URL: `{{base_url}}/api/tasks/report?date=2026-03-28`
     - Expected: 200 OK with summary JSON.

4. **Run Tests**: Click "Send" for each request. Check the response status and body.

5. **Alternatives**:
   - **Thunder Client**: VS Code extension for similar functionality.
   - **cURL**: Command-line tool, e.g., `curl -X POST {{base_url}}/api/tasks -H "Content-Type: application/json" -d '{"title":"Test","due_date":"2026-04-01","priority":"medium"}'`

Ensure the Laravel server is running (`php artisan serve`) before testing.


---

## Evaluation Criteria Addressed

* ✔ Business rules enforced (validation + logic)
* ✔ Proper Laravel structure (Controllers, Models, Migrations)
* ✔ Clean and readable code
* ✔ RESTful API design
* ✔ MySQL integration
* ✔ Ready for deployment

---

## Submission

* Hosted API (if deployed)
* GitHub repository
* README with setup + usage

**Deadline:** Wednesday, 1st April 2026, 2:00 PM

---

## License

MIT License