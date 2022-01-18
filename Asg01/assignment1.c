#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>
#include "assignment1.h"

void reverse_bubble_sort(volatile int * arr, int n)
{
    int i;
    int j;

    for(i = 0; i < n-1; i++)
    {
        for(j = 0; j < n-i-1; j++)
        {
            if(arr[j] > arr[j+1])
            {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}

uint64_t byte_sort(uint64_t arg) {
    volatile int bytes[8];    
    
    bytes[0] = (arg) & 0xff;
    bytes[1] = (arg >> 8) & 0xff;
    bytes[2] = (arg >> 16) & 0xff;
    bytes[3] = (arg >> 24) & 0xff;
    bytes[4] = (arg >> 32) & 0xff;
    bytes[5] = (arg >> 40) & 0xff;
    bytes[6] = (arg >> 48) & 0xff;
    bytes[7] = (arg >> 56) & 0xff;
    
    reverse_bubble_sort(bytes, 8);
    uint64_t value =  (uint64_t)(bytes[0]) | 
    (uint64_t)(bytes[1]) << 8  |          
    (uint64_t)(bytes[2]) << 16 |          
    (uint64_t)(bytes[3]) << 24 |          
    (uint64_t)(bytes[4]) << 32 |          
    (uint64_t)(bytes[5]) << 40 |          
    (uint64_t)(bytes[6]) << 48 |          
    (uint64_t)(bytes[7]) << 56;           

    return value;
}

uint64_t nibble_sort(uint64_t arg) {
    return arg;
}

struct elt* str_to_list(const char* str) {
    return 0;
}

void convert(enum format_t mode, uint64_t value) {

}

void draw_u(void) {

}