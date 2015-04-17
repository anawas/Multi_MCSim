//
//  AccelerationSensor.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import "AccelerationSensor.h"

@implementation AccelerationSensor

- (id) init {
    self = [super init];
    if (self) {
        _accelx = 0;
        _accely = 0;
        _accelz = 0;
        _acceltemp = 0;
        _acceldetect = 0;
    }
    
    return self;
}


- (void)generateNewData {
    _accelx = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accelx = -_accelx;
    
    _accely = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accelx = -_accely;
    
    _accelz = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accelx = -_accelz;
    
    _acceltemp = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accelx = -_acceltemp;

    _acceldetect = (unsigned char)arc4random_uniform(200);

}

- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
    
    swap_bytes_2((unsigned char *)&_accelx);
    swap_bytes_2((unsigned char *)&_accely);
    swap_bytes_2((unsigned char *)&_accelz);
    swap_bytes_2((unsigned char *)&_acceltemp);

    [stream appendBytes:&_accelx length:2];
    [stream appendBytes:&_accely length:2];
    [stream appendBytes:&_accelz length:2];
    [stream appendBytes:&_acceltemp length:2];
    [stream appendBytes:&_acceldetect length:1];

    return stream;
}

- (NSString *)description {
    return @"Acceleration Sensor";
}
@end
