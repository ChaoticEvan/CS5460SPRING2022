#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdlib.h>
#include <sys/syscall.h> 
#include <unistd.h>
#include "assignment1.h"

int main(void) {
    uint64_t byteSort = byte_sort(0x0403deadbeef0201);
    assert(byteSort == (uint64_t) 0xefdebead04030201);
    uint64_t nibbleSort = nibble_sort(0x0403deadbeef0201);
    assert(nibbleSort == (uint64_t)0xfeeeddba43210000);

    char strTest[5] = {'h', 'e', 'l', 'p', '\0'};
    struct elt* strToList = str_to_list(strTest);
    assert(strToList->val == 'h');
    assert(strToList->link->val == 'e');
    assert(strToList->link->link->val == 'l');
    assert(strToList->link->link->link->val == 'p');
    assert(strToList->link->link->link->link == NULL);
    free(strToList->link->link->link);
    free(strToList->link->link);
    free(strToList->link);
    free(strToList);

    return 0;
}