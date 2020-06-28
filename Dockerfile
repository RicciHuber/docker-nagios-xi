FROM centos:6 

# get stuff from the interwebs
RUN yum -y install wget tar; yum clean all
RUN mkdir /tmp/nagiosxi \
    && wget -qO- https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz \
    | tar xz -C /tmp
WORKDIR /tmp/nagiosxi

# overwrite custom config files
#ADD config.cfg xi-sys.cfg

# start building
RUN touch installed.firewall
RUN ./fullinstall --non-interactive

# set startup script
ADD start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80 5666 5667

CMD ["/start.sh"]
