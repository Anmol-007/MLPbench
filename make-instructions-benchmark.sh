#!/bin/bash


for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
	echo " ||||||| Writing Code for `expr $i + 1` mem accesses |||||||"
	echo "
#include<stdio.h>
#include<time.h>
#include<sys/types.h>
#include<sys/times.h>
#include</home/pari/papi/papi-5.5.1/src/papi.h>//<papi.h>
#include<math.h>
#include<stdint.h>
//get rdtsc function
inline unsigned long long int rdtsc_start()
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

inline unsigned long long int rdtsc_end()
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
    long i = 0, j = 0, k = 0, n = 0, n_mem = 0;
    long index[50] = {[ 0 ... 49] = 0};
    long data = 0, final_data = 0;
    srand((unsigned int)time(NULL));
    long long int counters[1], counters_dummy_start[1], counters_dummy_end[1];
    int PAPI_events[] = {PAPI_TOT_INS};

    while(i < num_mem){
	mem[i] = 1;
 	i++;
    }
    i=0;
    n = 10000000;
	" > instructions-code/mem-`expr $i + 1`.c
  	echo "    
    n_mem = $i;
	" >> instructions-code/mem-`expr $i + 1`.c 
	echo "
//    step -= 3 * n_mem;
    while(j < n_mem){
	index[j] = rand() % num_mem;
	j++;
    } 
    j = 0;
    if (PAPI_start_counters(PAPI_events, 1) != PAPI_OK) {
	fprintf(stderr, \"PAPI_start_counters - FAILED\n\");
	return -1;
    }
    while( i < n){
      	k = 0;
	//make 'step' number of computations between first and last memory access and one computation each between 1st to n - 1 mem access
	" >> instructions-code/mem-`expr $i + 1`.c
	j=0
	while [[ $j -lt $i ]]
	do
		echo " data += mem[index[$j]];   " >> instructions-code/mem-`expr $i + 1`.c
		j=`expr $j + 1`
	done
	echo "
	while( ++k < step ){
	;
	}
	data += mem[index[n_mem]];
	i++;
    }
    if (PAPI_read_counters(counters, 1) != PAPI_OK) {
	fprintf(stderr, \"PAPI_read_counters - FAILED\n\");
	return -1;
    }
     printf(\"%lld\n\",counters[0] / n);
}
int main(int argc, char *argv[]){

    if ( argc < 2 || argc > 2 )
        printf(\"Usage program <steps>\n\");
    
    long step = atoi(argv[1]);
    run_test(step);
   
}
	">> instructions-code/mem-`expr $i + 1`.c

	echo "||||||| Compiling Code for `expr $i + 1` mem accesses |||||||"
	gcc -I/usr/local/include -O0  instructions-code/mem-`expr $i + 1`.c /home/pari/papi/papi-5.5.1/src/libpapi.a -o instructions-code/mem-`expr $i + 1`

	echo "||||||| Running code for `expr $i + 1` mem accesses |||||||"
	echo "#Instructions" > results/instr-`expr $i + 1`.dat
	seq 30 | xargs -Iz ./instructions-code/mem-`expr $i + 1` z |& tee -a results/instr-`expr $i + 1`.dat

done
