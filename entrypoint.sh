#!/bin/bash

set -e

CONQUEST_HOME=/opt/conquest
DICOM_INI=$CONQUEST_HOME/dicom.ini.template
DICOM_INI=$CONQUEST_HOME/dicom.ini
CGI_DIR=/usr/lib/cgi-bin

cd $CONQUEST_HOME

# Set defaults
AE_TITLE="${AE_TITLE:-CONQUESTSRV1}"
PORT="${PORT:-5678}"
DEBUG_LEVEL="${DEBUG_LEVEL:-0}"

# Replace vars that are independant of db choice
sed -i "s@MyACRNema.*@MyACRNema = $AE_TITLE@" $DICOM_INI_TEMPLATE
sed -i "s@PACSName.*@PACSName = $AE_TITLE@" $DICOM_INI_TEMPLATE
sed -i "s@TCPPort.*@TCPPort = $PORT@" $DICOM_INI_TEMPLATE
sed -i "s@DebugLevel.*@DebugLevel = $DEBUG_LEVEL@" $DICOM_INI_TEMPLATE

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

    echo "2" | ./maklinux

    sed -i "s@SQLHost.*@SQLHost = $POSTGRES_HOST@" $DICOM_INI_TEMPLATE
    sed -i "s@SQLServer.*@SQLServer = $POSTGRES_SERVER@" $DICOM_INI_TEMPLATE
    sed -i "s@Username.*@Username = $POSTGRES_USERNAME@" $DICOM_INI_TEMPLATE
    sed -i "s@Password.*@Password = $POSTGRES_PASSWORD@" $DICOM_INI_TEMPLATE
    sed -i "s@PostGres.*@PostGres = 1@" $DICOM_INI_TEMPLATE
    sed -i "s@UseEscapeStringConstants.*@UseEscapeStringConstants = 1@" $DICOM_INI_TEMPLATE
    sed -i "s@DoubleBackSlashToDB.*@DoubleBackSlashToDB = 1@" $DICOM_INI_TEMPLATE
    sed -i "s@BrowseThroughDBF.*@BrowseThroughDBF = 1@" $DICOM_INI_TEMPLATE

  ;;
"sqlite")
    sed -i "s@sql_server_placeholder@$CONQUEST_HOME/data/dbase/conquest.db3@" $DICOM_INI_TEMPLATE
    sed -i "s@SQLite.*\$@SQLite = 1@" $DICOM_INI_TEMPLATE
  ;;
"dbase" | *)
  echo "5" | ./maklinux
  ;;
esac

find $CONQUEST_HOME -type f -name "*dicom.sql*"

# Copy the dicom.sql file
cp $CONQUEST_HOME/linux/conf/dicom.sql.$DB_TYPE $CONQUEST_HOME/dicom.sql

# Change the allowed webroot in the main apache config
sed -i "s@/var/www@$CONQUEST_HOME/webserver@" /etc/apache2/apache2.conf

# Copy dgate binary to cgi-bin
cp $CONQUEST_HOME/linux/dgate $CGI_DIR/dgate
cp $CONQUEST_HOME/linux/dgate $CONQUEST_HOME/dgate

# Fix permissions
chmod 0700 $CGI_DIR/dgate
chmod 0700 $CONQUEST_HOME/dgate
chown -R www-data:www-data $CGI_DIR/dgate
chown -R www-data:www-data $CONQUEST_HOME/webserver

cp $DICOM_INI_TEMPLATE $DICOM_INI

cat $DICOM_INI

# Regenerate the database
cd $CONQUEST_HOME
./dgate -v -r

service apache2 restart

# Log apache and conquest logs to the docker logs too
touch /var/log/apache2/error.log
touch $CONQUEST_HOME/PacsTrouble.log

#ln -sf /proc/1/fd/1 /var/log/apache2/error.log
#ln -sf /proc/1/fd/1 $CONQUEST_HOME/linux/PacsTrouble.log

./dgate -v
