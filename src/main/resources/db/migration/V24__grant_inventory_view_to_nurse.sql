-- Nurses can already consume inventory products (INVENTORY_CONSUME, V13) but
-- were never granted INVENTORY_VIEW, so the nurse workspace's own product
-- list/dropdown (needed to pick what to consume) 403'd on load, which also
-- surfaced as a generic "failed to load data" error for the whole page.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'NURSE' AND p.code = 'INVENTORY_VIEW'
ON CONFLICT DO NOTHING;
