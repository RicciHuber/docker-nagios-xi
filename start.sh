#!/bin/bash
/usr/sbin/init

# starting services

/sbin/service mariadb start
/sbin/service httpd start
/sbin/service crond start
/sbin/service firewalld start
/sbin/service nagios start

# welcome everyone

cat <<-EOF

	Welcome to Nagios XI

	You can access the Nagios XI web interface by visiting:
	    http://your_ip/nagiosxi/

EOF

tail -F /usr/local/nagios/var/nagios.log

