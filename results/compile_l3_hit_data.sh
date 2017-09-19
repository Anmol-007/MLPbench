#!/bin/bash
echo -e "#SrNo\tN_Data_accesses\t\tMean cycles" > l3_hit_data.dat
echo -e "0\tdummy\t1" >> l3_hit_data.dat 
 
#declare -a lim=( 125 250 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 none)
i=1
for f in `ls -v data*.dat`; do
        #echo "$f"
        cycles="$(awk '{ total += $5 } END { printf("%.f\n", total/(NR - 1)) }' $f)"
        #echo ${lim[$i]}"="$cpu_speed" unb="$cpu_speed_unb
        #cpu_speed=$(echo "scale=2 ; $cpu_speed / $cpu_speed_unb" | bc)
        echo $cycles
        echo -e $i "\t" $f "\t\t"$cycles >> l3_hit_data.dat 
        i=`expr $i + 1`
done
