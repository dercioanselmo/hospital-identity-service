-- Phase 8a (hospital-notification-service). No pre-existing permission code
-- for this domain -- genuinely new. Read-only: nothing creates a
-- Notification via the API, every row comes from a consumed Kafka event.
INSERT INTO permissions (code, description) VALUES
    ('NOTIFICATION_VIEW', 'View sent notifications');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('HOSPITAL_ADMIN', 'RECEPTIONIST') AND p.code = 'NOTIFICATION_VIEW';
