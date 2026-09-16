INSERT INTO permissions (code, description) VALUES
    ('APPOINTMENT_VIEW', 'View appointments and doctor schedules'),
    ('APPOINTMENT_CREATE', 'Book appointments'),
    ('APPOINTMENT_CANCEL', 'Cancel appointments'),
    ('DOCTOR_SCHEDULE_MANAGE', 'Create/delete doctor schedules'),
    ('CHECK_IN', 'Check a patient in for their appointment and assign a queue ticket');

-- Remember: SUPER_ADMIN does NOT get new permissions automatically (see V5's
-- comment) — grant explicitly here, same as V5 did retroactively for V4.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN'
  AND p.code IN ('APPOINTMENT_VIEW', 'APPOINTMENT_CREATE', 'APPOINTMENT_CANCEL', 'DOCTOR_SCHEDULE_MANAGE', 'CHECK_IN');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'RECEPTIONIST'
  AND p.code IN ('APPOINTMENT_VIEW', 'APPOINTMENT_CREATE', 'APPOINTMENT_CANCEL', 'CHECK_IN');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('DOCTOR', 'NURSE')
  AND p.code = 'APPOINTMENT_VIEW';
