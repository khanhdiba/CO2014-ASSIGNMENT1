DROP SCHEMA IF EXISTS HMS;
CREATE SCHEMA HMS;
USE HMS;

CREATE TABLE HMS.Department (
    departmentID CHAR(2),
    departmentName VARCHAR(50),
    PRIMARY KEY (departmentID)
);

CREATE TABLE HMS.Medical_Staff (
    staffID	CHAR(7),
    staffSSN CHAR(10) NOT NULL UNIQUE,
    firstName VARCHAR(20) NOT NULL,
    midName	 VARCHAR(50),
    lastName VARCHAR(20),
    staffDoB DATE,
    gender	ENUM ('F', 'M'),
    phoneNumber	CHAR(10),
    salary	INT UNSIGNED,
    departmentID CHAR(2),
    
    PRIMARY KEY (staffID),
    FOREIGN KEY (departmentID) REFERENCES Department (departmentID)
);

CREATE TABLE HMS.Doctor (
    doctorID CHAR(7),
    license	CHAR(12),
    
    PRIMARY KEY (doctorID),
    FOREIGN KEY (doctorID) REFERENCES Medical_Staff (staffID)
);

CREATE TABLE HMS.Manages (
    departmentID CHAR(2),
    doctorID CHAR(7) NOT NULL UNIQUE,
    startDate DATE NOT NULL,
    
    PRIMARY KEY (departmentID),
    FOREIGN KEY (departmentID) REFERENCES Department (departmentID),
    FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID)
);

CREATE TABLE HMS.Specialization (
    doctorID CHAR(7),
    aSpecialization	VARCHAR(20),
    
    PRIMARY KEY (doctorID, aSpecialization),
    FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID)
);

CREATE TABLE HMS.Nurse (
    nurseID	CHAR(7),
    yearExperience CHAR(12),
    
    PRIMARY KEY (nurseID),
    FOREIGN KEY (nurseID) REFERENCES Medical_Staff (staffID)
);

CREATE TABLE HMS.Room (
    roomID CHAR(3),
    capacity INT,
    roomType VARCHAR(20),
    
    PRIMARY KEY (roomID)
);

CREATE TABLE HMS.Patient (
    patientID CHAR(7),
    patientSSN CHAR(10)	NOT NULL UNIQUE,
    firstName VARCHAR(20) NOT NULL,
    midName	VARCHAR(50),
    lastName VARCHAR(20),
    patientDoB DATE,
    gender ENUM ('F', 'M'),
    phoneNumber CHAR(10),
    street VARCHAR(50),
    district VARCHAR(50),
    city VARCHAR(50),    
    
    PRIMARY KEY (patientID)
);

CREATE TABLE HMS.Patients_Family (
    familyID INT,
    patientID CHAR(7) NOT NULL,
    relationship VARCHAR(50),
    phoneNumber CHAR(10),
    
    PRIMARY KEY (patientID, familyID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID)
);

