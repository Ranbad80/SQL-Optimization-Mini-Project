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

-- 3. List the names of students who have taken course v4 (crsCode).
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

 # Check the query performance
  Explain
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

/*Timing (as measured at client side):
Execution time: 0:00:0.00890589
*/

# solution 1
Explain
SELECT name from Student As s INNER JOIN Transcript as t ON s.id = t.studId WHERE t.crsCode = @v4;

/*
Timing (as measured at client side):
Execution time: 0:00:0.00347519
*/

#solution2
CREATE INDEX trans_indx ON Transcript(crsCode, studId) ;
Explain
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);

/*
Timing (as measured at client side):
Execution time: 0:00:0.00154209
*/

#solution3 
Drop index trans_indx ON Transcript ;
CREATE INDEX trans_indx ON Transcript(crsCode, studId) ;
Explain
SELECT name from Student As s INNER JOIN Transcript as t ON s.id = t.studId WHERE t.crsCode = @v4

/*
Timing (as measured at client side):
Execution time: 0:00:0.00051999
