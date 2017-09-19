#include<stdio.h>

int array[1000000];

void robsize(int *p1, int *p2) {
	asm("nop");
	asm("nop");
	asm("nop");
	int data = *p1;
	asm("nop");
	asm("nop");
	asm("nop");
	data = *p2;
	asm("nop");
	asm("nop");
	asm("nop");
}

int main(void) {
	robsize(&array[1], &array[2]);
	return 0;
}
