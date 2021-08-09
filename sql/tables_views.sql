DROP VIEW v_log_contact;
DROP VIEW v_log_sensor;
DROP VIEW v_event_sensor;
DROP VIEW v_event_contact;
DROP VIEW v_mode;

DROP TABLE log;
DROP TABLE event_type;

--DROP TABLE actuator;
--DROP TABLE event_new;
DROP TABLE event_sensor;
DROP TABLE event_contact;
DROP TABLE sensor;
DROP TABLE contact;
DROP TABLE mode;


 
CREATE TABLE contact (	id INTEGER PRIMARY KEY,
                        description VARCHAR UNIQUE NOT NULL,
                        db VARCHAR,
                        unit VARCHAR,
                        port VARCHAR,
                        state BOOLEAN,
                        date_time TIMESTAMP);
ALTER TABLE contact OWNER TO controller;
GRANT ALL ON contact TO controller;

INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('1',  'doorbell',              'arduino_mqtt', 'attic driveway', 'd00', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('2',  'attic hatch',           'arduino_mqtt', 'attic driveway', 'd02', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('3',  'smoke bedroom front',   'arduino_mqtt', 'attic driveway', 'd05', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('4',  'smoke bedroom master',  'arduino_mqtt', 'attic driveway', 'd06', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('5',  'smoke bedroom corner',  'arduino_mqtt', 'attic driveway', 'd07', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('6',  'smoke bedroom hallway', 'arduino_mqtt', 'attic driveway', 'd08', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('7',  'smoke attic',           'arduino_mqtt', 'attic driveway', 'd09', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('8',  'door kitchen deck',     'arduino_mqtt', 'attic pathway',  'd01', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('9',  'window kitchen deck',   'arduino_mqtt', 'attic pathway',  'd02', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('10', 'door office',           'arduino_mqtt', 'attic pathway',  'd03', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('11', 'window office front',   'arduino_mqtt', 'attic pathway',  'd05', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('12', 'window office side',    'arduino_mqtt', 'attic pathway',  'd06', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('13', 'door interior garage',  'arduino_mqtt', 'garage 1',       'd00', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('14', 'door exterior garage',  'arduino_mqtt', 'garage 1',       'd01', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('15', 'window garage',         'arduino_mqtt', 'garage 1',       'd02', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('16', 'window bedroom guest',  'arduino_mqtt', 'garage 1',       'd03', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('17', 'window mudroom',        'arduino_mqtt', 'garage 1',       'd05', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('18', 'PIR basement steps',    'arduino_mqtt', 'garage 1',       'd06', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('19', 'smoke basement steps',  'arduino_mqtt', 'garage 2',       'd02', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('20', 'smoke bedroom guest',   'arduino_mqtt', 'garage 2',       'd03', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('21', 'window laundry',        'arduino_mqtt', 'laundry 1',      'd00', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('22', 'window deck NE',        'arduino_mqtt', 'laundry 1',      'd01', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('23', 'window deck NW',        'arduino_mqtt', 'laundry 1',      'd02', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('24', 'window deck W',         'arduino_mqtt', 'laundry 1',      'd03', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('25', 'door front',            'arduino_mqtt', 'laundry 1',      'd05', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('26', 'door driveway',         'arduino_mqtt', 'laundry 1',      'd06', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('27', 'PIR fireplace',         'arduino_mqtt', 'laundry 1',      'd07', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('28', 'glassbreak theater',    'arduino_mqtt', 'laundry 1',      'd08', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('29', 'door deck hottub',      'arduino_mqtt', 'laundry 2',      'd00', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('30', 'window pathway',        'arduino_mqtt', 'laundry 2',      'd01', 't', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('31', 'PIR vestibule',         'arduino_mqtt', 'laundry 2',      'd02', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('32', 'PIR theater',           'arduino_mqtt', 'laundry 2',      'd03', 'f', now());
INSERT INTO contact (id, description, db, unit, port, state, date_time) values ('33', 'smoke/CO2 laundry',     'arduino_mqtt', 'laundry 2',      'd08', 'f', now());

CREATE TABLE sensor (id INTEGER PRIMARY KEY, description VARCHAR UNIQUE NOT NULL, db VARCHAR, unit VARCHAR, port VARCHAR, state float, date_time TIMESTAMP);
ALTER TABLE sensor OWNER TO controller;
GRANT ALL ON sensor to controller;

INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('1',  'temperature bedroom guest',  'arduino_mqtt', 'bedroom guest',  'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('2',  'temperature bar',            'arduino_mqtt', 'bar',            'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('3',  'temperature theater',        'arduino_mqtt', 'theater',        'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('4',  'temperature bedroom master', 'arduino_mqtt', 'bedroom master', 'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('5',  'temperature dining room',    'arduino_mqtt', 'dining room',    'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('6',  'temperature kitchen',        'arduino_mqtt', 'kitchen',        'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('7',  'temperature attic driveway', 'arduino_mqtt', 'attic driveway', 'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('8',  'temperature attic pathway',  'arduino_mqtt', 'attic pathway',  'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('9',  'temperature garage 1',       'arduino_mqtt', 'garage 1',       'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('10', 'temperature garage 2',       'arduino_mqtt', 'garage 2',       'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('11', 'temperature hvac 1',         'arduino_mqtt', 'hvac 1',         'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('12', 'temperature hvac 2',         'arduino_mqtt', 'hvac 2',         'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('13', 'temperature laundry 1',      'arduino_mqtt', 'laundry 1',      'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('14', 'temperature laundry 2',      'arduino_mqtt', 'laundry 2',      'i00', '0.000', now());
INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('15', 'temperature exterior',       'arduino_mqtt', 'exterior north', 'i00', '0.000', now());
--INSERT INTO sensor (id, description, db, unit, port, state, date_time) values ('', '', 'arduino_mqtt', '', 'i00', '0.000', now());


CREATE TABLE mode (  id INTEGER PRIMARY KEY,
                     description VARCHAR UNIQUE NOT NULL,
                     active BOOLEAN,
                     active_update TIMESTAMP,
                     sound BOOLEAN,
                     notify BOOLEAN,
                     grace INTERVAL);
ALTER TABLE mode OWNER TO controller;
GRANT ALL ON mode TO controller;

INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('1', 'smoke alarm',        't', now(), 'f', 't', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('2', 'temperature alarm',  't', now(), 'f', 't', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('3', 'doorbell',           't', now(), 't', 't', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('4', 'entry alarm home',   'f', now(), 'f', 't', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('5', 'entry alarm away',   'f', now(), 'f', 't', '00:00:45');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('6', 'door open',          't', now(), 't', 'f', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('7', 'door close',         't', now(), 't', 'f', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('8', 'window open',        't', now(), 't', 'f', '00:00:01');
INSERT INTO mode (id, description, active, active_update, sound, notify, grace) values ('9', 'window close',       't', now(), 't', 'f', '00:00:01');


CREATE TABLE event_contact ( id SERIAL PRIMARY KEY,
                            contact INTEGER,
                            mode INTEGER REFERENCES mode(id),
                            trip BOOLEAN);
ALTER TABLE event_contact OWNER TO controller;
GRANT ALL ON event_contact TO controller;

INSERT INTO event_contact (contact, mode, trip) values ('1',  '4', 't'); --doorbell pressed

INSERT INTO event_contact (contact, mode, trip) values ('3',  '1', 't'); --smoke alarm - bedroom front
INSERT INTO event_contact (contact, mode, trip) values ('4',  '1', 't'); --smoke alarm - bedroom master
INSERT INTO event_contact (contact, mode, trip) values ('5',  '1', 't'); --smoke alarm - bedroom corner
INSERT INTO event_contact (contact, mode, trip) values ('6',  '1', 't'); --smoke alarm - bedroom hallway
INSERT INTO event_contact (contact, mode, trip) values ('7',  '1', 't'); --smoke alarm - attic
INSERT INTO event_contact (contact, mode, trip) values ('19', '1', 't'); --smoke alarm - basement steps
INSERT INTO event_contact (contact, mode, trip) values ('20', '1', 't'); --smoke alarm - bedroom guest
INSERT INTO event_contact (contact, mode, trip) values ('33', '1', 't'); --smoke alarm - laundry area

--entry home mode
--INSERT INTO event_contact (contact, mode, trip) values ('8',  '4', 'f'); --entry alarm (home mode) - door kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('9',  '4', 'f'); --entry alarm (home mode) - window kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('10', '4', 'f'); --entry alarm (home mode) - door office
INSERT INTO event_contact (contact, mode, trip) values ('11', '4', 'f'); --entry alarm (home mode) - window office front
INSERT INTO event_contact (contact, mode, trip) values ('12', '4', 'f'); --entry alarm (home mode) - window office side'
INSERT INTO event_contact (contact, mode, trip) values ('14', '4', 'f'); --entry alarm (home mode) - door garage exterior
INSERT INTO event_contact (contact, mode, trip) values ('15', '4', 'f'); --entry alarm (home mode) - window garage
INSERT INTO event_contact (contact, mode, trip) values ('16', '4', 'f'); --entry alarm (home mode) - window bedroom guest
INSERT INTO event_contact (contact, mode, trip) values ('17', '4', 'f'); --entry alarm (home mode) - window mudroom
INSERT INTO event_contact (contact, mode, trip) values ('21', '4', 'f'); --entry alarm (home mode) - window laundry
INSERT INTO event_contact (contact, mode, trip) values ('22', '4', 'f'); --entry alarm (home mode) - window deck NE
INSERT INTO event_contact (contact, mode, trip) values ('23', '4', 'f'); --entry alarm (home mode) - window deck NW
INSERT INTO event_contact (contact, mode, trip) values ('24', '4', 'f'); --entry alarm (home mode) - window deck W
INSERT INTO event_contact (contact, mode, trip) values ('25', '4', 'f'); --entry alarm (home mode) - door front
INSERT INTO event_contact (contact, mode, trip) values ('26', '4', 'f'); --entry alarm (home mode) - door driveway
INSERT INTO event_contact (contact, mode, trip) values ('29', '4', 'f'); --entry alarm (home mode) - door hottub
INSERT INTO event_contact (contact, mode, trip) values ('30', '4', 'f'); --entry alarm (home mode) - window pathway


--entry away mode
INSERT INTO event_contact (contact, mode, trip) values ('13', '5', 'f'); --entry alarm (away mode) - door garage interior
INSERT INTO event_contact (contact, mode, trip) values ('18', '5', 'f'); --entry alarm (away mode) - PIR basement steps
INSERT INTO event_contact (contact, mode, trip) values ('27', '5', 'f'); --entry alarm (away mode) - PIR fireplace
INSERT INTO event_contact (contact, mode, trip) values ('28', '5', 'f'); --entry alarm (away mode) - glassbreak theater
INSERT INTO event_contact (contact, mode, trip) values ('31', '5', 'f'); --entry alarm (away mode) - PIR vestibule
INSERT INTO event_contact (contact, mode, trip) values ('32', '5', 'f'); --entry alarm (away mode) - PIR theater
--entry away mode in common with home mode
--INSERT INTO event_contact (contact, mode, trip) values ('8',  '5', 'f'); --entry alarm (away mode) - door kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('9',  '5', 'f'); --entry alarm (away mode) - window kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('10', '5', 'f'); --entry alarm (away mode) - door office
INSERT INTO event_contact (contact, mode, trip) values ('11', '5', 'f'); --entry alarm (away mode) - window office front
INSERT INTO event_contact (contact, mode, trip) values ('12', '5', 'f'); --entry alarm (away mode) - window office side
INSERT INTO event_contact (contact, mode, trip) values ('14', '5', 'f'); --entry alarm (away mode) - door garage exterior
INSERT INTO event_contact (contact, mode, trip) values ('15', '5', 'f'); --entry alarm (away mode) - window garage
INSERT INTO event_contact (contact, mode, trip) values ('16', '5', 'f'); --entry alarm (away mode) - window bedroom guest
INSERT INTO event_contact (contact, mode, trip) values ('17', '5', 'f'); --entry alarm (away mode) - window mudroom
INSERT INTO event_contact (contact, mode, trip) values ('21', '5', 'f'); --entry alarm (away mode) - window laundry
INSERT INTO event_contact (contact, mode, trip) values ('22', '5', 'f'); --entry alarm (away mode) - window deck NE
INSERT INTO event_contact (contact, mode, trip) values ('23', '5', 'f'); --entry alarm (away mode) - window deck NW
INSERT INTO event_contact (contact, mode, trip) values ('24', '5', 'f'); --entry alarm (away mode) - window deck W
INSERT INTO event_contact (contact, mode, trip) values ('25', '5', 'f'); --entry alarm (away mode) - door front
INSERT INTO event_contact (contact, mode, trip) values ('26', '5', 'f'); --entry alarm (away mode) - door driveway
INSERT INTO event_contact (contact, mode, trip) values ('29', '5', 'f'); --entry alarm (away mode) - door deck hottub
INSERT INTO event_contact (contact, mode, trip) values ('30', '5', 'f'); --entry alarm (away mode) - window pathway


--door open chime
--INSERT INTO event_contact (contact, mode, trip) values ('8',  '6', 'f', 'door open - kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('10', '6', 'f'); --door open - office
INSERT INTO event_contact (contact, mode, trip) values ('14', '6', 'f'); --door open - garage exterior
INSERT INTO event_contact (contact, mode, trip) values ('25', '6', 'f'); --door open - front
INSERT INTO event_contact (contact, mode, trip) values ('26', '6', 'f'); --door open - driveway
INSERT INTO event_contact (contact, mode, trip) values ('29', '6', 'f'); --door open - deck hottub
INSERT INTO event_contact (contact, mode, trip) values ('13', '6', 'f'); --door open - garage interior
--door close chime
--INSERT INTO event_contact (contact, mode, trip) values ('33', '8',  '7', 'f'); --door close - kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('10', '7', 't'); --door close - office
INSERT INTO event_contact (contact, mode, trip) values ('14', '7', 't'); --door close - garage exterior
INSERT INTO event_contact (contact, mode, trip) values ('25', '7', 't'); --door close - front
INSERT INTO event_contact (contact, mode, trip) values ('26', '7', 't'); --door close - driveway
INSERT INTO event_contact (contact, mode, trip) values ('29', '7', 't'); --door close - deck hottub
INSERT INTO event_contact (contact, mode, trip) values ('13', '7', 't'); --door close - garage interior


--window open chime
INSERT INTO event_contact (contact, mode, trip) values ('9',  '8', 'f'); --window open - kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('11', '8', 'f'); --window open - office front
INSERT INTO event_contact (contact, mode, trip) values ('12', '8', 'f'); --window open - office side
INSERT INTO event_contact (contact, mode, trip) values ('15', '8', 'f'); --window open - garage
INSERT INTO event_contact (contact, mode, trip) values ('16', '8', 'f'); --window open - bedroom guest
INSERT INTO event_contact (contact, mode, trip) values ('17', '8', 'f'); --window open - mudroom
INSERT INTO event_contact (contact, mode, trip) values ('21', '8', 'f'); --window open - laundry
INSERT INTO event_contact (contact, mode, trip) values ('22', '8', 'f'); --window open - deck NE
INSERT INTO event_contact (contact, mode, trip) values ('23', '8', 'f'); --window open - deck NW
INSERT INTO event_contact (contact, mode, trip) values ('24', '8', 'f'); --window open - deck W
INSERT INTO event_contact (contact, mode, trip) values ('30', '8', 'f'); --window open - pathway
--window close chime
INSERT INTO event_contact (contact, mode, trip) values ('9',  '9', 't'); --window close - kitchen deck
INSERT INTO event_contact (contact, mode, trip) values ('11', '9', 't'); --window close - office front
INSERT INTO event_contact (contact, mode, trip) values ('12', '9', 't'); --window close - office side
INSERT INTO event_contact (contact, mode, trip) values ('15', '9', 't'); --window close - garage
INSERT INTO event_contact (contact, mode, trip) values ('16', '9', 't'); --window close - bedroom guest
INSERT INTO event_contact (contact, mode, trip) values ('17', '9', 't'); --window close - mudroom
INSERT INTO event_contact (contact, mode, trip) values ('21', '9', 't'); --window close - laundry
INSERT INTO event_contact (contact, mode, trip) values ('22', '9', 't'); --window close - deck NE
INSERT INTO event_contact (contact, mode, trip) values ('23', '9', 't'); --window close - deck NW
INSERT INTO event_contact (contact, mode, trip) values ('24', '9', 't'); --window close - deck W
INSERT INTO event_contact (contact, mode, trip) values ('30', '9', 't'); --window close - pathway


CREATE TABLE event_sensor (  id INTEGER PRIMARY KEY,
                            sensor INTEGER,
                            mode INTEGER,
                            trip_hi FLOAT,
                            trip_lo FLOAT,
                            description VARCHAR,
                            script VARCHAR);
ALTER TABLE event_sensor OWNER TO controller;
GRANT ALL ON event_sensor TO controller;

INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('1',  '1',  '2', '50.0', '1.0', 'temperature bedroom guest',  E'temperature.bash \'bedroom guest\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('2',  '2',  '2', '50.0', '1.0', 'temperature bar',            E'temperature.bash \'bar\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('3',  '3',  '2', '50.0', '1.0', 'temperature theater',        E'temperature.bash \'theater\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('4',  '4',  '2', '50.0', '1.0', 'temperature bedroom master', E'temperature.bash \'bedroom master\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('5',  '5',  '2', '50.0', '1.0', 'temperature dining room',    E'temperature.bash \'dining room\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('6',  '6',  '2', '50.0', '1.0', 'temperature kitchen',        E'temperature.bash \'kitchen\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('7',  '7',  '2', '50.0', '1.0', 'temperature attic driveway', E'temperature.bash \'attic driveway\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('8',  '8',  '2', '50.0', '1.0', 'temperature attic pathway',  E'temperature.bash \'attic pathway\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('9',  '9',  '2', '50.0', '1.0', 'temperature garage',         E'temperature.bash \'garage\'');
INSERT INTO event_sensor (id, sensor, mode, trip_hi, trip_lo, description, script) values ('10', '13', '2', '50.0', '1.0', 'temperature laundry area',   E'temperature.bash \'laundry area\'');

--CREATE TABLE event_new (id SERIAL PRIMARY KEY, script VARCHAR, date_time TIMESTAMP);


CREATE TABLE event_type (id SERIAL PRIMARY KEY, description VARCHAR);
ALTER TABLE event_type OWNER TO controller;
GRANT ALL ON event_type TO controller;
INSERT INTO event_type (id, description) VALUES ('0', 'application start');
INSERT INTO event_type (id, description) VALUES ('1', 'update contact');
INSERT INTO event_type (id, description) VALUES ('2', 'update sensor');


CREATE TABLE log (id SERIAL PRIMARY KEY, event_type INTEGER REFERENCES event_type(id), contact_sensor INTEGER, date_time TIMESTAMP);
ALTER TABLE log OWNER TO controller;
GRANT ALL ON log TO controller;


--CREATE TABLE actuator (id INTEGER PRIMARY KEY, description VARCHAR UNIQUE NOT NULL, db VARCHAR, unit VARCHAR, port VARCHAR, state BOOLEAN, date_time TIMESTAMP);
--ALTER TABLE actuator OWNER TO controller;
--GRANT ALL ON actuator TO controller;

--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('1',  'siren',                'arduino_mqtt', 'laundry 2',                  'd05', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('2',  'fan attic east #1',    'apc_snmp',     'pdu_switch8_attic_path',     'd04', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('3',  'fan attic east #2',    'apc_snmp',     'pdu_switch8_attic_path',     'd05', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('4',  'fan attic east #3',    'apc_snmp',     'pdu_switch8_attic_path',     'd06', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('5',  'fan attic east #4',    'apc_snmp',     'pdu_switch8_attic_path',     'd07', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('6',  'fan attic west #1',    'apc_snmp',     'pdu_switch8_attic_driveway', 'd04', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('7',  'fan attic west #2',    'apc_snmp',     'pdu_switch8_attic_driveway', 'd05', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('8',  'fan attic west #3',    'apc_snmp',     'pdu_switch8_attic_driveway', 'd06', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('9',  'fan attic west #4',    'apc_snmp',     'pdu_switch8_attic_driveway', 'd07', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('10', 'furnace lamp',         'apc_snmp',     'pdu_switch24_conrad_desk',   'd01', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('11', 'audio amp upstairs',   'apc_snmp',     'pdu_switch8_laundry',        'd02', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('12', 'audio amp downstairs', 'apc_snmp',     'pdu_switch8_laundry',        'd04', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('13', 'spotlight driveway',   'apc_snmp',     'pdu_switch8_attic_driveway', 'd02', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('14', 'spotlight path',       'apc_snmp',     'pdu_switch8_attic_path',     'd02', 'f', now());
--INSERT INTO actuator (id, description, db, unit, port, state, date_time) values ('15', 'woods lights',         'apc_snmp',     'pdu_switch8_laundry',        'd00', 'f', now());


--CREATE TABLE mode_actuator(id INTEGER PRIMARY KEY, description VARCHAR NOT NULL, actuator VARCHAR REFERENCES actuator(description), mode VARCHAR REFERENCES modes(description), 



--VIEWS

CREATE VIEW v_mode AS
       SELECT id, description, active, (REPLACE(description, ' ', '_') || '.bash ' || E'\'active\'') AS script_active, (REPLACE(description, ' ', '_') || '.bash ' || E'\'inactive\'') AS script_inactive, ((now() - active_update) > grace) AS grace_expired
       FROM mode;

CREATE VIEW v_event_contact AS
       SELECT event_contact.id,
              event_contact.contact AS contact,
              contact.description AS contact_description,
              event_contact.mode,
              event_contact.trip,
              (REPLACE(mode.description, ' ', '_') || '.bash ' || E'\'' || contact.description || E'\'') AS script
              
       FROM   contact, event_contact, mode
       WHERE  event_contact.contact = contact.id
       AND    event_contact.mode = mode.id;

CREATE VIEW v_event_sensor AS
       SELECT event_sensor.id,
              event_sensor.sensor AS sensor,
              sensor.description AS sensor_description,
              event_sensor.mode,
              event_sensor.trip_hi,
              event_sensor.trip_lo,
              (REPLACE(mode.description, ' ', '_') || '.bash ' || E'\'' || sensor.description || E'\'') AS script
              
       FROM   sensor, event_sensor, mode
       WHERE  event_sensor.sensor = sensor.id
       AND    event_sensor.mode = mode.id;



CREATE VIEW v_log_contact AS
       SELECT log.id, mode.description as mode, v_event_contact.contact_description as description, log.date_time
       FROM log, mode, v_event_contact
       WHERE v_event_contact.id = log.contact_sensor
       AND v_event_contact.mode = mode.id;

CREATE VIEW v_log_sensor AS
       SELECT log.id, mode.description AS mode, v_event_sensor.sensor_description AS description, log.date_time
       FROM log, mode, v_event_sensor
       WHERE v_event_sensor.id = log.contact_sensor
       AND v_event_sensor.mode = mode.id;
