-- Phase 7a (hospital-billing-service). BILLING_VIEW/INVOICE_CREATE/PAYMENT_CREATE
-- already exist from V2 (granted to BILLING_STAFF and, VIEW-only, to
-- ACCOUNTANT). CHARGE_CREATE and REFUND_CREATE are the only genuinely new
-- permissions this phase needs.
INSERT INTO permissions (code, description) VALUES
    ('CHARGE_CREATE', 'Create and void billable charges'),
    ('REFUND_CREATE', 'Record a refund against a payment');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'BILLING_STAFF' AND p.code IN ('CHARGE_CREATE', 'REFUND_CREATE');
