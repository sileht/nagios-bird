#!/bin/bash

for i in $(echo show protocols | birdc  | awk '/Established/{if ($2 == "BGP") print $1}' | grep -v TETANEUTRAL); do
    echo "BGP_$i /etc/check_mk/nagios-bird/check_bird_proto.sh $i"
done

for i in $(echo show protocols | birdc6  | awk '/Established/{if ($2 == "BGP") print $1}' | grep -v TETANEUTRAL); do
    echo "BGP6_$i /etc/check_mk/nagios-bird/check_bird_proto6.sh $i"
done
