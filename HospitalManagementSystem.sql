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



-- FUNCTION

DELIMITER $$

CREATE FUNCTION HMS.GetPatientCountAtRoom(roomIDInput CHAR(3))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE patientCount INT;

    -- Calculate the number of patients currently in the room
    SELECT 
        COUNT(patientID) 
    INTO 
        patientCount
    FROM 
        HMS.Admitted_to
    WHERE 
        roomID = roomIDInput 
        AND admittedDate <= NOW()
        AND (dischargedDate > NOW() OR dischargedDate IS NULL);

    RETURN patientCount;
END$$

DELIMITER ;

-- PROCEDURE

DELIMITER $$

CREATE PROCEDURE HMS.GetPatientCountAllRoomAtDate(atDate DATE)
BEGIN
    SELECT 
        roomID, 
        COUNT(patientID) AS patientCount
    FROM HMS.Admitted_to
    WHERE admittedDate <= atDate 
      AND (dischargedDate > atDate OR dischargedDate IS NULL)
    GROUP BY roomID;
END$$

DELIMITER ;

-- TRIGGER

DELIMITER $$

CREATE TRIGGER HMS.CheckRoomCapacity
BEFORE INSERT ON HMS.Admitted_to
FOR EACH ROW
BEGIN
    DECLARE currentCount INT;
    DECLARE roomCapacity INT;

    -- Get the current number of patients in the room
    SELECT COUNT(patientID)
    INTO currentCount
    FROM HMS.Admitted_to
    WHERE roomID = NEW.roomID 
      AND admittedDate <= NEW.admittedDate 
      AND (dischargedDate > NEW.admittedDate OR dischargedDate IS NULL);

    -- Get the room's capacity
    SELECT capacity
    INTO roomCapacity
    FROM HMS.Room
    WHERE roomID = NEW.roomID;

    -- Check if adding the new patient exceeds the capacity
    IF currentCount >= roomCapacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room capacity exceeded';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsurePatientAvailability
BEFORE INSERT ON HMS.Appointment
FOR EACH ROW
BEGIN
    DECLARE overlappingAppointments INT;

    -- Check if there are any overlapping appointments for the patient
    SELECT 
        COUNT(*)
    INTO 
        overlappingAppointments
    FROM 
        HMS.Appointment
    WHERE 
        patientID = NEW.patientID
        AND appointmentDate = NEW.appointmentDate
        AND (
            (NEW.appointmentTime BETWEEN appointmentTime AND ADDTIME(appointmentTime, '00:30:00'))
            OR (appointmentTime BETWEEN NEW.appointmentTime AND ADDTIME(NEW.appointmentTime, '00:30:00'))
        );

    -- If overlapping appointments exist, raise an error
    IF overlappingAppointments > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient is already scheduled for another appointment at this time';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsureUniqueRoomForPatient
BEFORE INSERT ON HMS.Admitted_to
FOR EACH ROW
BEGIN
    DECLARE overlappingAdmissions INT;

    -- Check if the patient is already admitted to another room during the new admission period
    SELECT 
        COUNT(*)
    INTO 
        overlappingAdmissions
    FROM 
        HMS.Admitted_to
    WHERE 
        patientID = NEW.patientID
        AND (
            (NEW.admittedDate BETWEEN admittedDate AND IFNULL(dischargedDate, NOW())) -- Overlap with an existing admission
            OR (admittedDate BETWEEN NEW.admittedDate AND IFNULL(NEW.dischargedDate, NOW()))
        );

    -- If overlapping admissions exist, raise an error
    IF overlappingAdmissions > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient is already admitted to another room during this time period';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsureNurseAssignedToAdjacentRooms
BEFORE INSERT ON HMS.Takes_care
FOR EACH ROW
BEGIN
    DECLARE room1 CHAR(3);
    DECLARE room2 CHAR(3);
    DECLARE roomCount INT;

    -- Check how many rooms the nurse is already assigned to
    SELECT 
        COUNT(*)
    INTO 
        roomCount
    FROM 
        HMS.Takes_care
    WHERE 
        nurseID = NEW.nurseID;

    -- If nurse is assigned to two rooms, validate adjacency
    IF roomCount = 2 THEN
        SELECT 
            GROUP_CONCAT(roomID ORDER BY roomID)
        INTO 
            @assignedRooms
        FROM 
            HMS.Takes_care
        WHERE 
            nurseID = NEW.nurseID;

        SET room1 = SUBSTRING_INDEX(@assignedRooms, ',', 1);
        SET room2 = SUBSTRING_INDEX(@assignedRooms, ',', -1);

        -- Check if the new room is adjacent to both existing rooms
        IF NOT (ABS(NEW.roomID - room1) = 1 OR ABS(NEW.roomID - room2) = 1) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nurse can only be assigned to two adjacent rooms';
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsureNurseAssignedToOccupiedRoom
AFTER INSERT ON HMS.Admitted_to
FOR EACH ROW
BEGIN
    DECLARE nurseCount INT;

    -- Check if there is at least one nurse assigned to the room
    SELECT 
        COUNT(*)
    INTO 
        nurseCount
    FROM 
        HMS.Takes_care
    WHERE 
        roomID = NEW.roomID;

    -- If no nurses are assigned to the room, raise an error
    IF nurseCount = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No nurse assigned to this room with admitted patients';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsureNurseAssignedToOccupiedRoomAfterDelete
AFTER DELETE ON HMS.Admitted_to
FOR EACH ROW
BEGIN
    DECLARE remainingPatients INT;
    DECLARE nurseCount INT;

    -- Check if there are any remaining patients in the room
    SELECT 
        COUNT(*)
    INTO 
        remainingPatients
    FROM 
        HMS.Admitted_to
    WHERE 
        roomID = OLD.roomID;

    -- If there are still patients in the room, check nurse assignments
    IF remainingPatients > 0 THEN
        SELECT 
            COUNT(*)
        INTO 
            nurseCount
        FROM 
            HMS.Takes_care
        WHERE 
            roomID = OLD.roomID;

        -- If no nurses are assigned, raise an error
        IF nurseCount = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No nurse assigned to this room with admitted patients';
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER HMS.EnsureDoctorAvailability
BEFORE INSERT ON HMS.Appointment
FOR EACH ROW
BEGIN
    DECLARE conflictingCount INT;

    -- Check if the doctor already has an overlapping appointment
    SELECT 
        COUNT(*)
    INTO 
        conflictingCount
    FROM 
        HMS.Appointment
    WHERE 
        doctorID = NEW.doctorID
        AND appointmentDate = NEW.appointmentDate
        AND (
            (NEW.appointmentTime >= appointmentTime AND NEW.appointmentTime < ADDTIME(appointmentTime, '00:10:00')) 
            OR 
            (ADDTIME(NEW.appointmentTime, '00:10:00') > appointmentTime AND ADDTIME(NEW.appointmentTime, '00:10:00') <= ADDTIME(appointmentTime, '00:10:00'))
        );

    -- If there is a conflict, raise an error
    IF conflictingCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A doctor can be scheduled for at most one appointment every 10 minutes.';
    END IF;
END$$

DELIMITER ;