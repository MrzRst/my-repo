FROM ubuntu
LABEL Maintainer="Mrz.Rst"\
      Description="ubuntu container with wordpress and php and php-fpm7.2 and mysql and apache"
#ENV LYBERTEAM_TIME_ZONE Europe/Kiev
#RUN echo $LYBERTEAM_TIME_ZONE > /etc/timezone


RUN apt update -y \
	&& apt install apache2 -y \
	&& apt install mysql-server -y \
	&& apt install php-mysql -y \ 
#Install PHP
# ***ibapache2-mod-php php-mysql ==> requieed timezone
#Install Additional PHP extensions for WordPress 
	&& apt install php-curl php-gd php-xml php-mbstring php-xmlrpc php-zip php-soap php-intl -y 



RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php





## Install php7.2 extension
RUN apt-get update -y \
    && apt-get install -y \
    php7.2-pgsql \
	php7.2-mysql \ 
	php7.2-opcache \
	php7.2-common \
	php7.2-mbstring\
	php7.2-soap \
#	php7.2-cli \
	php7.2-intl \
	php7.2-json \ 
	php7.2-xsl \
	php7.2-imap \
	php7.2-ldap \
	php7.2-curl \

	php7.2-gd \
#	php7.2-dev 
#       php7.2-fpm 
        php7.2-bcmath 




# Copy our config files for php7.2 fpm and php7.2 cli
COPY php-conf/php.ini /etc/php/7.2/cli/php.ini
COPY php-conf/php-fpm.ini /etc/php/7.2/fpm/php.ini
COPY php-conf/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
COPY php-conf/www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY php-conf/info.php /var/www/html/info.php

COPY apache-conf/apache2.conf /etc/apache2/apache2.conf
COPY apache-conf/sites-available/ /etc/apache2/sites-available/
COPY apache-conf/sites-enabled/ /etc/apache2/sites-enabled/
COPY apache-conf/ports.conf /etc/apache2/ports.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

WORKDIR /var/www/html/

EXPOSE 8056
CMD ["apachectl", "-D", "FOREGROUND"]
