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

-- 4. List the names of students who have taken a course taught by professor v5 (name).
SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

# Check the query performance
explain
SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

/*
Timing (as measured at client side):
Execution time: 0:00:0.02419400
*/

# solution 1
create index trans_id on Transcript(crsCode, studId, semester);
create index prof_id on Professor(name,id);
CREATE INDEX teach_indx ON Teaching(profId, crsCode, semester);

explain
SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

/*
Timing (as measured at client side):
Execution time: 0:00:0.00043511
*/

#solution 2
drop index trans_id on Transcript;
drop index prof_id on Professor;
drop INDEX teach_indx ON Teaching;

EXPLAIN  
SELECT s.name FROM Student As s 
         INNER JOIN Transcript as t ON s.id = t.studId 
         INNER JOIN Teaching as t1 ON t.crsCode = t1.crsCode 
         INNER JOIN Professor as p ON t1.profId = p.id WHERE p.name = @v5

/*
Timing (as measured at client side):
Execution time: 0:00:0.00050497
*/

#solution 3
create index trans_id on Transcript(crsCode, studId, semester);
create index prof_id on Professor(name,id);
CREATE INDEX teach_indx ON Teaching(profId, crsCode, semester);

EXPLAIN  
SELECT s.name FROM Student As s 
         INNER JOIN Transcript as t ON s.id = t.studId 
         INNER JOIN Teaching as t1 ON t.crsCode = t1.crsCode 
         INNER JOIN Professor as p ON t1.profId = p.id WHERE p.name = @v5

/*
Timing (as measured at client side):
Execution time: 0:00:0.00048685
*/

the solution1 is the best
     
