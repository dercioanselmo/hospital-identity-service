-- Phase 4b (hospital-radiology-service) mirrors Phase 4a's laboratory permission
-- shape: catalog management, claiming a queued order, performing the study,
-- creating the report, and a distinct verification step.
INSERT INTO permissions (code, description) VALUES
    ('RADIOLOGY_ORDER_VIEW', 'View imaging orders and the imaging exam catalog'),
    ('RADIOLOGY_EXAM_MANAGE', 'Manage the imaging exam catalog'),
    ('RADIOLOGY_ORDER_RECEIVE', 'Receive (claim) a queued imaging order'),
    ('RADIOLOGY_STUDY_PERFORM', 'Record a performed imaging study and start reporting'),
    ('RADIOLOGY_REPORT_CREATE', 'Create a radiology report'),
    ('RADIOLOGY_REPORT_VERIFY', 'Verify a radiology report');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'RADIOLOGY_EXAM_MANAGE';

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'RADIOLOGIST'
  AND p.code IN ('RADIOLOGY_ORDER_VIEW', 'RADIOLOGY_ORDER_RECEIVE', 'RADIOLOGY_STUDY_PERFORM',
                 'RADIOLOGY_REPORT_CREATE', 'RADIOLOGY_REPORT_VERIFY');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR' AND p.code = 'RADIOLOGY_ORDER_VIEW';
