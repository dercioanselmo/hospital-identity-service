-- Phase 6b (hospital-emergency-service). No pre-existing permission codes
-- for this domain — all genuinely new. Granted along real ER role lines:
-- RECEPTIONIST registers (front-desk registration is already its job per
-- V2), NURSE triages, DOCTOR treats and disposes.
INSERT INTO permissions (code, description) VALUES
    ('EMERGENCY_VIEW', 'View emergency visits and the priority queue'),
    ('EMERGENCY_REGISTER', 'Register a new emergency visit'),
    ('EMERGENCY_TRIAGE', 'Triage an emergency visit and set its priority'),
    ('EMERGENCY_TREAT', 'Claim an emergency visit and begin treatment'),
    ('EMERGENCY_DISPOSE', 'Record the disposition of an emergency visit');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'EMERGENCY_VIEW';

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'RECEPTIONIST' AND p.code IN ('EMERGENCY_VIEW', 'EMERGENCY_REGISTER');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'NURSE' AND p.code IN ('EMERGENCY_VIEW', 'EMERGENCY_TRIAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR' AND p.code IN ('EMERGENCY_VIEW', 'EMERGENCY_TREAT', 'EMERGENCY_DISPOSE');
