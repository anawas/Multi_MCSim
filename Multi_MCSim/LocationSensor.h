//
//  LocationSensor.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 16.04.15.
//  Copyright (c) 2015 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorProtocol.h"

@interface LocationSensor : NSObject <SensorProtocol>
@property float latitude;
@property float longitude;

- (id)init;
- (id)initWithLongitude:(float)longitude andLatitude:(float)latitude;

@end
