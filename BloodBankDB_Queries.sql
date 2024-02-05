-- Queries --

-- How many unique first names there are --
SELECT COUNT(DISTINCT first_name) FROM Person;

-- How many unique last names there are --
SELECT COUNT(DISTINCT last_name) FROM Person;

-- Find all the Donors that have a O- Blood type --
SELECT * FROM Donor WHERE blood_type = 'O-'
ORDER BY LEN(pid), pid;

-- Find all the Donors that have Either A+ or B- Blood Type --
SELECT * FROM Donor Where blood_type = 'A+' OR blood_type = 'B-'
ORDER BY LEN(pid), pid;

-- Find all the Donors that weigh over 200 pounds and are blood type AB+ --
SELECT * FROM Donor WHERE weight_lbs > 200 AND blood_type = 'AB+'
ORDER BY LEN(pid), pid;

-- Find all Patients with a high need status --
SELECT * FROM Patient WHERE need_status = 'High'
ORDER BY LEN(pid), pid;

-- Find all Donors blood types except A+ and B+ --
SELECT * FROM Donor WHERE blood_type NOT IN ('A+', 'B+')
ORDER BY LEN(pid), pid;

-- Find all Transfusion patients who experienced no side effects --
SELECT * FROM Transfusion WHERE side_effects IS NULL
ORDER BY LEN(tid), tid;

-- Find all Transfusion patients who experienced side effects --
SELECT * FROM Transfusion WHERE side_effects IS NOT NULL
ORDER BY LEN(tid), tid;

-- Find how many blood bags contain blood --
SELECT COUNT(donation_type) AS total_bloodbags
FROM Blood_Bags
WHERE donation_type = 'Blood';

-- Find the average blood pressure of Donors --
SELECT AVG(blood_pressure_systolic) AS Avg_systolic FROM Pre_Exam;
SELECT AVG(blood_pressure_diastolic) AS Avg_diastolic FROM Pre_Exam;

-- Find all the Donors from the Persons table --
SELECT * FROM Person WHERE pid IN(SELECT pid FROM Donor)
ORDER BY LEN(pid), pid;

-- Find just the first and last names of all the Nurses from the Persons table --
SELECT first_name, last_name FROM Person WHERE pid IN(SELECT pid FROM Nurse)
ORDER BY LEN(pid), pid;

-- Give all current RN's with 30+ year tenure a 10k yearly raise --
BEGIN TRAN
UPDATE Nurse SET salary = salary + 10000
WHERE rank = 'RN' AND hire_date < '1995-01-01';
ROLLBACK TRAN

-- Use group by to figure out how many donors donated how much --
SELECT COUNT(pid) AS donor_count, lifetime_donations
FROM Donor
GROUP BY lifetime_donations;

-- Use group by to figure out how many donors donated how much, having at least 10 or more donations --
SELECT COUNT(pid) AS donor_count, lifetime_donations
FROM Donor
GROUP BY lifetime_donations
HAVING lifetime_donations >= 10;

-- Use group by to figure out many donors belong in each donor_status group --
SELECT COUNT(pid) AS donor_count, donor_status
FROM Donor
GROUP BY donor_status;

-- Use group by to figure out how many patients experienced each type of side effect --
SELECT COUNT(tid) total_count, side_effects
FROM Transfusion
GROUP BY side_effects
ORDER BY total_count DESC;

-- Use group by to find out quantity of blood_types from Donor table --
SELECT COUNT(pid) total_blood, blood_type
FROM Donor
GROUP BY blood_type;

-- JOINS --

-- Joining Person table with Donor table --
SELECT Person.pid, first_name, last_name, blood_type, weight_lbs, height_inch, lifetime_donations, donor_status
FROM Donor
JOIN Person ON 
Person.pid = Donor.pid
ORDER BY LEN(Person.pid), pid;

-- Joining Person table with Patient table --
SELECT Person.pid, first_name, last_name, blood_type, need_status, weight_lbs, height_inch
FROM Patient
JOIN Person ON
Person.pid = Patient.pid
ORDER BY LEN(Person.pid), pid;

-- Joining Person table with Nurse table --
SELECT Person.pid, first_name, last_name, hire_date, rank, CONCAT('$', salary) as salary
FROM Nurse
JOIN Person ON
Person.pid = Nurse.pid
ORDER BY LEN(Person.pid), pid;

