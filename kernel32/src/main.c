#include "types.h"

void k_print_string(int iX, int iY, const char* pc_string);
BOOL k_initialize_kernel64_area(void);
BOOL k_enough_memory(void);

void main(void) {
    DWORD i;
    k_print_string(0, 4, "C Lang Kernel Starting...But maybe a powercut");
    k_print_string(0, 5, "Minimum memory size check...");
    if (!k_enough_memory()) {
        k_print_string(0, 6, "Not enough memory.");
        for(;;);
    } else {
        k_print_string(0, 5, "Minimum memory size check...Good");
    }

    if(!k_initialize_kernel64_area()) {
        k_print_string(0,6, "IA-32e Kernel Area init failed.");
        for(;;);
    }
    k_print_string(0,6, "IA-32e Kernel Area init complete.");
    for(;;);
}

void k_print_string(int iX, int iY, const char* pc_string) {
    kchar* pst_screen = (void*) 0xB8000;
    int i;

    pst_screen += (iY * 80) + iX;
    for(i=0; pc_string[i]; i++) {
        pst_screen[i].b_char = pc_string[i];
    }
}

BOOL k_initialize_kernel64_area(void) {
    DWORD* cur_addr;

    cur_addr = (void*) 0x100000;

    while( (DWORD) cur_addr < 0x600000) {
        *cur_addr = 0;
        if(*cur_addr != 0) return FALSE;

        cur_addr++;
    }

    return TRUE;
}

BOOL k_enough_memory(void) {
    DWORD* cur_addr;

    cur_addr= (void*) 0x100000;

    while( (DWORD) cur_addr < 0x4000000) {
        *cur_addr = 0x12345678;

        if (*cur_addr != 0x12345678) return FALSE;
        cur_addr += (0x100000/4);
    }
    return TRUE;
}