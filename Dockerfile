FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update \
    && apt-get upgrade -y \
    && apt-get install -y \
            wget \
            apache2 \
            g++ \
            unzip \
            p7zip-full \
            lua5.1 \
            lua5.1-dev \
            lua-socket \
            make \
            build-essential \
            gettext \
            # Needed for postgres
            libpq-dev \
            # Needed for mariadb
            libmariadbclient-dev \
            sudo \
    && apt-get autoremove \
    && apt-get clean

RUN mkdir /tmp/conquest/ ; \
    cd /tmp/conquest ; \
	wget -q --output-document=/tmp/conquest/dicomserver.zip https://ingenium.home.xs4all.nl/dicomserver/dicomserver150a.zip ; \
	unzip dicomserver.zip ; \
    rm dicomserver.zip ; \
	mv /tmp/conquest /opt/conquest

# Create missing directory prior to make (otherwise we'll get errors)
RUN mkdir /usr/local/man/man1

## Install the jpeg-6c library
#RUN cd /opt/conquest; \
#	cd jpeg-6c; \
#	./configure; \
#	make; \
#	make install;
#
## Install the JasPer image libraries
#RUN cd conquest; \
#	cd jasper-1.900.1-6ct; \
#	./configure; \
#	sudo make; \
#	sudo make install;

# Compile and install the web access
RUN ls -la /opt/conquest/
RUN	chmod 0700 /opt/conquest/maklinux
#RUN	chmod 0700 /opt/conquest/maklinux; echo "5" | /opt/conquest/maklinux # precompiled

WORKDIR /opt/conquest

# Enable CGI scripts on the Apache Server
RUN a2enmod cgi

# Copy across conquest.jpg file
#RUN cp /var/www/conquest.jpg /var/www/html

# Expose port 80 (http) and 5678 (for DICOM query/retrieve/send)
EXPOSE 5678 80

ENV DB_TYPE "dbase"

ADD dicom.ini /opt/conquest/dicom.ini.template
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the apache vhost and index page
ADD env/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
ADD index.html /opt/conquest/webserver/index.html

# Start apache and ConQuest
# The server should then be running and localhost/cgi-bin/dgate should provide a working web interface.
CMD ["/entrypoint.sh"]
