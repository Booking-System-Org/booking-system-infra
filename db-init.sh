#!/bin/sh -e

DEV_DB="booking_system_development"

psql --variable=ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE "$DEV_DB";
EOSQL

psql --variable=ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$DEV_DB" <<-EOSQL
  -- Расширения
  CREATE EXTENSION "citext";
  CREATE EXTENSION "uuid-ossp";

  -- Роли
   CREATE USER api_user;
   GRANT ALL PRIVILEGES ON DATABASE "$DEV_DB" TO api_user;
   ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO api_user;
   
   CREATE USER booking_user;
   GRANT ALL PRIVILEGES ON DATABASE "$DEV_DB" TO booking_user;
   ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO booking_user;


EOSQL
