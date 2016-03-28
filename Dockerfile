FROM debian:8

#install pgks
RUN apt-get update && \
    apt-get -y install \
    nginx \
    unzip \
    wget \
    libgmp-dev \
    software-properties-common \
    wget \
    supervisor

#add hhvm
RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - &&\
    echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list &&\
    apt-get update && apt-get install -y hhvm

#let nginx stoped
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

#copy files
ADD scripts/ /scripts/
RUN chmod 755 /scripts/*.sh
ADD files/supervisor-hhvm.conf /etc/supervisor/conf.d/
ADD files/hhvm.conf /etc/nginx/
ADD files/php.ini /etc/hhvm/
ADD files/server.ini /etc/hhvm/
ADD files/default etc/nginx/sites-enabled/

#Expose Ports
EXPOSE 80

# Define working directory.
WORKDIR /home/admin/${AMBIENTE}/

# Define default command.
ENTRYPOINT ["/scripts/start.sh"]
