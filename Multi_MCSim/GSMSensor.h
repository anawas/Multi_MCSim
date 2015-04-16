//
//  GSMSensor.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorProtocol.h"


@interface GSMSensor : NSObject <SensorProtocol>

@property uint32_t carrier;
@property unsigned char strength;


@end
