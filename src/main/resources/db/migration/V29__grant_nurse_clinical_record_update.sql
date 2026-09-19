-- v9 Delta Phase C: Nurse Visit Dashboard actions (nurse-acknowledge, assign-doctor) are
-- gated on CLINICAL_RECORD_UPDATE, same as the doctor's close/cancel/disposition actions.
-- NURSE has had CLINICAL_RECORD_VIEW/CREATE since V2 but never CLINICAL_RECORD_UPDATE --
-- a real gap: nurses could create notes/vitals but never update anything on an encounter.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'NURSE' AND p.code = 'CLINICAL_RECORD_UPDATE'
ON CONFLICT DO NOTHING;
