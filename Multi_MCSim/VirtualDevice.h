//
//  VirtualDevice.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncPost.h"

enum sensorType {
    SENSOR_TEMPERATURE = 1,
    SENSOR_HUMIDITY = (1 << 1),
    SENSOR_LEVEL = (1 << 2),
    SENSOR_STATUS = (1 << 3),
    SENSOR_GEOLOCATION = (1 << 4),
    SENSOR_MESSAGE = (1 << 5)
};

enum intervalMultiplier {
    MULTIPLIER_SECONDS = 1,
    MULTIPLIER_MINUTES = 60,
    MULTIPLIER_HOURS = 3600
};


@interface VirtualDevice : NSObject <NSURLConnectionDelegate> {
    AsyncPost *broadcastModule;
    NSMutableData *httpResponse;
}

@property (strong) NSString *deviceName;
@property NSInteger updateInterval;
@property NSInteger deviceNumber;
@property BOOL deviceIsRunning;
@property (strong) NSDictionary *builtinSensors;
@property (strong) NSString *serverUrl;
@property (strong) NSString *port;
@property (strong) NSString *apiKey;
@property (strong) NSString *channelKey;
@property (weak) NSTimer *deviceTimer;


- (id)initWithDeviceName:(NSString *)devName andNumber:(NSInteger)devNumber;
- (void)setUpdateInterval:(NSInteger)updateInterval withMutliplier:(NSInteger)multiplier;
- (void)startMeasuring;
- (void)createMeasurement;
- (void)registerDeviceWithPlatform;
- (NSString *)description;

// AsyncPost delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
