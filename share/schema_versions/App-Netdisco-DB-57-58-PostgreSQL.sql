BEGIN;

ALTER TABLE users ADD COLUMN "local_control" boolean DEFAULT false;

UPDATE users SET local_control = TRUE WHERE admin = TRUE;

COMMIT;
