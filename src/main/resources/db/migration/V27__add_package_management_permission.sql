-- Packages and price lists (Service Catalog Pricing sub-phase B+), both in
-- hospital-administration-service. One shared permission for both, same as
-- how Medical Services/Procedures/Departments each got their own *_MANAGE
-- pair -- packages and price lists are both pure pricing-configuration
-- actions, so a single PACKAGE_MANAGE covers both rather than adding a
-- second near-identical permission. GET endpoints for both stay ungated
-- (any authenticated user), matching every other catalog list endpoint.
INSERT INTO permissions (code, description) VALUES
    ('PACKAGE_MANAGE', 'Create packages/price lists and manage their prices');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('HOSPITAL_ADMIN', 'SUPER_ADMIN') AND p.code = 'PACKAGE_MANAGE'
ON CONFLICT DO NOTHING;
