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
                                                      selector:@selector(createMeasuremnt)
                                                      userInfo:nil
                                                       repeats:YES];
}
- (void)createMeasuremnt {
    NSArray *sensors;
    NSMutableString *data = [[NSMutableString alloc] init];
    
    [data appendFormat:@"\nDevice %@ is measuring and transmitting\n", _deviceName ];
    sensors = [_builtinSensors allKeys];
    for (NSString *aKey in sensors) {
        if ([[_builtinSensors valueForKey:aKey] boolValue] == NSOnState) {
            [data appendFormat:@"  ... %@ = %d\n", aKey, 123];
        }
    }
    NSLog(@"%@", data);
    data = nil;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"\nDevice name: %@\n", self.deviceName];
    [desc appendFormat:@"  sending to %@\n", self.serverUrl];
    [desc appendFormat:@"  Virtual sensors: %@\n", self.builtinSensors];
    
    return (NSString *)desc;
}
@end
