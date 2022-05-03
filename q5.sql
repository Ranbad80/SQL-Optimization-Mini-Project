USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 5. List the names of students who have taken a course from department v6 (deptId), but not v7.
SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;

# Check the query performance
explain
SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;

/*
Execution time: 0:00:0.00832987
*/

# solution 1
SELECT s.* FROM Student As s INNER JOIN Transcript as t ON s.id = t.studId INNER JOIN Course as c ON t.crsCode = c.crsCode 
WHERE  c.deptId = @v6 and c.deptId != @v7; 

/*
Execution time: 0:00:0.00627899
*/
# solution 2
create index tran_index on Transcript(studId,crsCode);
create index cors_index on Course(deptId,crsCode);
explain
SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;

/*
Execution time: 0:00:0.00183010
*/
#solution 3
create index tran_index on Transcript(studId,crsCode);
create index cors_index on Course(deptId,crsCode);
explain
SELECT s.* FROM Student As s INNER JOIN Transcript as t ON s.id = t.studId INNER JOIN Course as c ON t.crsCode = c.crsCode 
WHERE  c.deptId = @v6; 

/*
Execution time: 0:00:0.00061703
*/


