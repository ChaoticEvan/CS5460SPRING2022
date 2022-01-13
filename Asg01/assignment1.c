#define _GNU_SOURCE

#include "assignment1.h"
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>

int main (void) {
    byte_sort(0x0403deadbeef0201);
    return 0;
}


uint64_t byte_sort(uint64_t arg) {
    uint8_t firstByte = (arg) & 0xff;
    uint8_t secondByte = (arg >> 8) & 0xff;
    uint8_t thirdByte = (arg >> 16) & 0xff;
    uint8_t fourthByte = (arg >> 24) & 0xff;
    uint8_t fifthByte = (arg >> 32) & 0xff;
    uint8_t sixthByte = (arg >> 40) & 0xff;
    uint8_t seventhByte = (arg >> 48) & 0xff;
    uint8_t eighthByte = (arg >> 56) & 0xff;


    return firstByte + secondByte + thirdByte + fourthByte + fifthByte + sixthByte + seventhByte + eighthByte;
}

uint64_t nibble_sort(uint64_t arg) {
    return 0;
}

void convert(enum format_t mode, uint64_t value) {

}

void draw_u(void) {

}