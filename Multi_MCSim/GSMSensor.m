//
//  GSMSensor.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import "GSMSensor.h"


uint32_t carrierId[18] = {
    20201,20205,20209,20210,20404,20408,20412,20416,20420,
    20601,20610,20620,20801,20810,20820,21303,21401,21403};

@implementation GSMSensor

- (id)init {
    self = [super init];
    
    if (self) {
        _carrier = carrierId[0];
        _strength = 0;
    }
    
    return self;
}

- (void)generateNewData {
    int index = (int)arc4random_uniform(18);
    _carrier = carrierId[index];
    _strength = (unsigned char)arc4random_uniform(30);
}

- (NSData *)readDataStream {
    NSMutableData *stream = [[NSMutableData alloc] init];
    
    [stream appendBytes:&_carrier length:2];
    [stream appendBytes:&_strength length:1];
    return (NSData *)stream;
}

@end
