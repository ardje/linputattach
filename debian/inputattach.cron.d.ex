#
# Regular cron jobs for the inputattach package
#
0 4	* * *	root	[ -x /usr/bin/inputattach_maintenance ] && /usr/bin/inputattach_maintenance
