//
//  byteswap.c
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#include "swapbytes.h"

void swap_bytes_2(unsigned char *buffer) {
    unsigned char temp;
    
    temp = buffer[0];
    buffer[0] = buffer[1];
    buffer[1] = temp;
}

void swap_bytes_4(unsigned char *buffer) {
    unsigned char temp;
    
    temp = buffer[0];
    buffer[0] = buffer[3];
    buffer[3] = temp;
    
    temp = buffer[1];
    buffer[1] = buffer[2];
    buffer[2] = temp;
};

void swap_bytes_8(unsigned char *buffer) {
    unsigned char temp;
    
    temp = buffer[0];
    buffer[0] = buffer[3];
    buffer[3] = temp;
    
    temp = buffer[1];
    buffer[1] = buffer[2];
    buffer[2] = temp;
};
