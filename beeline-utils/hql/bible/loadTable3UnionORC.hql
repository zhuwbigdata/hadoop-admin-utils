USE  bible;
INSERT OVERWRITE TABLE orc 
SELECT regexp_extract(idx,'^([A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 1), regexp_extract(idx,'^([A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 2), regexp_extract(idx,'^([A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 3), verse  FROM singles
UNION ALL
SELECT regexp_extract(idx,'^([1-9] [A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 1), regexp_extract(idx,'([1-9] [A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 2), regexp_extract(idx,'^([1-9] [A-Z][a-z]+) ([0-9]+)\:([0-9]+)$', 3), verse  FROM multiples;
ANALYZE TABLE orc COMPUTE STATISTICS;
SELECT COUNT(*) FROM singles;
SELECT COUNT(*) FROM multiples;
SELECT COUNT(*) FROM orc;
!quit
