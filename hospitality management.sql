use NEWPROJECT
select * from DOCTOR
select * from PATIENT
select * from PATIENT HISTORY
select * from APPOINTMENTID_PAINTIENTID
select * from MEDICAL_HISTORY
select * from MEDICATION_COST
select * from PATIENTSAPPOINTMENTS

----------------------------------------------------------------------------------------------------

--Appointments per doctor with rank (most to least busy)

SELECT 
    d.DoctorID,
    CONCAT(d.Fname, ' ', d.Lname) AS DoctorName,
    COUNT(a.AppointmentID) AS AppointmentCount,
    rank() OVER (ORDER BY COUNT(a.AppointmentID) DESC) AS BusyRank
FROM 
    APPOINTMENTID_PAINTIENTID a
INNER JOIN 
    Doctor d ON a.DoctorID = d.DoctorID
GROUP BY 
    d.DoctorID, d.Fname, d.Lname;



---------------------------------------------------------------------------------------------

--Peak booking hours (by start time hour) 

SELECT 
    DATEPART(HOUR,Date) AS StartHour,
    COUNT(*) AS AppointmentCount
FROM APPOINTMENTID_PAINTIENTID
GROUP BY 
    DATEPART(HOUR,Date )
ORDER BY 
    AppointmentCount DESC;

-------------------------------------------------------------------------------------------

--Which doctor has the most appointments?

 SELECT TOP 1
    AP.DoctorID,
    CONCAT(doc.Fname, ' ', doc.Lname) AS DoctorName,
    COUNT(AP.AppointmentID) AS AppointmentCount
FROM 
    APPOINTMENTID_PAINTIENTID AS AP
INNER JOIN 
    doctor AS doc 
    ON AP.DoctorID = doc.DoctorID
GROUP BY 
    AP.DoctorID, doc.Fname, doc.Lname
ORDER BY 
    AppointmentCount DESC;

------------------------------------------------------------------------------------------------

--How many patients does each doctor treat

SELECT 
    d.DoctorID,
    CONCAT(d.Fname, ' ', d.Lname) AS DoctorName,
    COUNT( a.PatientID) AS TotalPatientsTreated
FROM 
    [APPOINTMENTID_PAINTIENTID] a
INNER JOIN 
    Doctor d ON a.DoctorID  = d.DoctorID 
GROUP BY 
    d.DoctorID, d.Fname, d.Lname
ORDER BY 
    TotalPatientsTreated DESC;



---------------------------------------------------------------------------------------------------------
--Doctor–patient pairs with most interactions (top 10)

   
SELECT Top 10
    AP.DoctorID,
    CONCAT(d.Fname, ' ', d.Lname) AS DoctorName,
    CONCAT(p.Fname, ' ', p.Lname) AS PatientName,
    COUNT(*) AS InteractionCount
FROM APPOINTMENTID_PAINTIENTID AP
INNER JOIN Doctor d 
    ON d.DoctorID = AP.DoctorID 
INNER JOIN Patient p 
    ON AP.PatientID = p.PatientID
GROUP BY 
    AP.DoctorID, d.Fname, d.Lname,
    p.Fname, p.Lname
ORDER BY 
    InteractionCount DESC;

-------------------------------------------------------------------------------------------------
--First and most recent visit per patient (with total visits)


SELECT 
    p.PatientID,
    CONCAT(p.Fname,' ', p.Lname) AS PatientName,
    MIN(a.Date) AS FirstVisit,
    MAX(a.EndTime) AS MostRecentVisit,
    COUNT(*) AS TotalVisits
FROM PATIENTSAPPOINTMENTS pa
INNER JOIN PATIENT p 
    ON pa.PatientID = p.PatientID
INNER JOIN APPOINTMENTID_PAINTIENTID a 
    ON pa.AppointmentID = a.AppointmentID
GROUP BY 
    p.PatientID, p.Fname, p.Lname
ORDER BY 
    TotalVisits DESC;

