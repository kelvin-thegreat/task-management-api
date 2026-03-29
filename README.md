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

## Database Schema

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

## Setup Instructions (Local)

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
php artisan key: generate
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
<img width="956" height="321" alt="image" src="https://github.com/user-attachments/assets/e432bb62-cfbe-43d1-931d-8109c578ce0a" />

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
<img width="956" height="410" alt="image" src="https://github.com/user-attachments/assets/d1dbf0ac-ef89-458c-83fc-ad8a0f14753b" />

---

### 2️ List Tasks

**GET** `http://127.0.0.1:8000/api/tasks`

<img width="1919" height="931" alt="image" src="https://github.com/user-attachments/assets/1e836bec-7f1f-4442-95aa-81b8d35878fc" />

#### Features As shown Above:

* Sorted by:
  * Priority (high → low)
  * Then due_date (ascending)
* Optional filter:

```
http://127.0.0.1:8000/api/tasks?status=pending
```

#### Non Empty Response:
<img width="1919" height="708" alt="image" src="https://github.com/user-attachments/assets/4de943c1-0f81-4b6a-9028-80e835bd9d96" />

```json
[
    {
        "id": 25,
        "title": "Machine Learning Proposal",
        "due_date": "2026-03-30",
        "priority": "high",
        "status": "pending",
        "created_at": "2026-03-29T01:34:33.000000Z",
        "updated_at": "2026-03-29T01:34:33.000000Z"
    },
    {
        "id": 16,
        "title": "Performance Test",
        "due_date": "2026-04-13",
        "priority": "high",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 19,
        "title": "Backup Data",
        "due_date": "2026-04-16",
        "priority": "high",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 1,
        "title": "Design API",
        "due_date": "2026-03-29",
        "priority": "medium",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 20,
        "title": "Final Submission",
        "due_date": "2026-04-17",
        "priority": "medium",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 2,
        "title": "Fix Bug",
        "due_date": "2026-03-30",
        "priority": "low",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 6,
        "title": "Optimize Code",
        "due_date": "2026-04-03",
        "priority": "low",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    },
    {
        "id": 18,
        "title": "Monitor Logs",
        "due_date": "2026-04-15",
        "priority": "low",
        "status": "pending",
        "created_at": "2026-03-28T22:50:23.000000Z",
        "updated_at": "2026-03-28T22:50:23.000000Z"
    }
]
```


```
http://127.0.0.1:8000/api/tasks?status=low
```

#### Empty Response with relevant error message:
<img width="1907" height="522" alt="image" src="https://github.com/user-attachments/assets/482faf30-ed90-4fbd-84c1-0d53293676a0" />


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
  * Revert backwards

#### Example Request:

```json
{
    "status": "in_progress"
}
```
<img width="1563" height="537" alt="image" src="https://github.com/user-attachments/assets/99538652-d36a-4685-aa13-59bb106a14ab" />

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

<img width="1576" height="395" alt="image" src="https://github.com/user-attachments/assets/5273aa9c-44f5-4776-8df9-c172e932b438" />

---

### 5 Daily Report (Bonus)

**GET** `http://127.0.0.1:8000/api/tasks/report?date=YYYY-MM-DD`

#### Example:

```
GET http://127.0.0.1:8000/api/tasks/report?date=2026-03-28
```

#### Response:

```json
{
    "date": "2026-03-28",
    "summary": {
        "high": {
            "pending": 0,
            "in_progress": 0,
            "done": 0
        },
        "medium": {
            "pending": 0,
            "in_progress": 0,
            "done": 0
        },
        "low": {
            "pending": 0,
            "in_progress": 0,
            "done": 0
        }
    }
}
```
<img width="1914" height="689" alt="image" src="https://github.com/user-attachments/assets/5e0b481c-7f9e-4a67-9d4c-565323dfee0b" />

---

## Frontend Integration

<img width="1795" height="938" alt="image" src="https://github.com/user-attachments/assets/59aad19e-c9ec-412f-b65e-35a805b0c76c" />

Above is the designed User Interface for the API.

### Implemented UI Features:
- Task list with sorting and filtering
- Create/edit/update task forms with validation
- Status update buttons with progress flow
- Daily report dashboard
- Responsive design for mobile/desktop

### Integrations:
- Use the API endpoints documented above
- Handle authentication
- Implement client-side validation matching server rules
- Use Fetch for HTTP requests
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

4. **Run Tests**: Click "Send" for each request. Check the response status and body. Sample shown below

<img width="1919" height="1068" alt="image" src="https://github.com/user-attachments/assets/4110aa2f-4060-4e1d-a513-c8be2b6b33e4" />


6. **Alternatives**:
   - **Thunder Client**: VS Code extension for similar functionality.
   - **cURL**: Command-line tool, such as
      - `curl -X POST {{base_url}}/api/tasks -H "Content-Type: application/json" -d '{"title":"Test","due_date":"2026-04-01","priority":"medium"}'`

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
