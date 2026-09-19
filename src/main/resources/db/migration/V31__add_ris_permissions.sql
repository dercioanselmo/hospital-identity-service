-- v9 Delta Phase E: Radiology Information System -- study acknowledgement,
-- report finalization/cancel-finalization, label/report printing and digital
-- delivery. Mirrors V30's Laboratory permission set.
INSERT INTO permissions (code, description) VALUES
    ('RADIOLOGY_STUDY_ACKNOWLEDGE', 'Acknowledge/unacknowledge a received imaging study'),
    ('RADIOLOGY_REPORT_FINALIZE', 'Finalize a radiology report as provisional or final'),
    ('RADIOLOGY_REPORT_FINALIZE_CANCEL', 'Cancel a finalized radiology report (elevated)'),
    ('RADIOLOGY_REPORT_MANAGE', 'Print labels/reports and mark a radiology report as digitally delivered');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'RADIOLOGIST'
  AND p.code IN ('RADIOLOGY_STUDY_ACKNOWLEDGE', 'RADIOLOGY_REPORT_FINALIZE', 'RADIOLOGY_REPORT_FINALIZE_CANCEL', 'RADIOLOGY_REPORT_MANAGE')
ON CONFLICT DO NOTHING;

-- SUPER_ADMIN does not automatically inherit new permissions (the V2-era CROSS JOIN rule only ran
-- once, at V2) -- explicit grant here per the standing lesson from incident #12/#20. HOSPITAL_ADMIN
-- gets the elevated cancel-finalization action too (v9 S37: "authorized users only").
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'SUPER_ADMIN'
  AND p.code IN ('RADIOLOGY_STUDY_ACKNOWLEDGE', 'RADIOLOGY_REPORT_FINALIZE', 'RADIOLOGY_REPORT_FINALIZE_CANCEL', 'RADIOLOGY_REPORT_MANAGE')
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN' AND p.code = 'RADIOLOGY_REPORT_FINALIZE_CANCEL'
ON CONFLICT DO NOTHING;
