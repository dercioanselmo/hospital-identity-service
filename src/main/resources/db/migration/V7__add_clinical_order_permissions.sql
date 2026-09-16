-- CLINICAL_RECORD_VIEW/CREATE/UPDATE already exist (Phase 1) and cover
-- Encounter/Notes/Diagnoses/Vitals. Clinical Orders get their own permissions
-- since routing them to a receiving department (Phase 4/5) is a distinct,
-- more consequential action than writing a note.
INSERT INTO permissions (code, description) VALUES
    ('CLINICAL_ORDER_VIEW', 'View clinical orders'),
    ('CLINICAL_ORDER_CREATE', 'Create and place clinical orders'),
    ('CLINICAL_ORDER_CANCEL', 'Cancel clinical orders');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN'
  AND p.code IN ('CLINICAL_ORDER_VIEW', 'CLINICAL_ORDER_CREATE', 'CLINICAL_ORDER_CANCEL');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR'
  AND p.code IN ('CLINICAL_ORDER_VIEW', 'CLINICAL_ORDER_CREATE', 'CLINICAL_ORDER_CANCEL');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'NURSE'
  AND p.code = 'CLINICAL_ORDER_VIEW';