CREATE TABLE HMS.Admitted_to (
    patientID CHAR(7),
    roomID CHAR(3),
    admittedDate DATE,
    dischargedDate DATE,
    
    PRIMARY KEY (patientID, roomID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (roomID) REFERENCES Room (roomID)
);

CREATE TABLE HMS.Appointment (
    appointmentID INT,
    patientID CHAR(7),
    doctorID CHAR(7),
    appointmentDate DATE,
    appointmentTime TIME,
    
    PRIMARY KEY (appointmentID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID)
);

CREATE TABLE HMS.Pharmacy (
    pharmacyID CHAR(2),
    pharmacyName VARCHAR(50),
    
    PRIMARY KEY (pharmacyID)
);

CREATE TABLE HMS.Medicine (
    medicineID CHAR(11),
    medicineName VARCHAR(50),
    dosage VARCHAR(1000),
    pharmacyID CHAR(2) NOT NULL,
    
    PRIMARY KEY (medicineID),
    FOREIGN KEY (pharmacyID) REFERENCES Pharmacy (pharmacyID)
);

CREATE TABLE HMS.Payment_Approach (
    PAID CHAR(3),    
    PRIMARY KEY (PAID)
);

CREATE TABLE HMS.Cash (
    cashierID CHAR(3),
    cashierName	VARCHAR(50),
    PAID CHAR(3) NOT NULL,
    
    PRIMARY KEY (cashierID),
    FOREIGN KEY (PAID) REFERENCES Payment_Approach (PAID)
);

CREATE TABLE HMS.Bank (
    bankID CHAR(3),
    bankName VARCHAR(50),
    PAID CHAR(3) NOT NULL,
    
    PRIMARY KEY (bankID),
    FOREIGN KEY (PAID) REFERENCES Payment_Approach (PAID)
);

CREATE TABLE HMS.Ewallet (
    ewalletID CHAR(3),
    ewalletName	VARCHAR(50),
    PAID CHAR(3) NOT NULL,
    
    PRIMARY KEY (ewalletID),
    FOREIGN KEY (PAID) REFERENCES Payment_Approach (PAID)
);

CREATE TABLE HMS.Bill (
    billID INT,
    patientID CHAR(7) NOT NULL,
    amount INT UNSIGNED,
    createdDate	DATE,
    paymentStatus BOOLEAN,
    PAID CHAR(3),
    paidDate DATE,
    
    PRIMARY KEY (billID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (PAID) REFERENCES Payment_Approach (PAID)
);

CREATE TABLE HMS.Treatment (
    treatmentID INT,
    patientID CHAR(7) NOT NULL,
    treatmentDate DATE,
    treatmentProcedure VARCHAR(1000),
    
    PRIMARY KEY (treatmentID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID)
);

CREATE TABLE HMS.Medical_Record (
    recordID INT,
    patientID CHAR(7) NOT NULL,
    recordDate DATE,
    treatmentID	INT NOT NULL,
    diagnosis VARCHAR(1000),
    testResult VARCHAR(1000),
    
    PRIMARY KEY (patientID, recordID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (treatmentID) REFERENCES Treatment (treatmentID)
);

CREATE TABLE HMS.Performs (
    doctorID CHAR(7) NOT NULL,
    treatmentID	INT NOT NULL,
    
    PRIMARY KEY (doctorID, treatmentID),
    FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID),
    FOREIGN KEY (treatmentID) REFERENCES Treatment (treatmentID)
);

CREATE TABLE HMS.Assists (
    nurseID	CHAR(7) NOT NULL,
    treatmentID	INT	NOT NULL,
    
    PRIMARY KEY (nurseID, treatmentID),
    FOREIGN KEY (nurseID) REFERENCES Nurse (nurseID),
    FOREIGN KEY (treatmentID) REFERENCES Treatment (treatmentID)
);

CREATE TABLE HMS.Takes_care (
    nurseID	CHAR(7)	NOT NULL,
    roomID CHAR(3) NOT NULL,
    
    PRIMARY KEY (nurseID, roomID),
    FOREIGN KEY (nurseID) REFERENCES Nurse (nurseID),
    FOREIGN KEY (roomID ) REFERENCES Room (roomID )
);

CREATE TABLE HMS.Prescribes (
    medicineID CHAR(11)	NOT NULL,
    patientID CHAR(7) NOT NULL,
    doctorID CHAR(7) NOT NULL,
    prescribesDate DATE,
    
    PRIMARY KEY (patientID, medicineID, doctorID),
    FOREIGN KEY (patientID) REFERENCES Patient (patientID),
    FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID),
    FOREIGN KEY (medicineID) REFERENCES Medicine (medicineID)
);

DROP ROLE IF EXISTS admin_role, doctor_role, nurse_role, receptionist_role, patient_role;

CREATE ROLE 'admin_role';
GRANT ALL PRIVILEGES ON HMS.* TO 'admin_role';

CREATE ROLE 'doctor_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Appointment TO 'doctor_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Medical_Record TO 'doctor_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Treatment TO 'doctor_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Prescribes TO 'doctor_role';
GRANT SELECT ON HMS.Patient TO 'doctor_role';
GRANT SELECT ON HMS.Doctor TO 'doctor_role';
GRANT SELECT ON HMS.Nurse TO 'doctor_role';
GRANT SELECT ON HMS.Room TO 'doctor_role';
GRANT SELECT ON HMS.Admitted_to TO 'doctor_role';
GRANT SELECT ON HMS.Medicine TO 'doctor_role';

CREATE ROLE 'nurse_role';
GRANT SELECT, UPDATE ON HMS.Patient TO 'nurse_role';
GRANT SELECT ON HMS.Room TO 'nurse_role';
GRANT SELECT ON HMS.Admitted_to TO 'nurse_role';
GRANT SELECT ON HMS.Treatment TO 'nurse_role';
GRANT SELECT ON HMS.Prescribes TO 'nurse_role';

CREATE ROLE 'receptionist_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Patient TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Patients_Family TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Appointment TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Admitted_to TO 'receptionist_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON HMS.Bill TO 'receptionist_role';

CREATE ROLE 'patient_role';
CREATE VIEW HMS.Patient_View AS
    SELECT * FROM HMS.Patient WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
CREATE VIEW HMS.Patients_Family_View AS
    SELECT * FROM HMS.Patients_Family WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
CREATE VIEW HMS.Appointment_View AS
    SELECT * FROM HMS.Appointment WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
CREATE VIEW HMS.Medical_Record_View AS
    SELECT * FROM HMS.Medical_Record WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
CREATE VIEW HMS.Prescribes_View AS
    SELECT * FROM HMS.Prescribes WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
CREATE VIEW HMS.Bill_View AS
    SELECT * FROM HMS.Bill WHERE patientID = SUBSTRING_INDEX(USER(), '@', 1);
GRANT SELECT ON HMS.Patient_View TO 'patient_role';
GRANT SELECT ON HMS.Patients_Family_View TO 'patient_role';
GRANT SELECT ON HMS.Appointment_View TO 'patient_role';
GRANT SELECT ON HMS.Medical_Record_View TO 'patient_role';
GRANT SELECT ON HMS.Prescribes_View TO 'patient_role';
GRANT SELECT ON HMS.Bill_View TO 'patient_role';

FLUSH PRIVILEGES;