#!/bin/bash


#for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	echo "#MEM	NOPs	L2 miss	TLB miss RDTSC cycles" |tee results/data-`expr $i + 1`.dat
	#echo "Steps	Cycles (rdtsc)" >  results/data-`expr $i + 1`.dat
	for nops in 1 10 50 75 100 110 120 130 140 150 160 170 180 182 183 184 186 188 189 190 191 192 193 194 195 196 197 198 199 200 210
	#for nops in 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1   #187 187 187 187 187 187 187 187 187 187
	do

#		echo "||||||||| Writing Code for `expr $i + 1` mem accesses with $nops NOPs |||||||||"
		echo '
#include<stdio.h>
#include<time.h>
#include<sys/types.h>
#include<sys/times.h>
#include</home/anmol/papi-5.5.1/src/papi.h>//<papi.h>
#include<math.h>
#include<stdint.h>
#include<stdlib.h>

static inline unsigned long long int rdtsc_start()
{
	unsigned lo, hi;

	asm volatile (
			"CPUID\n\t" 
			"RDTSC\n\t"
			"mov %%edx, %0\n\t"
			"mov %%eax, %1\n\t": "=r" (hi), "=r" (lo)::
			"%rax", "%rbx", "%rcx", "%rdx");
	uint64_t start = ( ((uint64_t)hi <<32) | lo );
	return start;
}

static inline unsigned long long int rdtsc_end()
{
	unsigned lo, hi;

	asm   volatile(
			"RDTSCP\n\t" 
			"mov %%edx,%0\n\t" 
			"mov %%eax, %1\n\t" 
			"CPUID\n\t": "=r" (hi), "=r" 
			(lo):: "%rax", "%rbx", "%rcx", "%rdx"); 
	uint64_t end = ( ((uint64_t)hi <<32) | lo );
	return end;
}

#define likely(x) __builtin_expect((x),1)
#define unlikely(x) __builtin_expect((x),0)
static long mem[100000000];
long num_mem = sizeof(mem)/sizeof(long); 

int run_test(long step){
    long i = 0, j = 0, k = 0, n = 0, n_mem = 0, n_nops = 0, stride = 0, range = 0;
    long index[50] = {[ 0 ... 49] = 0};
    long data = 0, final_data = 0;
    srand((unsigned int)time(NULL));
    long long int start = 0, stop = 0, sum = 0;

    long long int counters[3];
    int PAPI_events[] = { PAPI_L2_LDM, PAPI_TLB_DM};

    while(i < num_mem){
	mem[i] = 1;
	i++;
    }
    i=0;
    n = 500000;
	' > code/mem-`expr $i + 1`.c

	echo "
    n_mem = $i;
    n_nops = $nops;
	" >> code/mem-`expr $i + 1`.c

	echo "
//    step -= 3 * n_mem;

    range = 33554432 / sizeof(long);
    stride = 4096 / sizeof(long);
    j = 0;	
    /*while( j < n_mem){
	index[j] = j * range;
	j++;
    }*/
    if (PAPI_start_counters(PAPI_events, 2) != PAPI_OK) {
	fprintf(stderr, \"PAPI_start_counters - FAILED\n\");
	return -1;
    }
    while( i < n){
	    k = 0;
	    j = 0;
	    //index[0] = (index[n_mem] + stride) % num_mem;
	    while(j <= n_mem){
		index[j] = rand() % num_mem;
		//index[j] = (index[j-1] + stride) % num_mem;
		j++;
	    } 
	    //j = 0;
	    start = rdtsc_start();
            // insert $nops number of NOPs between the (N-1)th and Nth mem accesses
/*    if (PAPI_start_counters(PAPI_events, 2) != PAPI_OK) {
	fprintf(stderr, \"PAPI_start_counters - FAILED\n\");
	return -1;
    }*/
//      i = 0;
//    while ( i < n){
 
	" >> code/mem-`expr $i + 1`.c
	j=0
	while [[ $j -lt $i ]]
	do
	    	echo "        data += mem[index[$j]];" >> code/mem-`expr $i + 1`.c
	  	j=`expr $j + 1`
	done
	j=0
	while [[ $j -lt $nops ]]
	do
		echo "        asm(\"nop\"); " >> code/mem-`expr $i + 1`.c
		j=`expr $j + 1`
	done							    
	echo "
	data += mem[index[n_mem]];
/*	i++;
    }
	
    if (PAPI_read_counters(counters, 2) != PAPI_OK) {
	fprintf(stderr, \"PAPI_read_counters - FAILED\n\");
	return -1;
    }*/
     stop = rdtsc_end();
	    

	    sum += (stop -start);
	    i++;
    }
    if (PAPI_read_counters(counters, 2) != PAPI_OK) {
	fprintf(stderr, \"PAPI_read_counters - FAILED\n\");
	return -1;
    }

    printf(\"%ld\t:\t%ld\t:\t%lld\t:\t%lld\t:\t%lld\n\", n_mem + 1, n_nops, counters[0]/n, counters[1], (( sum / n ) - 44)  ); 
}
int main(int argc, char *argv[]){

    if ( argc < 2 || argc > 2 )
        printf(\"Usage program <steps> <n>, where computations = n * num mem\n\");
   
    long step = atoi(argv[1]);
    run_test(step);
   
}
	" >> code/mem-`expr $i + 1`.c
#	echo "||||||||| Compiling Code for `expr $i + 1` mem accesses with $nops NOPs |||||||||"
	#gcc -o  code/mem-`expr $i + 1`  code/mem-`expr $i + 1`.c -O0
	gcc -I/usr/local/include -O0  code/mem-`expr $i + 1`.c /home/anmol/papi-5.5.1/src/libpapi.a -o code/mem-`expr $i + 1` -O0
	
#	echo "||||||||| Running Code for `expr $i + 1` mem accesses with $nops NOPs|||||||||"

	./code/mem-`expr $i + 1` 1 |& tee -a results/data-`expr $i + 1`.dat

	done
done

