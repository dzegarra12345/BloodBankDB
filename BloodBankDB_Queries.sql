-- Queries --

SELECT * FROM Person ORDER BY LEN (pid), pid;
SELECT * FROM Donor ORDER BY LEN (pid), pid;
SELECT * FROM Patient ORDER BY LEN (pid), pid;
SELECT * FROM Nurse ORDER BY LEN (pid), pid;
SELECT * FROM Pre_Exam ORDER BY LEN (peid), peid;
SELECT * FROM Donor ORDER BY LEN (pid), pid;
SELECT * FROM Donation ORDER BY LEN (did), did;
SELECT * FROM Blood_Bags ORDER BY LEN (bbid), bbid;
SELECT * FROM Transfusion ORDER BY LEN (tid), tid;
DELETE FROM Donation
DROP TABLE Donation
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
