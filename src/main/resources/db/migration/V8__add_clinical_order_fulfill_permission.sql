-- The generic department Work Queue "claim/ready/start/complete" actions
-- (docs/patient-journey.md) are distinct from ordering (CLINICAL_ORDER_CREATE)
-- or cancelling (CLINICAL_ORDER_CANCEL) — this is the receiving department's
-- technician fulfilling the order, not the ordering clinician.
INSERT INTO permissions (code, description) VALUES
    ('CLINICAL_ORDER_FULFILL', 'Claim, progress, and complete clinical orders as the receiving department');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('HOSPITAL_ADMIN', 'DOCTOR', 'NURSE', 'LAB_TECHNICIAN', 'RADIOLOGIST', 'PHARMACIST')
  AND p.code = 'CLINICAL_ORDER_FULFILL';
