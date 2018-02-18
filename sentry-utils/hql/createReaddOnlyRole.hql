-- Use back tick to handle specical character such as '-' in group names, database / tables names
CREATE ROLE readonly;
GRANT ALL ON DATABASE A  TO ROLE readonly;
