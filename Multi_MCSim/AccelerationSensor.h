//
//  AccelerationSensor.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorProtocol.h"

@interface AccelerationSensor : NSObject <SensorProtocol>
@property short accelx;
@property short accely;
@property short accelz;
@property short acceltemp;
@property unsigned char acceldetect;

@end
