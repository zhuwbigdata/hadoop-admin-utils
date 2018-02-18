USE bible;
INSERT OVERWRITE TABLE singles   SELECT * FROM  raw WHERE idx RLIKE '^[A-Z][a-z]+ [0-9]+\:[0-9]+$';
INSERT OVERWRITE TABLE multiples SELECT * FROM  raw WHERE idx RLIKE '^[1-9] [A-Z][a-z]+ [0-9]+\:[0-9]+$';
SELECT COUNT(*) FROM raw;
SELECT COUNT(*) FROM singles;
SELECT COUNT(*) FROM multiples;
!quit
