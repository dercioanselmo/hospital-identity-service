-- V8 granted CLINICAL_ORDER_FULFILL to the three receiving-department roles
-- (for claiming/completing an order once received), but never granted them
-- CLINICAL_ORDER_VIEW -- so none of them could query Clinical's own queue
-- (GET /clinical/orders?targetDepartmentId=...) to see what's pending before
-- receiving it. Phase 9b's Laboratory/Radiology/Pharmacy workspaces need this.
-- SUPER_ADMIN already has CLINICAL_ORDER_VIEW via V7's full-permission
-- CROSS JOIN, so no separate grant needed here.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('LAB_TECHNICIAN', 'RADIOLOGIST', 'PHARMACIST')
  AND p.code = 'CLINICAL_ORDER_VIEW'
ON CONFLICT DO NOTHING;
