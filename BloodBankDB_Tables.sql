-- TABLE CREATION --

CREATE TABLE Person (
	pid CHAR(8) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	birthdate date,
	CONSTRAINT pk_persons_pid PRIMARY KEY(pid),
);

CREATE TABLE Donor (
	pid CHAR(8) NOT NULL,
	blood_type CHAR(3) NOT NULL,
	weight_lbs TINYINT NOT NULL,
	height_inch TINYINT NOT NULL,
	lifetime_donations TINYINT,
	donor_status CHAR(8),
	CONSTRAINT check_weight CHECK(weight_lbs >= 110),
	CONSTRAINT check_lifetime_donations CHECK(lifetime_donations >= 1),
	CONSTRAINT check_donor_status CHECK
          (donor_status = 'Bronze' AND lifetime_donations <=3 OR 
	  donor_status = 'Silver' AND lifetime_donations > 3 AND lifetime_donations <= 6 OR
          donor_status = 'Gold' AND lifetime_donations > 6 AND lifetime_donations <= 10 OR
	  donor_status = 'Diamond' AND lifetime_donations > 10 AND lifetime_donations <= 19 OR
	  donor_status = 'Platinum' AND lifetime_donations >= 20),
	CONSTRAINT pk_donor_pid PRIMARY KEY(pid),
	CONSTRAINT fk_donor_pid FOREIGN KEY(pid) REFERENCES Person(pid),
);

CREATE TABLE Patient (
	pid char(8) NOT NULL,
	blood_type char(3) NOT NULL,
	need_status char(4) NOT NULL,
	weight_lbs TINYINT NOT NULL,
	height_inch TINYINT NOT NULL,
	CONSTRAINT check_need_status CHECK(need_status = 'high' OR need_status = 'low'),
	CONSTRAINT pk_patient_pid PRIMARY KEY(pid),
	CONSTRAINT fk_patient_pid FOREIGN KEY(pid) REFERENCES Person(pid),
);

CREATE TABLE Nurse (
	pid char(8) NOT NULL,
	rank char(4) NOT NULL,
	salary int NOT NULL,
	hire_date date NOT NULL,
	CONSTRAINT check_rank CHECK(rank = 'CNA' OR rank = 'LPN' OR rank = 'RN' OR rank = 'APRN'),
	CONSTRAINT pk_nurse_pid PRIMARY KEY(pid),
	CONSTRAINT fk_nurse_pid FOREIGN KEY(pid) REFERENCES Person(pid)
);

CREATE TABLE Pre_Exam (
	peid char(8) NOT NULL,
	pid char(8) NOT NULL,
	hemoglobin_gdl decimal(5,2) NOT NULL,
	temperature decimal(3,1) NOT NULL,
	blood_pressure_systolic tinyint NOT NULL,
	blood_pressure_diastolic tinyint NOT NULL,
	heart_rate_bpm tinyint NOT NULL,
	CONSTRAINT check_hemoglobin_gdl CHECK(hemoglobin_gdl >= 12.5 AND hemoglobin_gdl <=20),
	CONSTRAINT check_bp_systolic CHECK(blood_pressure_systolic <= 180),
	CONSTRAINT check_bp_diastolic CHECK(blood_pressure_diastolic <= 90),
	CONSTRAINT check_pulse_rate_bpm CHECK(heart_rate_bpm <= 100 AND heart_rate_bpm >= 50),
	CONSTRAINT pk_pre_exam_peid PRIMARY KEY(peid),
	CONSTRAINT fk_pre_exam_pid FOREIGN KEY(pid) REFERENCES Person(pid),
);

CREATE TABLE Donation (
	did CHAR(8) NOT NULL,
	pid CHAR(8) NOT NULL,
	peid CHAR(8) NOT NULL,
	nurse CHAR(8) NOT NULL,
	amount_donated_cc SMALLINT NOT NULL,
	donation_type CHAR(9) NOT NULL,
	CONSTRAINT check_donation_type CHECK(donation_type = 'Power Red' OR donation_type = 'Blood' OR donation_type = 'Platelets' OR donation_type = 'Plasma'), 
	CONSTRAINT pk_donation_did PRIMARY KEY(did),
	CONSTRAINT fk_donation_pid FOREIGN KEY(pid) REFERENCES Donor(pid),
	CONSTRAINT fk_pre_exam_peid FOREIGN KEY(peid) REFERENCES Pre_Exam(peid),
	CONSTRAINT fk_donation_nurse FOREIGN KEY(nurse) REFERENCES Nurse(pid)
);

CREATE TABLE Transfusion (
	tid char(8) NOT NULL,
	pid char(8) NOT NULL,
	nurse char(8) NOT NULL,
	bbid char(8) NOT NULL,
	amount char(6) NOT NULL,
	heart_rate_bpm tinyint NOT NULL,
	temperature decimal(4,2) NOT NULL,
	respiration_rate tinyint NOT NULL,
	blood_pressure_systolic tinyint NOT NULL,
	blood_pressure_diastolic tinyint NOT NULL,
	reason char(20) NOT NULL,
    	side_effects varchar(50),
	transfusion_date datetime,
	CONSTRAINT checl_respiration_rate CHECK(respiration_rate >= 12 AND respiration_rate <= 25),
	CONSTRAINT check_bp_systolic_transfusion CHECK(blood_pressure_systolic <= 180),
	CONSTRAINT check_bp_diastolic_transfusion CHECK(blood_pressure_diastolic <= 90),
	CONSTRAINT check_heart_rate_bpm CHECK(heart_rate_bpm <= 100 AND heart_rate_bpm >= 50),
	CONSTRAINT pk_transfusion_tid PRIMARY KEY(tid),
	CONSTRAINT fk_transfusion_pid FOREIGN KEY(pid) REFERENCES Patient(pid),
	CONSTRAINT fk_transfusion_nurse FOREIGN KEY(nurse) REFERENCES Nurse(pid),
	CONSTRAINT fk_transfusion_bbid FOREIGN KEY(bbid) REFERENCES Blood_Bags(bbid)
);

CREATE TABLE Blood_Bags (
	bbid char(8) NOT NULL,
	blood_type char(3) NOT NULL,
	quantity char(6) NOT NULL,
	donation_type char(9) NOT NULL,
	CONSTRAINT check_bb_donation_type CHECK(donation_type = 'Power Red' OR donation_type = 'Blood' OR donation_type = 'Platelets' OR donation_type = 'Plasma'),
	CONSTRAINT pk_blood_bags PRIMARY KEY(bbid)
);

-- END TABLE CREATION --
