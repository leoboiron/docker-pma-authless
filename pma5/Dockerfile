FROM phpmyadmin:5-apache

RUN apt update \
    && apt install -y sshpass net-tools \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /keys
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
