\c military_base;

ALTER TABLE military_base.weapons ADD CONSTRAINT P_WID PRIMARY KEY (id);
ALTER TABLE military_base.weapons ALTER COLUMN name SET NOT NULL;
ALTER TABLE military_base.weapons ALTER COLUMN classification SET NOT NULL;
ALTER TABLE military_base.weapons ALTER COLUMN caliber SET NOT NULL;
ALTER TABLE military_base.weapons ALTER COLUMN status SET NOT NULL;
ALTER TABLE military_base.weapons ALTER COLUMN produced SET NOT NULL;
ALTER TABLE military_base.weapons ALTER COLUMN last_check SET NOT NULL;

ALTER TABLE military_base.weapons ADD CONSTRAINT CH_PROD CHECK (produced <= last_check);

ALTER TABLE military_base.squads ADD CONSTRAINT P_SID PRIMARY KEY (id);
ALTER TABLE military_base.squads ALTER COLUMN cur_location SET NOT NULL;
ALTER TABLE military_base.squads ALTER COLUMN first_deploy SET NOT NULL;
ALTER TABLE military_base.squads ALTER COLUMN last_deploy SET NOT NULL;
ALTER TABLE military_base.squads ALTER COLUMN status SET NOT NULL;
ALTER TABLE military_base.squads ALTER COLUMN total_deploys SET NOT NULL;
ALTER TABLE military_base.squads ALTER COLUMN call_sign SET NOT NULL;

ALTER TABLE military_base.squads ADD CONSTRAINT CH_TOTALDEPLOYS CHECK (total_deploys >= 0);
ALTER TABLE military_base.squads ADD CONSTRAINT CH_DEPLOYS CHECK (first_deploy <= last_deploy);

ALTER TABLE military_base.ammunition ADD CONSTRAINT P_AMID PRIMARY KEY (id);
ALTER TABLE military_base.ammunition ALTER COLUMN name SET NOT NULL;
ALTER TABLE military_base.ammunition ALTER COLUMN caliber SET NOT NULL;
ALTER TABLE military_base.ammunition ALTER COLUMN type SET NOT NULL;
ALTER TABLE military_base.ammunition ALTER COLUMN quantity SET NOT NULL;
ALTER TABLE military_base.ammunition ALTER COLUMN status SET NOT NULL;

ALTER TABLE military_base.ammunition ADD CONSTRAINT CH_AMMO CHECK (quantity >= 0);

ALTER TABLE military_base.vehicles ADD CONSTRAINT P_VID PRIMARY KEY (id);
ALTER TABLE military_base.vehicles ALTER COLUMN name SET NOT NULL;
ALTER TABLE military_base.vehicles ALTER COLUMN status SET NOT NULL;
ALTER TABLE military_base.vehicles ALTER COLUMN capacity SET NOT NULL;
ALTER TABLE military_base.vehicles ALTER COLUMN armored SET NOT NULL;
ALTER TABLE military_base.vehicles ALTER COLUMN produced SET NOT NULL;

ALTER TABLE military_base.vehicles ADD CONSTRAINT CH_CAPACITY CHECK (capacity > 0);

ALTER TABLE military_base.soldiers ADD CONSTRAINT P_ID PRIMARY KEY (id);
ALTER TABLE military_base.soldiers ALTER COLUMN first_name SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN last_name SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN rank SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN age SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN salary SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN arrival_date SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN departure_date SET NOT NULL;

ALTER TABLE military_base.soldiers ALTER COLUMN weapon_id SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN ammunition_id SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN vehicle_id SET NOT NULL;
ALTER TABLE military_base.soldiers ALTER COLUMN squad_id SET NOT NULL;

ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AWID FOREIGN KEY (weapon_id) REFERENCES military_base.weapons(id), ADD CONSTRAINT U_AWID UNIQUE (weapon_id);
ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AAID FOREIGN KEY (ammunition_id) REFERENCES military_base.ammunition(id), ADD CONSTRAINT U_AAID UNIQUE (ammunition_id);
ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AVID FOREIGN KEY (vehicle_id) REFERENCES military_base.vehicles(id), ADD CONSTRAINT U_AVID UNIQUE (vehicle_id);
ALTER TABLE military_base.soldiers ADD CONSTRAINT F_ASID FOREIGN KEY (squad_id) REFERENCES military_base.squads(id), ADD CONSTRAINT U_ASID UNIQUE (vehicle_id);

ALTER TABLE military_base.soldiers ADD CONSTRAINT CH_AGES CHECK (age >= 18);
ALTER TABLE military_base.soldiers ADD CONSTRAINT CH_SALARY CHECK (salary > 500);
ALTER TABLE military_base.soldiers ADD CONSTRAINT CH_DEPARTURE CHECK (arrival_date <= departure_date);
