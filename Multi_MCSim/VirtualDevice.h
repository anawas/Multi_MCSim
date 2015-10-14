//
//  VirtualDevice.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>

enum intervalMultiplier {
    MULTIPLIER_SECONDS = 1,
    MULTIPLIER_MINUTES = 60,
    MULTIPLIER_HOURS = 3600
};

@class GCDAsyncUdpSocket;

@interface VirtualDevice : NSObject {
    GCDAsyncUdpSocket *udpSocket;
}

@property (strong) NSString *deviceName;
@property (strong) NSArray *sensorList;
@property NSInteger updateInterval;
@property long deviceNumber;
@property NSInteger msgId;
@property short status;
@property short protversion;
@property short hwstatus;
@property BOOL hasGpsSensor;
@property BOOL deviceIsRunning;
@property BOOL deviceIsDetached;
@property unsigned char impactDetector;
@property NSInteger timeCost;
@property NSDate *lastUpdate;
//@property (strong) NSDictionary *builtinSensors;
@property (strong) NSString *serverUrl;
@property NSInteger port;
@property (weak) NSTimer *deviceTimer;
@property NSString *returnMessage;

- (id)initWithDeviceName:(NSString *)devName number:(NSInteger)devNumber andProtocol:(NSInteger)version;

- (void)startSocketAtPort:(NSInteger)thePort andUrl:(NSString *)addr;
- (void)setUpdateInterval:(NSInteger)updateInterval withMutliplier:(NSInteger)multiplier;
- (void)startMeasuring;
- (void)createMeasurement;
- (void)switchDetachment;
- (NSString *)description;

@end
