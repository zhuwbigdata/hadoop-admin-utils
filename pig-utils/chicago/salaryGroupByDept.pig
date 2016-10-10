employee_data  = LOAD '$INPUT_DIR/*' USING PigStorage(',') AS (lname::chararray, fname:chararray, title:chararray, department:chararray, salary:double);
groupByDept  = GROUP employee_data BY department;
salaryByDept = FOREACH groupByDept GENERATE group, ROUND(SUM(employee_data.salary)*100.0)/100.0  AS sum;
salaryByDept_ordered = ORDER salaryByDept BY sum DESC;
describe  employee_data;
describe  groupByDept;
describe  salaryByDept;
store salaryByDept_ordered into '$OUTPUT_DIR/' using PigStorage(',');

