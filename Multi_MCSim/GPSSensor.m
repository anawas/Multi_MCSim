//
//  GPSSensor.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 29.09.15.
//  Copyright © 2015 Phandroo. All rights reserved.
//

#import "GPSSensor.h"

@implementation GPSSensor

- (id)init {
    self = [super init];
    
    if (self) {
        self.latitude = 0.0f;
        self.longitude = 0.0f;
        self.elevation = 0;
        self.speed = 0;
        self.heading = 0;
        self.hdop = 0;
        self.snr = 0;
        self.numSatellites = 0;

    }
    return self;
}

- (id)initWithLongitude:(float)longitude andLatitude:(float)latitude {
    self = [super init];
    
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.elevation = 0;
        self.speed = 0;
        self.heading = 0;
        self.hdop = 0;
        self.snr = 0;
        self.numSatellites = 0;
    }
    return self;
}

/*
 * Implementation of SensorProtocol
 */
- (void)generateNewData {

    /*
    _longitude -= 0.01;
    _latitude += 0.01;
     */
    
    _latitude = ((float)arc4random()/(float)RAND_MAX/2.0) * 180.0 - 90.0;
    _longitude = ((float)arc4random()/(float)RAND_MAX/2.0) * 360.0 - 180.0;
    _elevation = (int16_t)arc4random()/(RAND_MAX/2.0) * 8848;
    _speed = (uint8_t)arc4random()/(RAND_MAX/2.0) * 100;
    _heading = (uint8_t)arc4random()/(RAND_MAX/2.0) * 360;
    _hdop = 0;
    _snr = (uint8_t)arc4random()/(RAND_MAX/2.0) * 100;
    _numSatellites = (uint8_t)arc4random()/(RAND_MAX/2.0) * 10 + 1;

    NSLog(@"Location Sensor -- %@", [self describeStatus]);
}

- (NSData *)readDataStream {
    short temp = 0;
    NSMutableData *stream = [[NSMutableData alloc] init];
    
    // -U is a union defined in SensorProtocol
    _u.fvalue = self.longitude;
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];
    
    _u.fvalue = self.latitude;
    swap_bytes_4(_u.bstream);
    [stream appendBytes:_u.bstream length:4];
    
    temp = _elevation;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];
    
    [stream appendBytes:&_speed length:1];

    temp = _heading;
    swap_bytes_2((unsigned char *)&temp);
    [stream appendBytes:&temp length:2];
    
    [stream appendBytes:&_hdop length:1];
    [stream appendBytes:&_snr length:1];
    [stream appendBytes:&_numSatellites length:1];

    return stream;
}

- (NSString *)describeStatus {
    NSMutableString *status = [[NSMutableString alloc] init];
    
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Latitude  : %f\n", self.latitude]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Longitude : %f\n", self.longitude]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Elevation : %d\n", self.elevation]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Speed     : %d\n", self.speed]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Heading   : %d\n", self.heading]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor HDOP      : %d\n", self.hdop]];
    [status appendString:[NSString stringWithFormat:@"GPS-Sensor Satellites: %d\n", self.numSatellites]];
    return (NSString *)status;
}



- (NSString *)description {
    return @"GPS Sensor";
}

@end
