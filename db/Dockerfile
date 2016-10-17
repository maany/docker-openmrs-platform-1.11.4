FROM mysql:5.6

# Copy the OpenMRS database schema to the /data directory
ADD openmrs-database-dump-1.11.4.sql /docker-entrypoint-initdb.d/openmrs-platform-database.sql
