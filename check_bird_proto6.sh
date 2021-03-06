#!/bin/bash

PROTO=$1
VERIFY_CACHE=/tmp/nagios-bird6-$PROTO

cd $(dirname $0)
./check_bird_proto.pl -p "$PROTO" -s /var/run/bird6.ctl > $VERIFY_CACHE

cat $VERIFY_CACHE
grep '^BIRD_PROTO OK' $VERIFY_CACHE > /dev/null && exit 0
grep '^BIRD_PROTO WARNING' $VERIFY_CACHE > /dev/null && exit 1
grep '^BIRD_PROTO CRITICAL' $VERIFY_CACHE > /dev/null && exit 2
exit 3
