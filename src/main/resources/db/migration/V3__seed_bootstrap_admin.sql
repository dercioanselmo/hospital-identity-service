INSERT INTO departments_ref (code, name) VALUES ('ADMIN', 'Administração');

-- Bootstrap SUPER_ADMIN so the system is usable before an admin UI exists
-- (AGENTS.md §18: users are otherwise admin-created only, never self-registered).
-- Local-dev-only credential — change in any real environment.
-- username: admin  password: ChangeMe123!
INSERT INTO users (username, email, password_hash, status)
VALUES ('admin', 'admin@mva.local', crypt('ChangeMe123!', gen_salt('bf')), 'ACTIVE');

INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u CROSS JOIN roles r
WHERE u.username = 'admin' AND r.code = 'SUPER_ADMIN';

INSERT INTO user_departments (user_id, department_ref_id)
SELECT u.id, d.id FROM users u CROSS JOIN departments_ref d
WHERE u.username = 'admin' AND d.code = 'ADMIN';
