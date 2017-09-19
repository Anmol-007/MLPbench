#!/bin/bash
echo -e "#SrNo\tN_Data_accesses\t\tMean cycles" > cost_data.dat
echo -e "0\tdummy\t0" >> cost_data.dat 
 
#declare -a lim=( 125 250 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 none)
cycles_one_mem="$(sed -n 2p data-1.dat | cut -d':' -f5)"
       
i=1
for f in `ls -v data*.dat`; do
        #echo "$f"
        cycles="$(sed -n 2p $f | cut -d':' -f5)"
        #echo ${lim[$i]}"="$cpu_speed" unb="$cpu_speed_unb
        diff=$(echo "scale=2 ; $cycles - $cycles_one_mem" | bc)
	diff=$(echo "scale=2 ; $diff / $i" | bc)
        echo $diff
        echo -e $i "\t" $f "\t\t"$diff >> cost_data.dat 
        i=`expr $i + 1`
done
