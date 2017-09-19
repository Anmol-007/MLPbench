
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
	

    n_mem = 8;
    n_nops = 210;
	

//    step -= 3 * n_mem;

    range = 33554432 / sizeof(long);
    stride = 4096 / sizeof(long);
    j = 0;	
    /*while( j < n_mem){
	index[j] = j * range;
	j++;
    }*/
    if (PAPI_start_counters(PAPI_events, 2) != PAPI_OK) {
	fprintf(stderr, "PAPI_start_counters - FAILED\n");
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
            // insert 210 number of NOPs between the (N-1)th and Nth mem accesses
/*    if (PAPI_start_counters(PAPI_events, 2) != PAPI_OK) {
	fprintf(stderr, "PAPI_start_counters - FAILED\n");
	return -1;
    }*/
//      i = 0;
//    while ( i < n){
 
	
        data += mem[index[0]];
        data += mem[index[1]];
        data += mem[index[2]];
        data += mem[index[3]];
        data += mem[index[4]];
        data += mem[index[5]];
        data += mem[index[6]];
        data += mem[index[7]];
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 
        asm("nop"); 

	data += mem[index[n_mem]];
/*	i++;
    }
	
    if (PAPI_read_counters(counters, 2) != PAPI_OK) {
	fprintf(stderr, "PAPI_read_counters - FAILED\n");
	return -1;
    }*/
     stop = rdtsc_end();
	    

	    sum += (stop -start);
	    i++;
    }
    if (PAPI_read_counters(counters, 2) != PAPI_OK) {
	fprintf(stderr, "PAPI_read_counters - FAILED\n");
	return -1;
    }

    printf("%ld\t:\t%ld\t:\t%lld\t:\t%lld\t:\t%lld\n", n_mem + 1, n_nops, counters[0]/n, counters[1], (( sum / n ) - 44)  ); 
}
int main(int argc, char *argv[]){

    if ( argc < 2 || argc > 2 )
        printf("Usage program <steps> <n>, where computations = n * num mem\n");
   
    long step = atoi(argv[1]);
    run_test(step);
   
}
	
