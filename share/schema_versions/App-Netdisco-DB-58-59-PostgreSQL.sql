BEGIN;

CREATE TABLE "local_device"
(
    ip          inet NOT NULL PRIMARY KEY,
    creation    timestamp without time zone DEFAULT now(),
    dns         text,
    description text,
    uptime      bigint,
    contact     text,
    name        text,
    location    text,
    layers      character varying(8),
    ports       integer,
    mac         macaddr,
    serial      text,
    model       text,
    slots       integer,
    vendor      text,
    os          text,
    os_ver      text,
    log         text,
    snmp_ver    integer,
    snmp_comm   text,
    snmp_class  text,
    vtp_domain  text
);

COMMIT;
