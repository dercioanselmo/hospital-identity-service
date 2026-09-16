-- Phase 5a (hospital-pharmacy-service) mirrors Laboratory's (V9) and
-- Radiology's (V10) permission shape: catalog management, claiming a queued
-- order, a pharmacist verification step, dispensing, and a distinct
-- completion (patient handoff) step.
INSERT INTO permissions (code, description) VALUES
    ('PHARMACY_ORDER_VIEW', 'View prescription orders and the medication catalog'),
    ('PHARMACY_MEDICATION_MANAGE', 'Manage the medication catalog'),
    ('PHARMACY_ORDER_RECEIVE', 'Receive (claim) a queued prescription order'),
    ('PHARMACY_ORDER_VERIFY', 'Verify a prescription order before dispensing'),
    ('PHARMACY_DISPENSE', 'Dispense medication for a prescription order'),
    ('PHARMACY_DISPENSE_COMPLETE', 'Complete a dispensing record (patient handoff)');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'PHARMACY_MEDICATION_MANAGE';

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'PHARMACIST'
  AND p.code IN ('PHARMACY_ORDER_VIEW', 'PHARMACY_ORDER_RECEIVE', 'PHARMACY_ORDER_VERIFY',
                 'PHARMACY_DISPENSE', 'PHARMACY_DISPENSE_COMPLETE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR' AND p.code = 'PHARMACY_ORDER_VIEW';
