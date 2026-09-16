-- Phase 5b-1 (hospital-medical-inventory-service). Five of the needed
-- permissions already existed since V2 (INVENTORY_VIEW, INVENTORY_RECEIVE,
-- INVENTORY_TRANSFER, INVENTORY_CONSUME, INVENTORY_ADJUST) — this migration
-- adds only the two genuinely new ones: catalog management (mirrors
-- LAB_TEST_MANAGE/RADIOLOGY_EXAM_MANAGE/PHARMACY_MEDICATION_MANAGE) and
-- issuing (AGENTS.md §25/26 — distinct from INVENTORY_CONSUME, which is
-- reserved for a future pass once consumption is wired to Clinical's
-- Encounter/Procedure).
INSERT INTO permissions (code, description) VALUES
    ('INVENTORY_PRODUCT_MANAGE', 'Manage the medical inventory product/supplier/location catalog'),
    ('INVENTORY_ISSUE', 'Issue medical inventory stock (FEFO) to a department or store');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

-- No dedicated stores/logistics role has existed until now — every other
-- receiving department (Laboratory, Radiology, Pharmacy) already had its own
-- role from Phase 1's seed. Medical Inventory is explicitly a separate
-- bounded context from Pharmacy (AGENTS.md §20), so it gets its own.
INSERT INTO roles (code, description) VALUES
    ('STORE_KEEPER', 'Medical inventory / stores management (hospital-wide consumables, separate from Pharmacy)');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'STORE_KEEPER'
  AND p.code IN ('INVENTORY_VIEW', 'INVENTORY_RECEIVE', 'INVENTORY_ISSUE', 'INVENTORY_ADJUST',
                 'INVENTORY_TRANSFER', 'INVENTORY_PRODUCT_MANAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'INVENTORY_PRODUCT_MANAGE';
