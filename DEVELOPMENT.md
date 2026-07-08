# PROPlan Development Guide

## Sprint 1 Status

**Goal**: Build the Operations Canvas MVP

### Week 1: Foundation ✅
- [x] Data models (Crew, Job, Staff, Vehicle)
- [x] Flask backend skeleton
- [x] API endpoints structure
- [x] Frontend HTML/CSS layout
- [x] Mock data for demo

### Week 2: Features & Polish
- [ ] Live drag-and-drop (jobs → crews)
- [ ] Drag staff onto jobs
- [ ] Drag vehicles onto jobs
- [ ] Three display modes
- [ ] TV Mode (read-only, auto-refresh)
- [ ] Supervisor Mode (mobile-optimized)
- [ ] Search & filter
- [ ] Real-time data sync

---

## Running Locally

### Backend

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
python app.py
```

Server runs on `http://localhost:5000`

### Frontend

Open `frontend/index.html` in your browser, or serve with a simple HTTP server:

```bash
cd frontend
python -m http.server 8000
```

Then visit `http://localhost:8000`

---

## Database Schema

### Crews
```
id (PK)
name
supervisor_id (FK)
supervisor_name
```

### Jobs
```
id (PK)
job_code
name
location
job_type (INSTALL, ALTERATION, DISMANTLE)
crew_id (FK)
date
status (pending, in_progress, completed)
notes
created_at
updated_at
```

### Staff
```
id (PK)
name
role (Supervisor, Tradesperson, Labourer)
crew_id (FK)
available (bool)
skills (JSON)
induction_complete (bool)
```

### Vehicles
```
id (PK)
rego
vehicle_type (Truck, Ute, Trailer)
status (available, in_use, maintenance)
assigned_job_id (FK)
assigned_crew_id (FK)
```

### Assignments
```
id (PK)
job_id (FK)
crew_id (FK)
entity_id (Staff or Vehicle ID)
entity_type (staff, vehicle)
assigned_at
status
```

---

## Architecture Notes

### Frontend Structure
```
frontend/
├── index.html         # Main app shell
├── css/
│   ├── styles.css     # Global styles
│   ├── dispatch-mode.css
│   ├── tv-mode.css
│   └── supervisor-mode.css
└── js/
    ├── app.js         # Main app logic
    ├── api.js         # API client
    ├── canvas.js      # Canvas rendering
    ├── drag.js        # Drag-and-drop
    └── modes.js       # Mode switching
```

### Backend Structure
```
backend/
├── app.py             # Flask server
├── models.py          # Data models
├── routes.py          # API routes
├── db.py              # Database setup
└── requirements.txt   # Dependencies
```

### Communication
- Frontend makes REST API calls to backend
- Backend returns JSON
- No build step, no npm install required

---

## Next Steps

### To complete Sprint 1:

1. **Connect backend to database** (PostgreSQL or SQLite)
2. **Implement database models** in SQLAlchemy
3. **Populate API endpoints** with actual database queries
4. **Test drag-and-drop** across all three modes
5. **Add WebSocket support** for real-time updates
6. **Deploy to web server** (Render, Fly.io, DigitalOcean)
7. **Test on 75-inch TV** for TV Mode

---

## Questions to Answer

1. **Data source**: How do we get existing crew/job/staff data into the system?
2. **Authentication**: Do dispatchers need to log in?
3. **Real-time sync**: How many devices need to see updates simultaneously?
4. **Data persistence**: Is SQLite enough, or do we need PostgreSQL?
5. **Server hosting**: Which platform do you prefer?

---

## Key Files to Review

- `frontend/index.html` - Main app shell
- `frontend/js/app.js` - App initialization and logic
- `frontend/js/drag.js` - Drag-and-drop handlers
- `backend/app.py` - Flask server and routes
- `backend/models.py` - Data structure
