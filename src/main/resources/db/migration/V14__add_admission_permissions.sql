-- Phase 6a (hospital-admission-service). No pre-existing permission codes
-- for this domain (unlike Medical Inventory's INVENTORY_* from Phase 1) --
-- these are all genuinely new.
INSERT INTO permissions (code, description) VALUES
    ('ADMISSION_VIEW', 'View admissions, wards, and bed occupancy'),
    ('ADMISSION_CREATE', 'Admit a patient to a bed'),
    ('ADMISSION_TRANSFER', 'Transfer an admitted patient to a different bed'),
    ('ADMISSION_DISCHARGE', 'Discharge an admitted patient'),
    ('WARD_MANAGE', 'Manage the ward and bed catalog');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code IN ('ADMISSION_VIEW', 'WARD_MANAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('DOCTOR', 'NURSE')
  AND p.code IN ('ADMISSION_VIEW', 'ADMISSION_CREATE', 'ADMISSION_TRANSFER', 'ADMISSION_DISCHARGE');
