-- Phase 5b-2 (AGENTS.md §28): Medical Consumable Consumption is recorded by
-- whoever is performing patient care, not just Pharmacy. INVENTORY_CONSUME
-- has existed since Phase 1's V2 (granted only to PHARMACIST at the time,
-- before this feature existed) — no new permission code is needed, just
-- wider role grants.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code IN ('DOCTOR', 'NURSE', 'STORE_KEEPER') AND p.code = 'INVENTORY_CONSUME';
