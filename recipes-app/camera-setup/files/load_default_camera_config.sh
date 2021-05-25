#!/bin/sh

DAEMON=/usr/bin/load_camera_config
DAEMON_OPTS="ar0144_dual"

start ()
{
	start-stop-daemon -S -o -x $DAEMON -- $DAEMON_OPTS
}

stop ()
{
	start-stop-daemon -K -x $DAEMON
}

restart()
{
	stop
	start
}

[ -e $DAEMON ] || exit 1
case "$1" in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		restart
	;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
	;;
esac
exit $?
