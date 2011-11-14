#!/bin/bash

{
echo "SESSIONS_BGP /etc/check_mk/nagios-bird/gen_mrpe.sh -t" 

for i in $(echo show protocols | birdc  | awk '/Established/{if ($2 == "BGP") print $1}' | grep -v TETANEUTRAL); do
    echo "BGP_$i /etc/check_mk/nagios-bird/check_bird_proto.sh $i"
done

for i in $(echo show protocols | birdc6  | awk '/Established/{if ($2 == "BGP") print $1}' | grep -v TETANEUTRAL); do
    echo "BGP6_$i /etc/check_mk/nagios-bird/check_bird_proto6.sh $i"
done
} > /tmp/tmp_mrpe.cfg

case "$1" in
    -d|--diff)
        diff -uNr <(grep -e ^BGP -e ^SESSIONS_BGP /etc/check_mk/mrpe.cfg) /tmp/tmp_mrpe.cfg 
        exit 0
        ;;
    -t)
        data=$($0 -d | awk '/^+BGP/{printf $3" "}' )
        nb_bgp=$(grep -c 'check_bird_proto' /etc/check_mk/mrpe.cfg)
        if [ "$data" ] ; then
            echo "$nb_bgp actives BGP sessions, New BGP session discover: $data"
            exit 1
        else
            echo "$nb_bgp actives BGP sessions"
            exit 0
        fi
        ;;
    -p)
        cp -f /tmp/tmp_mrpe.cfg /etc/check_mk/mrpe.cfg
        exit 0
        ;;
    -s)
        cat /tmp/tmp_mrpe.cfg
        exit 0
        ;;
esac
echo "Unknown options $1"
exit 3
