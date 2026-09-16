INSERT INTO roles (code, description) VALUES
    ('SUPER_ADMIN', 'Full system access'),
    ('HOSPITAL_ADMIN', 'Hospital administration and master-data configuration'),
    ('DOCTOR', 'Physician'),
    ('NURSE', 'Nursing staff'),
    ('RECEPTIONIST', 'Front-desk registration and check-in'),
    ('PHARMACIST', 'Pharmacy dispensing'),
    ('LAB_TECHNICIAN', 'Laboratory sample processing'),
    ('RADIOLOGIST', 'Radiology imaging and reporting'),
    ('BILLING_STAFF', 'Billing and invoicing'),
    ('ACCOUNTANT', 'Financial reporting'),
    ('PATIENT', 'Patient portal access');

INSERT INTO permissions (code, description) VALUES
    ('PATIENT_VIEW', 'View patient records'),
    ('PATIENT_CREATE', 'Create patient records'),
    ('PATIENT_UPDATE', 'Update patient records'),
    ('CLINICAL_RECORD_VIEW', 'View clinical records'),
    ('CLINICAL_RECORD_CREATE', 'Create clinical records'),
    ('CLINICAL_RECORD_UPDATE', 'Update clinical records'),
    ('LAB_ORDER_VIEW', 'View laboratory orders'),
    ('LAB_RESULT_CREATE', 'Create laboratory results'),
    ('INVENTORY_VIEW', 'View inventory'),
    ('INVENTORY_RECEIVE', 'Receive inventory stock'),
    ('INVENTORY_TRANSFER', 'Transfer inventory stock'),
    ('INVENTORY_CONSUME', 'Consume inventory stock'),
    ('INVENTORY_ADJUST', 'Adjust inventory stock'),
    ('BILLING_VIEW', 'View billing information'),
    ('INVOICE_CREATE', 'Create invoices'),
    ('PAYMENT_CREATE', 'Record payments'),
    ('USER_MANAGE', 'Create and manage users'),
    ('ROLE_MANAGE', 'Manage roles and permissions');

-- SUPER_ADMIN gets every permission.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p WHERE r.code = 'SUPER_ADMIN';

-- HOSPITAL_ADMIN gets everything except direct clinical documentation.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'HOSPITAL_ADMIN'
  AND p.code IN ('PATIENT_VIEW', 'PATIENT_CREATE', 'PATIENT_UPDATE', 'INVENTORY_VIEW',
                 'BILLING_VIEW', 'USER_MANAGE', 'ROLE_MANAGE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'DOCTOR'
  AND p.code IN ('PATIENT_VIEW', 'CLINICAL_RECORD_VIEW', 'CLINICAL_RECORD_CREATE',
                 'CLINICAL_RECORD_UPDATE', 'LAB_ORDER_VIEW');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'NURSE' AND p.code IN ('PATIENT_VIEW', 'CLINICAL_RECORD_VIEW', 'CLINICAL_RECORD_CREATE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'RECEPTIONIST' AND p.code IN ('PATIENT_VIEW', 'PATIENT_CREATE', 'PATIENT_UPDATE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'PHARMACIST' AND p.code IN ('INVENTORY_VIEW', 'INVENTORY_CONSUME');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'LAB_TECHNICIAN' AND p.code IN ('LAB_ORDER_VIEW', 'LAB_RESULT_CREATE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'BILLING_STAFF' AND p.code IN ('BILLING_VIEW', 'INVOICE_CREATE', 'PAYMENT_CREATE');

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.code = 'ACCOUNTANT' AND p.code IN ('BILLING_VIEW');
