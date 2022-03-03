!/bin/bash

fail2banopenvpnfilter=/etc/fail2ban/filter.d/openvpn.local
if [ ! -f "$fail2banopenvpnfilter" ]; then
cat <<EOF >> $fail2banopenvpnfilter
[Definition]
failregex =  TLS Error: incoming packet authentication failed from \[AF_INET\]<HOST>:\d+$
             <HOST>:\d+ Connection reset, restarting
             <HOST>:\d+ TLS Auth Error
             <HOST>:\d+ TLS Error: TLS handshake failed$
             <HOST>:\d+ VERIFY ERROR

ignoreregex =
EOF
fi

fail2banopenvpnjail=/etc/fail2ban/jail.d/openvpn.conf
if [ ! -f "$fail2banopenvpnjail" ]; then
cat <<EOF >> $fail2banopenvpnjail
[openvpn]
enabled  = $FAIL2BAN_ENABLED
filter   = openvpn
action = mikrotik
logpath  = $LOG_FILE
maxretry = $FAIL2BAN_MAXRETRIES
EOF
fi

fail2banopenvpnactionmktik=/etc/fail2ban/action.d/mikrotik.conf
if [ ! -f "$fail2banopenvpnactionmktik" ]; then
cat <<EOF >> $fail2banopenvpnactionmktik
[Definition]
actionstart =
actionstop =
actioncheck =
actionban = mikrotik ":ip firewall address-list add list=fail2ban address=<ip>"
actionunban =
EOF
fi

fail2bandefinition=/etc/fail2ban/fail2ban.local
if [ ! -f "$fail2bandefinition" ]; then
cat <<EOF >> $fail2bandefinition
[Definition]
logtarget = /proc/1/fd/1
EOF
fi

echo "Starting fail2ban..."
touch /var/log/auth.log

fail2banvarrun=/var/run/fail2ban
if [ ! -d "$fail2banvarrun" ]; then mkdir $fail2banvarrun; fi

/usr/bin/fail2ban-server -xb --logtarget=stdout start
