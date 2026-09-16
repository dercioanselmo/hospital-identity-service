-- Phase 8b (hospital-reporting-service). No pre-existing permission code for
-- this domain -- genuinely new. Read-only: nothing creates report data via
-- the API, every row comes from a consumed Kafka event.
INSERT INTO permissions (code, description) VALUES
    ('REPORT_VIEW', 'View reporting read models (patients, appointments, revenue/billing)');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('HOSPITAL_ADMIN', 'ACCOUNTANT') AND p.code = 'REPORT_VIEW';
