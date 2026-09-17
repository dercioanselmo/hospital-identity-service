-- Coded procedure catalog in hospital-administration-service, deferred
-- from Phase 5b-1/5b-3 (docs/development-plan.md non-goal). Same shape as
-- the existing MEDICAL_SERVICE_*/DEPARTMENT_* pair from V4.
INSERT INTO permissions (code, description) VALUES
    ('PROCEDURE_VIEW', 'View the coded procedure catalog'),
    ('PROCEDURE_MANAGE', 'Create/update/delete procedure catalog entries');

-- SUPER_ADMIN already gets every permission via the CROSS JOIN rule in
-- V2__seed_roles_and_permissions.sql; nothing to add there.

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code IN ('PROCEDURE_VIEW', 'PROCEDURE_MANAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('DOCTOR', 'NURSE') AND p.code = 'PROCEDURE_VIEW';
