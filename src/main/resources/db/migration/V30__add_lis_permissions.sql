-- v9 Delta Phase D: Laboratory Information System -- sample acknowledgement,
-- report finalization/cancel-finalization, label/report printing and digital
-- delivery, all new lab-technician actions beyond the existing
-- receive/collect/verify set.
INSERT INTO permissions (code, description) VALUES
    ('LAB_SAMPLE_ACKNOWLEDGE', 'Acknowledge/unacknowledge a received lab sample'),
    ('LAB_RESULT_FINALIZE', 'Finalize a lab result as provisional or final'),
    ('LAB_RESULT_FINALIZE_CANCEL', 'Cancel a finalized lab result (elevated)'),
    ('LAB_REPORT_MANAGE', 'Print labels/reports and mark a lab report as digitally delivered');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'LAB_TECHNICIAN'
  AND p.code IN ('LAB_SAMPLE_ACKNOWLEDGE', 'LAB_RESULT_FINALIZE', 'LAB_RESULT_FINALIZE_CANCEL', 'LAB_REPORT_MANAGE')
ON CONFLICT DO NOTHING;

-- SUPER_ADMIN does not automatically inherit new permissions (the V2-era CROSS JOIN rule only ran
-- once, at V2) -- explicit grant here per the standing lesson from incident #12/#20. HOSPITAL_ADMIN
-- gets the elevated cancel-finalization action too (v9 S36: "authorized users only").
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
  AND p.code IN ('LAB_SAMPLE_ACKNOWLEDGE', 'LAB_RESULT_FINALIZE', 'LAB_RESULT_FINALIZE_CANCEL', 'LAB_REPORT_MANAGE')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'LAB_RESULT_FINALIZE_CANCEL'
ON CONFLICT DO NOTHING;
