/*Table CREATION*/
CREATE TABLE SubjectDetails(
SubjectId varchar(10) PRIMARY KEY,
SubjectName varchar(50),
MaxSeats int,
RemainingSeats int
);

CREATE TABLE StudentDetails(
StudentId int PRIMARY KEY,
StudentName varchar(50),
GPA numeric(3,1),
Branch varchar(3),
Section varchar(3)
);

CREATE TABLE StudentPreference(
StudentId int,
SubjectId varchar(10),
Preference int,
PRIMARY KEY(StudentId,SubjectId),
FOREIGN KEY(StudentID) REFERENCES StudentDetails(StudentId),
FOREIGN KEY(SubjectId) REFERENCES SubjectDetails(SubjectId) 
);

CREATE TABLE Allotments(
SubjectId varchar(10),
StudentId int,
PRIMARY KEY(StudentId,SubjectId),
FOREIGN KEY(StudentID) REFERENCES StudentDetails(StudentId),
FOREIGN KEY(SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE UnallotedStudents(
StudentId int PRIMARY KEY,
FOREIGN KEY(StudentId) REFERENCES StudentDetails(StudentId)
);

/*Data Insertion*/

/*Data Insertion for SubjectDetails Table */
INSERT INTO SubjectDetails VALUES 
('PO1491','Basics of Political Science',60,2),
('PO1492','Basics of Accounting',120,119),
('PO1493','Basics of Financial Markets',90,90),
('PO1494','Eco philosophy',60,50),
('PO1495','Automotive',60,60);

/*Data Insertion for StudentDetails Table */
INSERT INTO StudentDetails VALUES
(159103036,'Mohit Agarwal',8.9,'CCE','A'),
(159103037,'Rohit Agarwal',5.2,'CCE','A'),
(159103038,'Shohit Garg',7.1,'CCE','B'),
(159103039,'Mrinal Malhotra',7.9,'CCE','A'),
(159103040,'Mehreet Singh',5.6,'CCE','A'),
(159103041,'Arjun Tehlan',9.2,'CCE','B');

/*Data Insertion for StudentPreference Table */
/*Mohit AgarwalPreferences*/
INSERT INTO StudentPreference VALUES
(159103036,'PO1491',1),
(159103036,'PO1492',2),
(159103036,'PO1493',3),
(159103036,'PO1494',4),
(159103036,'PO1495',5);

/*Rohit Agarwal Preferences*/
INSERT INTO StudentPreference VALUES
(159103037,'PO1491',1),
(159103037,'PO1495',2),
(159103037,'PO1494',3),
(159103037,'PO1493',4),
(159103037,'PO1492',5);

/*Shohit Garg Preferences*/
INSERT INTO StudentPreference VALUES
(159103038,'PO1491',1),
(159103038,'PO1493',2),
(159103038,'PO1492',3),
(159103038,'PO1494',4),
(159103038,'PO1495',5);

/*Mrinal Malhotra Prefereces*/
INSERT INTO StudentPreference VALUES
(159103039,'PO1491',1),
(159103039,'PO1492',2),
(159103039,'PO1493',3),
(159103039,'PO1494',4),
(159103039,'PO1495',5);

/*Mehreet Singh Preferences*/
INSERT INTO StudentPreference VALUES
(159103040,'PO1493',1),
(159103040,'PO1491',2),
(159103040,'PO1492',3),
(159103040,'PO1495',4),
(159103040,'PO1494',5);

/*Arjun Tehlan Preferences*/
INSERT INTO StudentPreference VALUES
(159103041,'PO1491',1),
(159103041,'PO1492',2),
(159103041,'PO1493',3),
(159103041,'PO1495',4),
(159103041,'PO1494',5);

/*Assiging Students to Subjects Procedure*/
CREATE PROCEDURE Allocate_Subjects
AS
BEGIN
	CREATE TABLE #temp_student (
	StudentId int,
	Gpa numeric(3,1)
	);

	CREATE TABLE #temp_preference(
	SubjectId varchar(10),
	Preference int
	);
	
	INSERT INTO #temp_student(StudentId,Gpa)
	SELECT StudentId,Gpa FROM StudentDetails;

	DECLARE @count1 int=1;
	WHILE @count1<=6
	BEGIN
		DECLARE @StudentId int =(SELECT TOP 1 StudentId FROM #temp_student ORDER BY Gpa DESC);
		DECLARE @count2 int=1;

		INSERT INTO #temp_preference (SubjectId,Preference)
		SELECT SubjectId,Preference FROM StudentPreference WHERE StudentId=@StudentId;

		DECLARE @flag int=1; 
		WHILE @count2<=5
		BEGIN
			DECLARE @SubjectId varchar(10)=(SELECT TOP 1 SubjectId FROM #temp_preference ORDER BY Preference ASC);
			DECLARE @RemaningSeats int=(SELECT RemainingSeats FROM SubjectDetails WHERE SubjectId=@SubjectId);
			
			IF @RemaningSeats>0
				BEGIN
				INSERT INTO Allotments VALUES (@SubjectId,@StudentId);
				TRUNCATE TABLE #temp_preference;
				UPDATE SubjectDetails
				SET RemainingSeats=RemainingSeats-1
				WHERE SubjectId=@SubjectId;
				SET @flag=0;
				BREAK;
				END
			DELETE FROM #temp_preference WHERE SubjectId=@SubjectId;
			SET @count2=@count2+1;

		END
		IF @flag=1
			INSERT INTO UnallotedStudents VALUES (@StudentId);
		DELETE FROM #temp_student WHERE StudentId=@StudentId;
		SET @count1=@count1+1;
	END
END;

/*Execution*/
EXEC Allocate_Subjects;

/*
SELECT *FROM ALLOTMENTS;
SELECT *FROM UnallotedStudents;
*/