-- Joining Blood_Bags table with Transfusion table --
SELECT Transfusion.tid, heart_rate_bpm, temperature, respiration_rate, reason, side_effects, transfusion_date, Blood_Bags.bbid, blood_type, quantity, donation_type
FROM Transfusion
JOIN Blood_Bags ON
Transfusion.bbid = Blood_Bags.bbid
ORDER BY LEN(Transfusion.tid), tid;

-- Joining Donor table with Pre_Exam table --
SELECT Donor.pid AS donor_pid, blood_type, weight_lbs, height_inch, peid AS donor_peid, hemoglobin_gdl, temperature, blood_pressure_systolic, 
blood_pressure_diastolic, heart_rate_bpm
FROM Donor
JOIN Pre_Exam ON
Donor.pid = Pre_Exam.pid
ORDER BY LEN(Donor.pid), Donor.pid;

-- Triple joining Person table with Donor table and Pre_Exam --
SELECT Person.pid, Person.first_name AS Donor_fname, Person.last_name AS Donor_lname, Pre_Exam.hemoglobin_gdl, Pre_Exam.temperature,
Pre_Exam.blood_pressure_systolic, Pre_Exam.blood_pressure_diastolic, Donation.amount_donated, Donation.donation_type
FROM Person
JOIN Donation ON
Donation.pid = Person.pid  
JOIN Pre_Exam ON
Donation.peid = Pre_Exam.peid
ORDER BY amount_donated DESC;

-- Case Queries --

-- Case querie that shows donors eligible for rewards --
SELECT pid, lifetime_donations, donor_status,
CASE
	WHEN donor_status = 'Bronze' THEN 'Eligible for free Movie ticket'
	WHEN donor_status = 'Silver' THEN 'Eligible for 25$ Gift Card'
	WHEN donor_status = 'Gold' THEN 'Eligible for 100$ Gift Card'
	WHEN donor_status = 'Diamond' THEN 'Eligible for free Nintendo Switch'
	WHEN donor_status = 'Platinum' THEN 'Eligible for 200$ dollar Cash reward'
	ELSE 'Not eligible for a reward at this time'
END AS donor_status_rewards
FROM Donor
ORDER BY LEN(pid), pid;

-- Case querie that shows what blood types are compatible with one another --
SELECT pid, blood_type, weight_lbs, height_inch,
CASE
	WHEN blood_type = 'A+' THEN 'Compatible with A+, AB+'
	WHEN blood_type = 'A-' THEN 'Compatible with A+, A-, AB+, AB-'
	WHEN blood_type = 'B+' THEN 'Compatible with B+, AB+'
	WHEN blood_type = 'B-' THEN 'Compatible with B+, B-, AB+, AB-'
	WHEN blood_type = 'AB+' THEN 'Compatible with AB+'
	WHEN blood_type = 'AB-' THEN 'Compatible with AB+, AB-'
	WHEN blood_type = 'O+' THEN 'Compatible with A+, B+, AB+, O+'
	WHEN blood_type = 'O-' THEN 'Compatible with All blood types'
	ELSE 'Not a(n) valid blood type'
END as blood_type_compatibility
FROM Donor
ORDER BY LEN(pid), pid;

-- Case querie that rates the health of donors from their pre_exam --
SELECT peid, hemoglobin_gdl, temperature, blood_pressure_systolic, blood_pressure_diastolic, heart_rate_bpm,
CASE
	WHEN hemoglobin_gdl > 13.5 AND blood_pressure_systolic < 130 AND blood_pressure_diastolic > 80 OR heart_rate_bpm > 60 THEN 'Excellent Health'
	WHEN hemoglobin_gdl < 13.5 AND blood_pressure_systolic > 130 AND blood_pressure_diastolic < 80 AND heart_rate_bpm < 60 THEN 'Poor Health'
	WHEN hemoglobin_gdl < 13.5 OR blood_pressure_systolic > 130 OR blood_pressure_diastolic < 80 OR heart_rate_bpm < 60 THEN 'Below Average Health'
END AS pre_exam_health
FROM Pre_Exam
ORDER BY LEN(peid), peid;

-- Views --
GO
CREATE VIEW view_person_donor_join AS
SELECT TOP 1000 Person.pid, first_name, last_name, blood_type, weight_lbs, height_inch, lifetime_donations, donor_status
FROM Donor
JOIN Person ON 
Person.pid = Donor.pid
ORDER BY LEN(Person.pid), pid;
SELECT * FROM view_person_donor_join;


