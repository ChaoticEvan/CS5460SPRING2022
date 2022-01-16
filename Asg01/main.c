#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>
#include "assignment1.h"

int main(void) {
    uint64_t var = byte_sort(0x0403deadbeef0201);
    printf("%" PRIu64 "\n", var);
    return (int) var;
}