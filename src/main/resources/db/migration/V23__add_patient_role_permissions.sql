-- Phase 9g: the PATIENT role has existed since Phase 1's V2 seed with zero
-- permissions ever granted -- a placeholder until the Patient portal existed
-- to use it. Narrow, read-only set: own demographics, appointments,
-- prescriptions, lab/imaging results, and billing. The self-service
-- notification inbox needs no permission at all (open to any authenticated
-- user since Phase 8d).
--
-- Known, flagged limitation (see docs/security.md): these permissions are
-- coarse role-based (hasAuthority), not row-level -- nothing stops a valid
-- PATIENT token from querying a different patientId directly against these
-- endpoints if it knew/guessed the ID. True of every role in this platform,
-- but matters more now that PATIENT is the first externally-issued role.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'PATIENT'
  AND p.code IN (
    'PATIENT_VIEW',
    'APPOINTMENT_VIEW',
    'PHARMACY_ORDER_VIEW',
    'LAB_ORDER_VIEW',
    'RADIOLOGY_ORDER_VIEW',
    'BILLING_VIEW'
  )
ON CONFLICT DO NOTHING;
