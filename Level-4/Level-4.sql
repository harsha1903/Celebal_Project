/*Table Creation*/
CREATE TABLE SubjectAllotments(
StudentId varchar(10),
SubjectId varchar(10),
Is_Valid bit
);

CREATE TABLE SubjectRequest(
StudentId varchar(10),
SubjectId varchar(10)
);

/*Data Insertion*/
/*Data Insertion for SubjectAllotments*/
INSERT INTO SubjectAllotments VALUES
('159103036','PO1491',1),
('159103036','PO1492',0),
('159103036','PO1493',0),
('159103036','PO1494',0),
('159103036','PO1495',0);

/*Data Insertion for SubjectRequest*/
INSERT INTO SubjectRequest VALUES
('159103036','PO1496');

/*Subject Change Request Procedure*/
CREATE  PROCEDURE SubjectChangeRequest
AS 
BEGIN
	DECLARE @SubjectId varchar(10) = (SELECT SubjectId FROM SubjectRequest);
	IF @SubjectID IN (SELECT SubjectID FROM SubjectAllotments)
	BEGIN
		UPDATE SubjectAllotments
		SET Is_Valid=0
		WHERE Is_Valid=1;

		UPDATE SubjectAllotments
		SET Is_Valid=1
		WHERE SubjectId=@SubjectId;
	END
	ELSE
	BEGIN
		UPDATE SubjectAllotments
		SET Is_Valid=0
		WHERE Is_Valid=1;

		INSERT INTO SubjectAllotments VALUES
		('159103036',@SubjectId,1);
	END
	SELECT *FROM SubjectAllotments;
END;

/*Execution*/
EXEC SubjectChangeRequest;
