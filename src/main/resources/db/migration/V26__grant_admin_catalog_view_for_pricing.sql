-- Service Catalog Pricing (sub-phase A): the new Administration UI tabs for
-- Lab Tests/Radiology Exams/Medications need to actually list these catalogs
-- to manage their prices. HOSPITAL_ADMIN/SUPER_ADMIN already had the
-- corresponding *_MANAGE permissions (V9/V10/V11) but never the *_ORDER_VIEW
-- permissions those GET endpoints are gated by -- same recurring
-- "SUPER_ADMIN doesn't get new permissions automatically" gap as incident #12.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('HOSPITAL_ADMIN', 'SUPER_ADMIN')
  AND p.code IN ('LAB_ORDER_VIEW', 'RADIOLOGY_ORDER_VIEW', 'PHARMACY_ORDER_VIEW')
ON CONFLICT DO NOTHING;
