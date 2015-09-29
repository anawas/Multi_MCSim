 //
//  GPSSensor.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 29.09.15.
//  Copyright © 2015 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorProtocol.h"

@interface GPSSensor : NSObject <SensorProtocol>
@property float latitude;
@property float longitude;
@property int16_t elevation;
@property uint8_t speed;
@property int16_t heading;
@property uint8_t hdop;
@property uint8_t snr;
@property uint8_t numSatellites;

- (id)init;
- (id)initWithLongitude:(float)longitude andLatitude:(float)latitude;

@end
