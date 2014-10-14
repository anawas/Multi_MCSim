//
//  VirtualDevice.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "VirtualDevice.h"

@implementation VirtualDevice
- (id)initWithDeviceName:(NSString *)devName andNumber:(NSInteger)devNumber {
    self = [super init];
    
    if (self) {
        self.deviceName = devName;
        self.deviceNumber = devNumber;
        broadcastModule = [[AsyncPost alloc] init];
    }
    return self;
}

- (void)setUpdateInterval:(NSInteger)updateInterval withMutliplier:(NSInteger)multiplier {
    // we use seconds
    self.updateInterval = updateInterval * multiplier;//updateInterval * multiplier;
}

- (void)startMeasuring {
    self.deviceTimer = [NSTimer scheduledTimerWithTimeInterval:(double)_updateInterval
                                                        target:self
                                                      selector:@selector(createMeasurement)
                                                      userInfo:nil
                                                       repeats:YES];
}
- (void)createMeasurement {
    NSArray *sensors;
    NSMutableString *data = [[NSMutableString alloc] init];
    
    sensors = [_builtinSensors allKeys];
    for (NSString *aKey in sensors) {
        if ([[_builtinSensors valueForKey:aKey] boolValue] == NSOnState) {
            [data appendFormat:@"&field1=%d", rand()];
        }
    }
    NSLog(@"%@", data);
    [broadcastModule sendRequest: _serverUrl payLoad:data sender:self];
    data = nil;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"\nDevice name: %@\n", self.deviceName];
    [desc appendFormat:@"  sending to %@\n", self.serverUrl];
    [desc appendFormat:@"  Virtual sensors: %@\n", self.builtinSensors];
    
    return (NSString *)desc;
}

- (void)registerDeviceWithPlatform {
    NSMutableString *data = [[NSMutableString alloc] init];
    [data appendFormat:@"name=%@", _deviceName];
    
    [broadcastModule sendRequest:@"https://api.thingspeak.com/channels?api_key=NRGMUAYVO2CVS5CT" payLoad: data sender:self];
}
@end
