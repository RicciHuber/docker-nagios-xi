FROM centos:7 

# get stuff from the interwebs
RUN yum -y install wget tar; yum clean all
RUN mkdir /tmp/nagiosxi \
    && wget -qO- https://assets.nagios.com/downloads/nagiosxi/5/xi-5.6.14.tar.gz \
    | tar xz -C /tmp
WORKDIR /tmp/nagiosxi

# overwrite custom config files
ADD config.cfg xi-sys.cfg

# start building
RUN fullinstall

# set startup script
ADD start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80 5666 5667

CMD ["/start.sh"]
