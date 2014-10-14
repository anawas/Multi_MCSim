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
    
    NSString *completeUrl = [[NSString alloc] initWithFormat:@"%@/update?api_key=%@", _serverUrl, _channelKey ];

    sensors = [_builtinSensors allKeys];
    for (NSString *aKey in sensors) {
        if ([[_builtinSensors valueForKey:aKey] boolValue] == NSOnState) {
            [data appendFormat:@"&field1=%d", rand()];
        }
    }
    NSLog(@"%@", data);
    [broadcastModule sendRequest: completeUrl payLoad:data sender:self];
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
    
    NSString *completeUrl = [[NSString alloc] initWithFormat:@"%@/channels?api_key=%@", _serverUrl, _apiKey ];
    
    NSData *responseData = [broadcastModule sendSynchronousRequest:completeUrl payLoad:data sender:self];
    NSLog(@"Data received = %@", responseData);

    completeUrl = nil;
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            NSLog(@"%@", [results allKeys]);
            
            // there is a lot of info sent back from Platform
            // For now, we're only interested in the channel api key so that
            // we can send data to it.
            id apikeysArray = [results objectForKey:@"api_keys"];
            if ([apikeysArray isKindOfClass:[NSArray class]]) {
                NSLog(@"%@", [[apikeysArray objectAtIndex:0] allKeys]);
                self.channelKey = [[apikeysArray objectAtIndex:0] objectForKey:@"api_key"];
            }
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }

    data = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [httpResponse setLength:0];
}

// Called when data has been received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [httpResponse appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* responseString = [[[NSString alloc] initWithData:httpResponse encoding:NSUTF8StringEncoding] copy];
    
    // Do something with the response

    connection = nil;
    httpResponse = nil;
}

@end
