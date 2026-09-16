-- V2's "SUPER_ADMIN gets every permission" rule was a one-time
-- INSERT ... SELECT CROSS JOIN against whatever permissions existed when V2
-- ran — it is not a live/retroactive rule. V4 added new permissions
-- (DEPARTMENT_*, SPECIALTY_*, MEDICAL_SERVICE_*, STAFF_*) without granting
-- them to SUPER_ADMIN. This closes that gap and must be repeated for any
-- future migration that adds new permissions: explicitly grant SUPER_ADMIN
-- every new permission code, don't assume it already has it.

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;
