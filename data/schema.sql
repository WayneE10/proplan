-- PROPlan PostgreSQL Schema
-- Simple, clean, focused on essentials

-- ============================================================================
-- CREWS TABLE
-- ============================================================================

CREATE TABLE crews (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    supervisor_id INTEGER NOT NULL,
    supervisor_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_crews_supervisor_id ON crews(supervisor_id);

-- ============================================================================
-- JOBS TABLE
-- ============================================================================

CREATE TABLE jobs (
    id SERIAL PRIMARY KEY,
    job_code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    job_type VARCHAR(50) NOT NULL, -- INSTALL, ALTERATION, DISMANTLE
    crew_id INTEGER,
    status VARCHAR(50) DEFAULT 'pending', -- pending, in_progress, completed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (crew_id) REFERENCES crews(id) ON DELETE SET NULL
);

CREATE INDEX idx_jobs_crew_id ON jobs(crew_id);
CREATE INDEX idx_jobs_status ON jobs(status);

-- ============================================================================
-- STAFF TABLE
-- ============================================================================

CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(100) NOT NULL, -- Supervisor, Tradesperson, Labourer
    crew_id INTEGER,
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (crew_id) REFERENCES crews(id) ON DELETE SET NULL
);

CREATE INDEX idx_staff_crew_id ON staff(crew_id);
CREATE INDEX idx_staff_available ON staff(available);

-- ============================================================================
-- VEHICLES TABLE
-- ============================================================================

CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    rego VARCHAR(20) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50) NOT NULL, -- Truck, Ute, Trailer
    status VARCHAR(50) DEFAULT 'available', -- available, in_use, maintenance
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vehicles_status ON vehicles(status);

-- ============================================================================
-- JOB_ASSIGNMENTS TABLE (join table for jobs and staff/vehicles)
-- ============================================================================

CREATE TABLE job_assignments (
    id SERIAL PRIMARY KEY,
    job_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL, -- staff_id or vehicle_id
    entity_type VARCHAR(20) NOT NULL, -- 'staff' or 'vehicle'
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
);

CREATE INDEX idx_job_assignments_job_id ON job_assignments(job_id);
CREATE INDEX idx_job_assignments_entity ON job_assignments(entity_id, entity_type);

-- ============================================================================
-- SAMPLE DATA (for demo)
-- ============================================================================

-- Insert crews
INSERT INTO crews (name, supervisor_id, supervisor_name) VALUES
('Chris S', 1, 'Chris S'),
('Michael S', 2, 'Michael S'),
('George S', 3, 'George S'),
('Rocky S', 4, 'Rocky S');

-- Insert staff
INSERT INTO staff (name, role, crew_id, available) VALUES
('Chris', 'Supervisor', 1, true),
('George', 'Tradesperson', 1, true),
('Keith', 'Labourer', 1, true),
('Sean', 'Tradesperson', 1, true),
('Michael', 'Supervisor', 2, true),
('Larry', 'Tradesperson', 2, true),
('Rocky', 'Tradesperson', 2, true),
('George S', 'Supervisor', 3, true),
('Sean S', 'Tradesperson', 3, true),
('Tom', 'Tradesperson', 3, true),
('Marc', 'Labourer', 3, true),
('Rocky S', 'Supervisor', 4, true),
('Keith K', 'Tradesperson', 4, true),
('Larry L', 'Tradesperson', null, true),
('Sean L', 'Tradesperson', null, true),
('Mala', 'Tradesperson', null, true),
('Wayne', 'Tradesperson', null, true),
('Khart', 'Labourer', null, true),
('Jordan', 'Labourer', null, true),
('Brad', 'Tradesperson', null, true),
('Alex', 'Tradesperson', null, true),
('Reece', 'Labourer', null, true);

-- Insert vehicles
INSERT INTO vehicles (rego, vehicle_type, status) VALUES
('Truck 1', 'Truck', 'available'),
('Truck 2', 'Truck', 'available'),
('Truck 3', 'Truck', 'available'),
('Truck 4', 'Truck', 'available'),
('Ute 1', 'Ute', 'available'),
('Ute 2', 'Ute', 'available'),
('Trailer 1', 'Trailer', 'available'),
('Trailer 2', 'Trailer', 'available');

-- Insert jobs
INSERT INTO jobs (job_code, name, location, job_type, crew_id, status) VALUES
('PB26015', 'Apollo', 'Christchurch Hospital', 'INSTALL', 1, 'pending'),
('PB26016', 'Apollo', 'Level 2 Offices', 'ALTERATION', 1, 'pending'),
('PB26017', 'Cook Brothers', 'Rolleston', 'DISMANTLE', 2, 'pending'),
('PB26018', 'Wolfbrook', 'Oakridge', 'INSTALL', 3, 'pending'),
('PB26019', 'DNA', 'Addington', 'ALTERATION', 3, 'pending'),
('PB26021', 'Cook Brothers', 'Precast Yard', 'INSTALL', 4, 'pending'),
('PB26022', 'Apollo', 'South Frame', 'INSTALL', null, 'pending'),
('PB26023', 'Cook Brothers', 'Site Office', 'ALTERATION', null, 'pending'),
('PB26024', 'DNA', 'Storage Shed', 'DISMANTLE', null, 'pending');

-- Insert job assignments (staff)
INSERT INTO job_assignments (job_id, entity_id, entity_type) VALUES
(1, 1, 'staff'), (1, 2, 'staff'),
(2, 2, 'staff'), (2, 3, 'staff'),
(3, 5, 'staff'),
(4, 8, 'staff'),
(5, 9, 'staff'),
(6, 12, 'staff');

-- Insert job assignments (vehicles)
INSERT INTO job_assignments (job_id, entity_id, entity_type) VALUES
(1, 1, 'vehicle'),
(3, 2, 'vehicle'),
(4, 3, 'vehicle'),
(6, 4, 'vehicle');
