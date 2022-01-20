#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>
#include "assignment1.h"

// Helper method for sorting arrays
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

    // Build resulting value
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

    // Build resulting value
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

    // Manually get the size of char array
    //
    // Not using strlen as assignment specifies.
    // Need the length so we can build the linked list backwards
    char currChar = str[0];
    int size = 1;
    while (currChar != '\0')
    {
        currChar = str[size];        
        ++size;        
    }
    
    // Decrement size counter for ending character
    --size;

    int i;
    struct elt* next = NULL;
    struct elt* curr;
    for(i = size - 1; i >= 0; --i)
    {
        curr = malloc(sizeof(struct elt));
        
        // If malloc fails, it will return NULL, so
        // free memory and return NULL as assignment specification states
        if (curr == NULL)
        {
            free(curr);
            free(next);
            return NULL;
        }
        curr->val = str[i];
        curr->link = next;
        next = curr;
    }    
    return curr;
}

char * convert_hex(uint64_t value)
{
    int arr[16];
    uint64_t currValue = value;
    int i;    
    for(i = 0; i < 16; ++i)
    {
        int remainder = currValue % 16;
        currValue = currValue / 16;
        arr[i] = remainder;
        if(currValue == 0)
        {
            break;
        }
    }
    ++i;
    for(; i < 16; ++i)
    {
        arr[i] = 0;        
    }
    char *result = malloc(16 * sizeof(char));
    for(i = 0; i < 16; ++i)
    {
        switch(arr[i])
        {
            case 0:
                result[i] = '0';
                break;
            case 1:
                result[i] = '1';
                break;
            case 2:
                result[i] = '2';
                break;
            case 3:
                result[i] = '3';
                break;
            case 4:
                result[i] = '4';
                break;
            case 5:
                result[i] = '5';
                break;
            case 6:
                result[i] = '6';
                break;
            case 7:
                result[i] = '7';
                break;
            case 8:
                result[i] = '8';
                break;
            case 9:
                result[i] = '9';
                break;
            case 10:
                result[i] = 'a';
                break;
            case 11:
                result[i] = 'b';
                break;
            case 12:
                result[i] = 'c';
                break;
            case 13:
                result[i] = 'd';
                break;
            case 14:
                result[i] = 'e';
                break;
            case 15:
                result[i] = 'f';
                break;
        }
    }
    return result;
}

void convert(enum format_t mode, uint64_t value) {

    // The switch statement below gave me strage syntax erros on the HEX case.
    // Swapped to if statements to avoid those.
    //
    // switch(mode)
    // {
    //     case HEX:
    //         char *testName = convert_hex(value);
    //         int i;
    //         for(i = 0; i < 16; ++i)
    //         {
    //             putc(testName[i], stdout);
    //         }
    //         return;
    //     case OCT:
    //         printf("oct");
    //         return;
    //     case BIN:
    //         printf("bin");
    //         return;
    //     default:
    //         return;
    // }


    if(mode == HEX) {
        char *hexNum = convert_hex(value);
        int i = 15;
        for(; i >= 0; --i)
        {
            putc(hexNum[i], stdout);
        }
        free(hexNum);
    }
    putc('\n', stdout);
}

void draw_u(void) {

}