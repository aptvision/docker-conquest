#!/bin/bash

case $DB_TYPE in
"postgres")

    if [ -z "$POSTGRES_SERVER" ]; then
      >&2 echo "DB_TYPE is postgres but POSTGRES_SERVER env var not set"
      exit 1
    fi
    if [ -z "$POSTGRES_USERNAME" ]; then
      >&2 echo "DB_TYPE is postgres but POSTGRES_USERNAME env var not set"
      exit 1
    fi
    if [ -z "$POSTGRES_PASSWORD" ]; then
      >&2 echo "DB_TYPE is postgres but POSTGRES_PASSWORD env var not set"
      exit 1
    fi

    sed -i "s@sql_server_placeholder@$POSTGRES_SERVER@" dicom.ini
    sed -i "s@sql_username_placeholder@$POSTGRES_USERNAME@" dicom.ini
    sed -i "s@sql_password_placeholder@$POSTGRES_PASSWORD@" dicom.ini
    sed -i "s@PostGres*\$@PostGres = 1@" dicom.ini
  ;;
"sqlite")
    sed -i "s@sql_server_placeholder@/opt/conquest/data/dbase/conquest.db3@" dicom.ini
    sed -i "s@SQLite*\$@SQLite = 1@" dicom.ini
  ;;
*)
  Message=""
  ;;
esac

service apache2 start
/opt/conquest/dgate -v
