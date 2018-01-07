//
//  sys_queue.h
//  BleDemo
//
//  Created by sheldon on 13/10/9.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#ifndef BleDemo_sys_queue_h
#define BleDemo_sys_queue_h


#endif

#include <stdio.h>

#define MAX_QUEUE_LENGTH 2048

#ifndef FALSE
    #define FALSE 0
#endif

#ifndef TRUE
    #define TRUE 1
#endif

typedef unsigned char BYTE;

int queue_len(void);
void queue_add(BYTE data);
void queue_add_data(BYTE *data, int size);
int queue_peek(BYTE *data, int len);
BYTE queue_get();
short queue_get_short();
int queue_get_int();