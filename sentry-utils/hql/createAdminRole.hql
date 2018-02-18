-- Use back tick to handle specical character such as '-' in group names, database / tables names
CREATE ROLE admin;
GRANT ALL ON SERVER server1 TO ROLE admin;
