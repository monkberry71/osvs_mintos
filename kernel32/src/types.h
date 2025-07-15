#pragma once

#define BYTE unsigned char
#define WORD unsigned short
#define DWORD unsigned int
#define QWORD unsigned long
#define BOOL

#define TRUE 1
#define FALSE 0
#define NULL 0

#pragma pack(push, 1)

typedef struct kchar_struct {
    BYTE b_char;
    BYTE b_attr;
} kchar;

#pragma pack(pop)