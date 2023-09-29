FROM ubuntu:22.04 as base

RUN apt update -y && \
apt upgrade -y && \
apt-get install -y tzdata && \
apt -y install software-properties-common && \
apt -y install apache2 libapache2-mod-fcgid composer && \
a2enmod rewrite actions fcgid alias proxy_fcgi && \
add-apt-repository ppa:ondrej/php && \
apt-get update && \
apt install -y php7.4 php7.4-cli php7.4-fpm php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring \
php7.4-curl php7.4-xml php-pear php7.4-bcmath openssh-server 

RUN apt-get install -y locales

RUN sed -i -e 's/# es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL es_MX.UTF-8
ENV LANG es_MX.UTF-8
ENV LANGUAGE es_MX:es


RUN apt-get install tzdata -y
ENV TZ="America/Mexico_City"

# Copiar config para el apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 educ 
RUN  echo 'educ:3duc' | chpasswd
RUN usermod -aG sudo educ

# Exponer puertos para Web SSL y SSH
EXPOSE 80 433 22
# CMD ["/usr/sbin/sshd","-D"]

# Iniciar ssh, apache2 y php-fpm
ENTRYPOINT service apache2 start && service php7.4-fpm start  && service ssh start && bash