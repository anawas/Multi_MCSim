//
//  BatterySensor.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import "BatterySensor.h"
#include "swapbytes.h"


@implementation BatterySensor

- (id)init {
    self = [super init];
    if (self) {
        _voltage = 5.0f;
        _charge = 100.0f;
    }
    return self;
}

- (void)generateNewData {
    if (_voltage <= 2.0) _voltage = 5.0f;
    _voltage -= 0.0083;
    _charge = _voltage/5.0 * 100.0;
}

- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
    
    // _u is a union defined in SensorProtocol
    _u.fvalue = self.voltage;
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];
    
    _u.fvalue = self.charge;
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];
    return (NSData *)stream;
}

- (NSString *)describeStatus {
    NSMutableString *status = [[NSMutableString alloc] init];
    [status appendString:[NSString stringWithFormat:@"Voltage: %f\n", self.voltage]];
    [status appendString:[NSString stringWithFormat:@"Charge : %f %%\n", self.charge]];
    return (NSString *)status;
}


- (NSString *)description {
    return @"Battery Sensor";
}


@end
