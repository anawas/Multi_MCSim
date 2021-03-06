//
//  LocationSensor.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import "LocationSensor.h"


@implementation LocationSensor

- (id)init {
    self = [super init];
    
    if (self) {
        self.latitude = 0.0f;
        self.longitude = 0.0f;
    }
    return self;
}

- (id)initWithLongitude:(float)longitude andLatitude:(float)latitude {
    self = [super init];
    
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}


- (float)getRandomValue {
    float value = 0.0;
    
    value = (float)arc4random()/(float)RAND_MAX/2.0;
    
    if (((float)arc4random()/(float)(2.0 * RAND_MAX)) >= 0.5) value *= -1.0;
    return value;
}

- (void)generateNewData {
    /*
    _latitude = ((float)arc4random()/(float)RAND_MAX/2.0) * 180.0 - 90.0;
    _longitude = ((float)arc4random()/(float)RAND_MAX/2.0) * 360.0 - 180.0;
    
    _longitude -= 0.01;
    _latitude += 0.01;
     */

    _longitude += [self getRandomValue] * 0.01;
    _latitude += [self getRandomValue] * 0.01;

    NSLog(@"Location Sensor -- %@", [self describeStatus]);
}


- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
        
    // -U is a union defined in SensorProtocol
    _u.fvalue = self.longitude;
    
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];

    _u.fvalue = self.latitude;
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];
    return stream;
}

- (NSString *)describeStatus {
    NSMutableString *status = [[NSMutableString alloc] init];
    
    [status appendString:[NSString stringWithFormat:@"LatLon  : %f, %f\n", self.latitude, self.longitude]];
    return (NSString *)status;
}


- (NSString *)description {
    return @"Location Sensor";
}


@end
