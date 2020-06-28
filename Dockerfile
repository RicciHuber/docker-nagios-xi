FROM centos:7 

# get stuff from the interwebs
RUN yum -y install wget tar; yum clean all
RUN mkdir /tmp/nagiosxi \
    && wget -qO- https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz \
    | tar xz -C /tmp
WORKDIR /tmp/nagiosxi

# overwrite custom config files
ADD config.cfg xi-sys.cfg

# start building
RUN  ./init.sh \
     && log=install.log \
     && source ./xi-sys.cfg \
     && source ./functions.sh \ 
     && run_sub ./0-repos noupdate \
     && run_sub ./1-prereqs \
     && run_sub ./2-usersgroups \
     && run_sub ./3-dbservers \
     && run_sub ./4-services \
     && run_sub ./5-sudoers \
     && run_sub ./9-dbbackups \
     && run_sub ./10-phplimits \
     && run_sub ./11-sourceguardian \
     && run_sub ./12-mrtg \
     && run_sub ./13-timezone \
     && service mysqld start \
     && run_sub ./A-subcomponents \
     && run_sub ./B-installxi \
     && run_sub ./C-cronjobs \
     && run_sub ./D-chkconfigalldaemons \
     && run_sub ./E-importnagiosql \
     && run_sub ./F-startdaemons \
     && run_sub ./Z-webroot

# set startup script
ADD start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80 5666 5667

CMD ["/start.sh"]
