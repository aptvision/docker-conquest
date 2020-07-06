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
            build-essential \
            gettext \
            sudo


RUN mkdir /tmp/conquest; cd /tmp/conquest; \
	wget -q http://ingenium.home.xs4all.nl/dicomserver/dicomserver150a.zip; \
	unzip dicomserver150a.zip; \
	mv /tmp/conquest /opt/conquest

WORKDIR /opt/conquest

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
RUN	chmod 0700 /opt/conquest/maklinux; echo "5" | /opt/conquest/maklinux # precompiled

# Enable CGI scripts on the Apache Server
RUN a2enmod cgi

# Copy across conquest.jpg file
#RUN cp /var/www/conquest.jpg /var/www/html

# Expose port 80 (http) and 5678 (for DICOM query/retrieve/send)
EXPOSE 5678 80

# Regenerate the database
RUN /opt/conquest/dgate -v -r

#Generate the autostart script which will be used to initialise the server
RUN echo "#!/bin/bash" > /startConquest.sh; \
	echo "service apache2 restart" >> /startConquest.sh; \
	echo "/opt/conquest/dgate -v" >> /startConquest.sh; \
	chmod +x /startConquest.sh

ADD index.html /var/www/html/index.html


# Start apache and ConQuest
# The server should then be running and localhost/cgi-bin/dgate should provide a working web interface.
CMD ["/startConquest.sh"]




#FROM ubuntu:20.04
#
#COPY --from=0 /go/src/github.com/alexellis/href-counter/app .
