-- V20 incorrectly assumed SUPER_ADMIN gets every permission automatically
-- via a "CROSS JOIN rule" -- that CROSS JOIN only ran once, at the time
-- V2 was applied, and only covered the permissions that existed then.
-- Every permission added since needs its own explicit SUPER_ADMIN grant
-- (see CONTEXT.md's "New permission gotcha," already fixed correctly in
-- every migration since V6 except V4 and this one's own V20 -- V4 predates
-- the fix, V20 is a fresh mistake that copied V4's stale comment instead
-- of the corrected pattern). Never editing an already-applied migration,
-- per this project's convention -- fixing it forward instead.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN' AND p.code IN ('PROCEDURE_VIEW', 'PROCEDURE_MANAGE')
ON CONFLICT DO NOTHING;
