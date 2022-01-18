#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>
#include "assignment1.h"

void bubble_sort(int * arr, int n)
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
    int bytes[8];    
    int i;
    for(i = 0; i < 8; ++i)
    {
        bytes[i] = (arg >> i*8) & 0xff; 
    }
    
    bubble_sort(bytes, 8);
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
    int nums[16];
    int i;

    for(i = 0; i < 16; ++i)
    {
        nums[i] = (arg >> i*4) & 0xf;
    }

    bubble_sort(nums, 16);

    uint64_t value = (uint64_t)(nums[0]) |
        (uint64_t)(nums[1]) << 4 |
        (uint64_t)(nums[2]) << 8 |
        (uint64_t)(nums[3]) << 12 |
        (uint64_t)(nums[4]) << 16 |
        (uint64_t)(nums[5]) << 20 |
        (uint64_t)(nums[6]) << 24 |
        (uint64_t)(nums[7]) << 28 |
        (uint64_t)(nums[8]) << 32 |
        (uint64_t)(nums[9]) << 36 |
        (uint64_t)(nums[10]) << 40 |
        (uint64_t)(nums[11]) << 44 |
        (uint64_t)(nums[12]) << 48 |
        (uint64_t)(nums[13]) << 52 |
        (uint64_t)(nums[14]) << 56 |
        (uint64_t)(nums[15]) << 60;

    return value;
}

struct elt* str_to_list(const char* str) {
    return 0;
}

void convert(enum format_t mode, uint64_t value) {

}

void draw_u(void) {

}