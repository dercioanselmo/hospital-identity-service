-- Self-service profile (GET/PUT /me, POST /me/change-password): display
-- name, phone, and a small avatar image stored inline as a base64 data URL
-- (no new blob-storage infra needed for something this small).
ALTER TABLE users ADD COLUMN display_name VARCHAR(255);
ALTER TABLE users ADD COLUMN phone VARCHAR(50);
ALTER TABLE users ADD COLUMN profile_photo_data_url TEXT;
