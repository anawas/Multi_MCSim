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
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accely= -_accely;
    
    _accelz = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _accelz = -_accelz;
    
    _acceltemp = (short)arc4random_uniform(1000);
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) _acceltemp = -_acceltemp;

    _acceldetect = (unsigned char)arc4random_uniform(200);

}

- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
    short temp = 0;
    
    temp = _accelx;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];

    temp = _accely;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];

    temp = _accelz;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];
    
    temp = _acceltemp;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];

    [stream appendBytes:&_acceldetect length:1];

    return stream;
}

- (NSString *)describeStatus {
    NSMutableString *status = [[NSMutableString alloc] init];
    
    [status appendString:[NSString stringWithFormat:@"Acceleration x     : %d\n", self.accelx]];
    [status appendString:[NSString stringWithFormat:@"Acceleration y     : %d\n", self.accely]];
    [status appendString:[NSString stringWithFormat:@"Acceleration z     : %d\n", self.accelz]];
    [status appendString:[NSString stringWithFormat:@"Acceleration Temp  : %d\n", self.acceltemp]];
    [status appendString:[NSString stringWithFormat:@"Acceleration Detect: %d\n", self.acceldetect]];
    return (NSString *)status;
}


- (NSString *)description {
    return @"Acceleration Sensor";
}
@end
