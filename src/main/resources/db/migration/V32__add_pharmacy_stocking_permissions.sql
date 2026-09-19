-- v9 Delta Phase F: Pharmacy Stocking Module -- GRN, Supplier Return, Opening Balance and Stock
-- Adjustment, each with save-then-post semantics. Opening Balance and Adjustment-approval are
-- deliberately elevated (v9 S32: "ordinary pharmacy users must not be able to freely
-- increase/decrease stock without the appropriate permission").
INSERT INTO permissions (code, description) VALUES
    ('PHARMACY_STOCK_VIEW', 'View pharmacy stock: batches, transactions, GRNs, returns, opening balances, adjustments'),
    ('PHARMACY_STORE_MANAGE', 'Create/manage pharmacy stores/locations (elevated)'),
    ('PHARMACY_GRN_CREATE', 'Create a draft Goods Received Note'),
    ('PHARMACY_GRN_POST', 'Post a Goods Received Note, applying stock'),
    ('PHARMACY_RETURN_CREATE', 'Create a draft Supplier Return'),
    ('PHARMACY_RETURN_POST', 'Post a Supplier Return, removing stock'),
    ('PHARMACY_OPENING_BALANCE', 'Create and post Opening Balance entries (elevated, go-live stock)'),
    ('PHARMACY_ADJUSTMENT_CREATE', 'Create a draft Stock Adjustment'),
    ('PHARMACY_ADJUSTMENT_APPROVE', 'Approve and post a Stock Adjustment (elevated)');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'PHARMACIST'
  AND p.code IN (
      'PHARMACY_STOCK_VIEW', 'PHARMACY_GRN_CREATE', 'PHARMACY_GRN_POST', 'PHARMACY_RETURN_CREATE',
      'PHARMACY_RETURN_POST', 'PHARMACY_ADJUSTMENT_CREATE')
ON CONFLICT DO NOTHING;

-- SUPER_ADMIN does not automatically inherit new permissions (the V2-era CROSS JOIN rule only ran
-- once, at V2) -- explicit grant here per the standing lesson from incident #12/#20.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
  AND p.code IN (
      'PHARMACY_STOCK_VIEW', 'PHARMACY_STORE_MANAGE', 'PHARMACY_GRN_CREATE', 'PHARMACY_GRN_POST',
      'PHARMACY_RETURN_CREATE', 'PHARMACY_RETURN_POST', 'PHARMACY_OPENING_BALANCE',
      'PHARMACY_ADJUSTMENT_CREATE', 'PHARMACY_ADJUSTMENT_APPROVE')
ON CONFLICT DO NOTHING;

-- HOSPITAL_ADMIN gets the elevated actions: store management, opening balance and adjustment approval.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN'
  AND p.code IN ('PHARMACY_STOCK_VIEW', 'PHARMACY_STORE_MANAGE', 'PHARMACY_OPENING_BALANCE', 'PHARMACY_ADJUSTMENT_APPROVE')
ON CONFLICT DO NOTHING;
