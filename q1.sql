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

-- 1. List the name of the student with id equal to v1 (id).
SELECT name FROM Student WHERE id = @v1;

# Check query performance
EXPLAIN SELECT name FROM Student WHERE id = @v1;

/*
Timing (as measured at client side):
Execution time: 0:00:0.04756093

Query stats can only be fetched when a single statement is executed.
*/

# solution
Create index std_index on student(id);
explain
SELECT name FROM Student WHERE id = @v1;

/*
Timing (as measured at client side):
Execution time: 0:00:0.00069809
Query stats can only be fetched when a single statement is executed.

*/
