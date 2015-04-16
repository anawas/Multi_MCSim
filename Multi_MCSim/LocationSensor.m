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
    
    if (((float)arc4random()/(float)RAND_MAX) >= 0.5) value *= -1.0;
    return value;
}

- (void)generateNewData {
    
    _longitude += [self getRandomValue];
    _latitude += [self getRandomValue];
}


- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
        
    // -U is a union defined in SensorProtocol
    _u.fvalue = self.longitude;
    [stream appendBytes:_u.bstream length:4];
    
    _u.fvalue = self.latitude;
    [stream appendBytes:_u.bstream length:4];
    return stream;
}

@end