GO
CREATE VIEW view_person_patient_join AS
SELECT TOP 1000 Person.pid, first_name, last_name, blood_type, need_status, weight_lbs, height_inch
FROM Patient
JOIN Person ON
Person.pid = Patient.pid
ORDER BY LEN(Person.pid), pid;
SELECT * FROM view_person_patient_join;

GO
CREATE VIEW view_person_nurse_join AS
SELECT TOP 1000 Person.pid, first_name, last_name, hire_date, rank, CONCAT('$', salary) as salary
FROM Nurse
JOIN Person ON
Person.pid = Nurse.pid
ORDER BY LEN(Person.pid), pid;
SELECT * FROM view_person_nurse_join;

GO
CREATE VIEW view_blood_bags_transfusion_join AS
SELECT TOP 1000 Transfusion.tid, heart_rate_bpm, temperature, respiration_rate, reason, side_effects, transfusion_date, Blood_Bags.bbid, blood_type, quantity, donation_type
FROM Transfusion
JOIN Blood_Bags ON
Transfusion.bbid = Blood_Bags.bbid
ORDER BY LEN(Transfusion.tid), tid;
SELECT * FROM view_blood_bags_transfusion_join;

GO
CREATE VIEW view_donor_pre_exam_join AS
SELECT TOP 1000 Donor.pid AS donor_pid, blood_type, weight_lbs, height_inch, peid AS donor_peid, hemoglobin_gdl, temperature, blood_pressure_systolic, 
blood_pressure_diastolic, heart_rate_bpm
FROM Donor
JOIN Pre_Exam ON
Donor.pid = Pre_Exam.pid
ORDER BY LEN(Donor.pid), Donor.pid;
SELECT * FROM view_donor_pre_exam_join;

GO
CREATE VIEW view_person_donor_pre_exam_join AS
SELECT TOP 1000 Person.pid, Person.first_name AS Donor_fname, Person.last_name AS Donor_lname, Pre_Exam.hemoglobin_gdl, Pre_Exam.temperature,
Pre_Exam.blood_pressure_systolic, Pre_Exam.blood_pressure_diastolic, Donation.amount_donated, Donation.donation_type
FROM Person
JOIN Donation ON
Donation.pid = Person.pid  
JOIN Pre_Exam ON
Donation.peid = Pre_Exam.peid
ORDER BY amount_donated DESC;
SELECT * FROM view_person_donor_pre_exam_join;

-- Stored Procedures --

-- Stored procedure for finding all specific donation_types, i.e. blood, plasma --
CREATE PROCEDURE find_donation_types @donation_type char(9) AS
SELECT * FROM Donation WHERE donation_type = @donation_type;
EXEC find_donation_types @donation_type = 'Blood';
EXEC find_donation_types @donation_type = 'Power Red';
EXEC find_donation_types @donation_type = 'Platelets';
EXEC find_donation_types @donation_type = 'Plasma';

-- Stored procedure for finding all specific blood_types from blood_bags --
CREATE PROCEDURE find_blood_types @blood_type char(3) AS
SELECT * FROM Blood_Bags WHERE blood_type = @blood_type;
EXEC find_blood_types @blood_type = 'A+';
EXEC find_blood_types @blood_type = 'A-';
EXEC find_blood_types @blood_type = 'B+';
EXEC find_blood_types @blood_type = 'B-';
EXEC find_blood_types @blood_type = 'AB+';
EXEC find_blood_types @blood_type = 'AB-';
EXEC find_blood_types @blood_type = 'O+';
EXEC find_blood_types @blood_type = 'O-';

-- Stored procedure for finding all transfusion patients who experience side_effects --
CREATE PROCEDURE find_transfusion_side_effects @side_effects varchar(20) AS
SELECT * FROM Transfusion WHERE side_effects = @side_effects;
EXEC find_transfusion_side_effects @side_effects = 'Fever';
EXEC find_transfusion_side_effects @side_effects = 'Hives';
EXEC find_transfusion_side_effects @side_effects = 'Respiratory distress';
EXEC find_transfusion_side_effects @side_effects = 'Hypotension';
EXEC find_transfusion_side_effects @side_effects = 'Chills';
EXEC find_transfusion_side_effects @side_effects = 'Hemoglobinuria';
EXEC find_transfusion_side_effects @side_effects = 'Itching';
