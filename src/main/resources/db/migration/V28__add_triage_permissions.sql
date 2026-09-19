-- v9 Delta Phase B: standalone Patient Triage Module (hospital-clinical-service).
-- Reception and Nurses perform triage; Doctors and Admins need read visibility
-- (e.g. reviewing a triage that routed a patient to their department).
INSERT INTO permissions (code, description) VALUES
    ('TRIAGE_VIEW', 'View triage records'),
    ('TRIAGE_CREATE', 'Create triage records'),
    ('TRIAGE_UPDATE', 'Update, route, and link triage records to a patient');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('SUPER_ADMIN', 'HOSPITAL_ADMIN', 'RECEPTIONIST', 'NURSE')
  AND p.code IN ('TRIAGE_VIEW', 'TRIAGE_CREATE', 'TRIAGE_UPDATE')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR' AND p.code = 'TRIAGE_VIEW'
ON CONFLICT DO NOTHING;
