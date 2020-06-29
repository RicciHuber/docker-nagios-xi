FROM centos:7

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

# get stuff from the interwebs
RUN yum -y install wget tar; yum clean all
RUN mkdir /tmp/nagiosxi \
    && wget -qO- https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz \
    | tar xz -C /tmp
WORKDIR /tmp/nagiosxi

# start building

# The following will skip the step of modifying the firewall/iptables.
# because there are problems with Centos 6 
RUN touch installed.firewall

RUN ./fullinstall --non-interactive --mysql-password nagiosxi

# set startup script
ADD start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80 5666 5667

CMD ["/start.sh"]
