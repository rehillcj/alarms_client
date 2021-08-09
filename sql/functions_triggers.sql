--CREATE DATABASE alarms_mqtt;
--ALTER DATABASE alarms_mqtt OWNER TO controller;

DROP TRIGGER update_mode ON mode;
DROP TRIGGER create_event_contact ON contact;
DROP TRIGGER create_event_sensor ON sensor;

--FUNCTIONS

DROP FUNCTION create_event_contact();
CREATE FUNCTION create_event_contact() RETURNS TRIGGER AS $create_event_contact$
--CREATE OR REPLACE FUNCTION create_event() RETURNS BOOLEAN AS $$
DECLARE
  varchar_script varchar;
  int_event integer;
BEGIN
  SELECT INTO varchar_script, int_event
              v_event_contact.script, v_event_contact.id
  FROM v_event_contact, mode, contact
   WHERE new.state != old.state 
   AND v_event_contact.mode = mode.id
   AND mode.active = 't'
   AND new.id = v_event_contact.contact
   AND new.state = v_event_contact.trip;

   --RAISE NOTICE 'script %', varchar_script;
   IF (varchar_script IS NOT NULL) THEN
      --RAISE NOTICE 'insert new event %', varchar_script;
      --INSERT INTO event_new (script, date_time) VALUES (varchar_script, now());
      INSERT INTO log (event_type, contact_sensor, date_time) VALUES ('1', int_event, now());
      perform pg_notify('new_event', varchar_script);
   END IF;
  RETURN new;
END;
--$$ LANGUAGE plpgsql;
$create_event_contact$ LANGUAGE plpgsql;


DROP FUNCTION create_event_sensor();
CREATE FUNCTION create_event_sensor() RETURNS TRIGGER AS $create_event_sensor$
--CREATE OR REPLACE FUNCTION create_event_sensor() RETURNS BOOLEAN AS $$
DECLARE
  varchar_script varchar;
  int_event integer;
BEGIN
  SELECT INTO varchar_script, int_event
              v_event_sensor.script, v_event_sensor.id
  FROM v_event_sensor, mode, contact
   WHERE new.state != old.state 
   AND v_event_sensor.mode = mode.id
   AND mode.active = 't'
   AND new.id = v_event_sensor.sensor
   AND ((new.state > v_event_sensor.trip_hi) OR (new.state < v_event_sensor.trip_lo));

   --RAISE NOTICE 'script %', varchar_script;
   IF (varchar_script IS NOT NULL) THEN
      --RAISE NOTICE 'insert new event %', varchar_script;
      --INSERT INTO event_new (script, date_time) VALUES (varchar_script, now());
      INSERT INTO log (event_type, contact_sensor, date_time) VALUES ('2', int_event, now());
      perform pg_notify('new_event', varchar_script);
   END IF;
  RETURN new;
END;
--$$ LANGUAGE plpgsql;
$create_event_sensor$ LANGUAGE plpgsql;

DROP FUNCTION update_mode();
CREATE FUNCTION update_mode() RETURNS TRIGGER AS $update_mode$
DECLARE
 varchar_script varchar;
BEGIN
 IF (new.active != old.active) THEN
  new.active_update = now();
  IF (new.active = 't') THEN
   SELECT INTO varchar_script v_mode.script_active FROM v_mode WHERE new.description = v_mode.description;
  END IF;
  IF (new.active = 'f') THEN
   SELECT INTO varchar_script v_mode.script_inactive FROM v_mode WHERE new.description = v_mode.description;
  END IF;
  --INSERT INTO event_new(script, date_time) VALUES (varchar_script, now());
  perform pg_notify('new_event', varchar_script);
 END IF;
 RETURN new;
END;
$update_mode$ LANGUAGE plpgsql;




--TRIGGERS
CREATE TRIGGER create_event_contact BEFORE UPDATE ON contact FOR EACH ROW EXECUTE PROCEDURE create_event_contact();
CREATE TRIGGER create_event_sensor BEFORE UPDATE ON sensor FOR EACH ROW EXECUTE PROCEDURE create_event_sensor();
CREATE TRIGGER update_mode BEFORE UPDATE ON mode FOR EACH ROW EXECUTE PROCEDURE update_mode();

ALTER FUNCTION create_event_contact() OWNER TO controller;
ALTER FUNCTION create_event_sensor()  OWNER TO controller;
ALTER FUNCTION update_mode() OWNER TO controller;


