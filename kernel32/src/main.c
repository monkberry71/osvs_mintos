#include "types.h"

void k_print_string(int iX, int iY, const char* pc_string);

void main(void) {
    k_print_string(0, 4, "C Lang Kernel Starting...But maybe a powercut");

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