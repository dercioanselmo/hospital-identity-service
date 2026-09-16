-- Phase 7b (hospital-insurance-service). No pre-existing permission codes for
-- this domain (unlike Billing's Phase 1-seeded ones) -- these are all genuinely new.
INSERT INTO permissions (code, description) VALUES
    ('INSURANCE_VIEW', 'View insurance providers, plans, coverage rules, policies, preauthorizations, and claims'),
    ('INSURANCE_MANAGE', 'Manage insurance providers, plans, and coverage rules'),
    ('POLICY_MANAGE', 'Register and cancel a patient insurance policy'),
    ('CLAIM_CREATE', 'Submit an insurance claim against an invoice'),
    ('CLAIM_PROCESS', 'Approve, deny, or mark an insurance claim as paid'),
    ('PREAUTH_CREATE', 'Request a preauthorization'),
    ('PREAUTH_DECIDE', 'Approve or deny a preauthorization request');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

-- Catalog management (providers/plans/coverage rules) is master-data admin work,
-- same reasoning as HOSPITAL_ADMIN's WARD_MANAGE grant in Phase 6a.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code IN ('INSURANCE_VIEW', 'INSURANCE_MANAGE');

-- Front-line insurance/billing work: registering a patient's policy, submitting
-- claims, requesting preauthorization -- same staff who already handle Billing's
-- CHARGE_CREATE/INVOICE_CREATE/PAYMENT_CREATE.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'BILLING_STAFF'
  AND p.code IN ('INSURANCE_VIEW', 'POLICY_MANAGE', 'CLAIM_CREATE', 'PREAUTH_CREATE');

-- Claim adjudication and preauthorization decisions are a financial-reconciliation
-- responsibility, same as ACCOUNTANT's existing BILLING_VIEW-only scope.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'ACCOUNTANT' AND p.code IN ('INSURANCE_VIEW', 'CLAIM_PROCESS', 'PREAUTH_DECIDE');
