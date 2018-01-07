//
//  sys_queue.c
//  BleDemo
//
//  Created by sheldon on 13/10/9.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include "sys_queue.h"


BYTE g_queue_buf[MAX_QUEUE_LENGTH+1];
short g_front=0;
short g_rear=0;
BYTE g_checksum;

int queue_len(void)
{
    short diff = g_rear - g_front;
    if(diff >=0)
        return diff;
    else return (MAX_QUEUE_LENGTH + diff);
}


void queue_add(BYTE data)
{
    //egislog_sys("UART_queue_add:idx=%d, data=%x\r\n", g_rear, data);
	if (MAX_QUEUE_LENGTH-queue_len() < 2) //out of space
	{
        //egislog_sys("out of space UART_Parser()\r\n");
		//yukey_parser();
	}
    g_queue_buf[g_rear] = data;
    g_rear++;
    if (g_rear==MAX_QUEUE_LENGTH)
	{
		//egislog_sys("assign g_rear zero\r\n");
		g_rear = 0;
	}
}

void queue_add_data(BYTE *data, int size)
{
    int i;
    for(i=0;i<size;i++)
        queue_add(data[i]);
}

int queue_peek(BYTE *data, int len)
{
	int save_front = g_front, pos=0;
	if (queue_len()<len) return FALSE;
	while (queue_len()>0)
	{
		if (queue_get()==data[pos])
		{
			pos++;
			if (pos == len) return TRUE;
		} else
			pos = 0;
	}
	g_front = save_front; //restore queue data
	return FALSE;
}

BYTE queue_get()
{
    if (queue_len()>0)
    {
        BYTE ret = g_queue_buf[g_front] ;
		//egislog_sys("UART_queue_get:idx=%d ret=%x\r\n", g_front, ret);
        g_front++;
        if (g_front==MAX_QUEUE_LENGTH)
            g_front = 0;
        
		//egislog_sys("UART_queue_get:next idx=%d\r\n", g_front);
		g_checksum ^= ret;
        return ret;
    } else
        return 0xFF;
}
short queue_get_short()
{
	short ret = queue_get();
	return ret += (queue_get() << 8);
}

int queue_get_int()
{
    int a=0;
    for (int i = 0 ; i < 4; i++) {
        a += (queue_get() & 0xFF) << (8*i);
    }
    return a;
}
