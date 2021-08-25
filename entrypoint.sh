#!/bin/bash

DICOM_INI=/opt/conquest/linux/dicom.ini

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

    sed -i "s@SQLHost.*@SQLHost = $POSTGRES_HOST@" $DICOM_INI
    sed -i "s@SQLServer.*@SQLServer = $POSTGRES_SERVER@" $DICOM_INI
    sed -i "s@Username.*@Username = $POSTGRES_USERNAME@" $DICOM_INI
    sed -i "s@Password.*@Password = $POSTGRES_PASSWORD@" $DICOM_INI
    sed -i "s@PostGres.*@PostGres = 1@" $DICOM_INI
    sed -i "s@UseEscapeStringConstants.*@UseEscapeStringConstants = 1@" $DICOM_INI
    sed -i "s@DoubleBackSlashToDB.*@DoubleBackSlashToDB = 1@" $DICOM_INI
    sed -i "s@MyACRNema.*@MyACRNema = $AE_TITLE@" $DICOM_INI
    sed -i "s@PACSName.*@PACSName = $AE_TITLE@" $DICOM_INI

  ;;
"sqlite")
    sed -i "s@sql_server_placeholder@/opt/conquest/data/dbase/conquest.db3@" $DICOM_INI
    sed -i "s@SQLite*\$@SQLite = 1@" $DICOM_INI
  ;;
*)
  echo "5" | /opt/conquest/maklinux
  ;;
esac

chmod 0700 /opt/conquest/linux/dgate
chown www-data:www-data /opt/conquest/webserver

cat $DICOM_INI

# Regenerate the database
/opt/conquest/linux/dgate -v -r

service apache2 restart

# Log apache and conquest logs to the docker logs too
touch /var/log/apache2/error.log
touch /opt/conquest/PacsTrouble.log

ln -sf /proc/1/fd/1 /var/log/apache2/error.log
ln -sf /proc/1/fd/1 /opt/conquest/linux/PacsTrouble.log

/opt/conquest/linux/dgate -v
