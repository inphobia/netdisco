BEGIN;

CREATE TABLE "device_vrf" (
    "ip" inet NOT NULL,
    "vrf" integer NOT NULL,
    "description" text,
    "up" text,
    "creation" timestamp DEFAULT now(),
    "last_discover" timestamp DEFAULT now(),
    PRIMARY KEY ("ip", "vrf")
);

COMMIT;
