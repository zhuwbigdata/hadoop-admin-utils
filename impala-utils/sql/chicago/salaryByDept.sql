USE chicago;
SELECT department, CAST(SUM(salary) AS  decimal(12,2)) FROM employeesalariesandtitles GROUP BY department;

