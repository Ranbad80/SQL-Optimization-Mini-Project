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

-- 6. List the names of students who have taken all courses offered by department v8 (deptId).
explain
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;

/*
Execution time: 0:00:0.00620413
*/

#solution1
explain 
with cors_cte as(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript t join cors_cte c
		on t.crsCode = c.crsCode
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM cors_cte)) as alias
WHERE id = alias.studId;

/*
Execution time: 0:00:0.00510502
*/

# solution2
CREATE INDEX teach_indx ON Teaching(crsCode, semester, profId) USING BTREE;
explain 
with cors_cte as(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
SELECT name FROM Student,
	(SELECT studId
	FROM Transcript t join cors_cte c
		on t.crsCode = c.crsCode
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM cors_cte)) as alias
WHERE id = alias.studId;

/*
Execution time: 0:00:0.00070715
*/
