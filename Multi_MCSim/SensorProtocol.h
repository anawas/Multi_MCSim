//
//  SensorProtocol.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#ifndef Multi_MCSim_SensorProtocol_h
#define Multi_MCSim_SensorProtocol_h

#include "swapbytes.h"

union {
    float fvalue;
    unsigned char bstream[4];
} _u;


@protocol SensorProtocol
- (void)generateNewData;
- (NSData *)readDataStream;
@end

#endif
