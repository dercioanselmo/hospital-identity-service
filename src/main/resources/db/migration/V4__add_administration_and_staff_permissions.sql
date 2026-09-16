INSERT INTO permissions (code, description) VALUES
    ('DEPARTMENT_VIEW', 'View departments'),
    ('DEPARTMENT_MANAGE', 'Create/update/delete departments'),
    ('SPECIALTY_VIEW', 'View medical specialties'),
    ('SPECIALTY_MANAGE', 'Create/update/delete medical specialties'),
    ('MEDICAL_SERVICE_VIEW', 'View the medical service catalog'),
    ('MEDICAL_SERVICE_MANAGE', 'Create/update/delete medical services'),
    ('STAFF_VIEW', 'View staff members'),
    ('STAFF_MANAGE', 'Create/update/delete staff members and their specialty/department links');

-- SUPER_ADMIN already gets every permission via the CROSS JOIN rule in
-- V2__seed_roles_and_permissions.sql; nothing to add there.

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN'
  AND p.code IN ('DEPARTMENT_VIEW', 'DEPARTMENT_MANAGE', 'SPECIALTY_VIEW', 'SPECIALTY_MANAGE',
                 'MEDICAL_SERVICE_VIEW', 'MEDICAL_SERVICE_MANAGE', 'STAFF_VIEW', 'STAFF_MANAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('DOCTOR', 'NURSE', 'RECEPTIONIST')
  AND p.code IN ('DEPARTMENT_VIEW', 'SPECIALTY_VIEW', 'MEDICAL_SERVICE_VIEW', 'STAFF_VIEW');
