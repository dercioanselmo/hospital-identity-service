-- LAB_ORDER_VIEW and LAB_RESULT_CREATE already existed since Phase 1 (V2) —
-- these are the additional actions Phase 4a's hospital-laboratory-service
-- needs: catalog management, claiming a queued order, sample collection, and
-- result verification (a distinct, more consequential step than creating the
-- result).
INSERT INTO permissions (code, description) VALUES
    ('LAB_TEST_MANAGE', 'Manage the laboratory test catalog'),
    ('LAB_ORDER_RECEIVE', 'Receive (claim) a queued laboratory order'),
    ('LAB_SAMPLE_COLLECT', 'Record sample collection and start processing'),
    ('LAB_RESULT_VERIFY', 'Verify a laboratory result');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'LAB_TEST_MANAGE';

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'LAB_TECHNICIAN'
  AND p.code IN ('LAB_ORDER_RECEIVE', 'LAB_SAMPLE_COLLECT', 'LAB_RESULT_VERIFY');
