#!/bin/bash

case $DB_TYPE in
"postgres")

    if [ -z "$POSTGRES_HOST" ]; then
      >&2 echo "DB_TYPE is postgres but POSTGRES_HOST env var not set"
      exit 1
    fi
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

    AE_TITLE="${AE_TITLE:-CONQUESTSRV1}"

    echo "2" | /opt/conquest/maklinux

    sed -i "s@SQLHost.*@SQLHost = $POSTGRES_HOST@" dicom.ini
    sed -i "s@SQLServer.*@SQLServer = $POSTGRES_SERVER@" dicom.ini
    sed -i "s@Username.*@Username = $POSTGRES_USERNAME@" dicom.ini
    sed -i "s@Password.*@Password = $POSTGRES_PASSWORD@" dicom.ini
    sed -i "s@PostGres.*@PostGres = 1@" dicom.ini
    sed -i "s@UseEscapeStringConstants.*@UseEscapeStringConstants = 1@" dicom.ini
    sed -i "s@DoubleBackSlashToDB.*@DoubleBackSlashToDB = 1@" dicom.ini
    sed -i "s@MyACRNema.*@MyACRNema = $AE_TITLE@" dicom.ini
    sed -i "s@PACSName.*@PACSName = $AE_TITLE@" dicom.ini

  ;;
"sqlite")
    sed -i "s@sql_server_placeholder@/opt/conquest/data/dbase/conquest.db3@" dicom.ini
    sed -i "s@SQLite*\$@SQLite = 1@" dicom.ini
  ;;
*)
  echo "5" | /opt/conquest/maklinux
  ;;
esac

cat /opt/conquest/dicom.ini

# Regenerate the database
/opt/conquest/dgate -v -r

service apache2 restart



# Log apache and conquest logs to the docker logs too
touch /var/log/apache2/error.log
touch /opt/conquest/PacsTrouble.log

ln -sf /proc/1/fd/1 /var/log/apache2/error.log
ln -sf /proc/1/fd/1 /opt/conquest/PacsTrouble.log

/opt/conquest/dgate -v
