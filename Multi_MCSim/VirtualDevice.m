//
//  VirtualDevice.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "VirtualDevice.h"
#import "SensorImports.h"
#import "GCDAsyncUdpSocket.h"

enum {
    LOCATIONSENSOR = 0,
    BATTERYSENSOR,
    ACCELERATIONSENSOR,
    GSMSENSOR
} sensorindex;
    

@implementation VirtualDevice
- (id)initWithDeviceName:(NSString *)devName andNumber:(long)devNumber {
    self = [super init];
    
    if (self) {
        self.deviceName = devName;
        self.deviceNumber = [devName integerValue];
        self.msgId = 0;
        self.status = 1;
        AccelerationSensor *accSens = [[AccelerationSensor alloc] init];
        BatterySensor *battSens = [[BatterySensor alloc] init];
        LocationSensor *locSensor = [[LocationSensor alloc] init];
        GSMSensor *gsmSensor = [[GSMSensor alloc] init];
        
        self.sensorList = [[NSArray alloc] initWithObjects:locSensor, battSens, accSens, gsmSensor, nil];
        
        udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.lastUpdate = [NSDate date];
        
    }
    return self;
}

- (void) dealloc {
    ;
}
- (void)startSocketAtPort:(NSInteger)thePort andUrl:(NSString *)addr {
    NSError *error = nil;
    
    if ([addr length] == 0)
    {
        NSLog(@"Address required");
        return;
    }
    self.serverUrl = addr;

    
    if (thePort <= 0 || thePort > 65535)
    {
        NSLog(@"Valid port required");
        return;
    }
    self.port = thePort;
    
    if (![udpSocket bindToPort:0 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }
    if (![udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
        return;
    }
}


- (void)setUpdateInterval:(NSInteger)updateInterval withMutliplier:(NSInteger)multiplier {
    // we use seconds
    self.updateInterval = updateInterval * multiplier;//updateInterval * multiplier;
}

- (void)startMeasuring {
    //_updateInterval = 1;
    self.deviceTimer = [NSTimer scheduledTimerWithTimeInterval:(double)_updateInterval
                                                        target:self
                                                      selector:@selector(createMeasurement)
                                                      userInfo:nil
                                                       repeats:YES];
}
- (void)createMeasurement {
    _timeCost = 0;
    long temp;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    _msgId++;
    for(int i = 0; i < _sensorList.count; i++) {
        [_sensorList[i] generateNewData];
    }
    
    // must be careful here! Swapping the original variable changes its content!
    // better use a temp value.
    temp = _deviceNumber;
    swap_bytes_4((unsigned char *)&temp);
    
    // The new protocol assume a double 4 byte number, we just double the input
    //[data appendBytes:&_deviceNumber length:4];
    [data appendBytes:&temp length:4];
    [data appendBytes:&temp length:4];
    [data appendBytes:&_status length:1];
    
    temp = _msgId;
    swap_bytes_4((unsigned char *)&temp);
    [data appendBytes:&temp length:4];
    NSData *dummy = [_sensorList[LOCATIONSENSOR] readDataStream];
    [data appendData: dummy];
    
    self.lastUpdate = [NSDate date];
    [data appendData:[self byteStreamFromDate:self.lastUpdate]];

    [data appendData:[_sensorList[BATTERYSENSOR] readDataStream]];
    [data appendData:[_sensorList[ACCELERATIONSENSOR] readDataStream]];

    [data appendBytes:&_status length:1];
    _timeCost = arc4random_uniform(10000) + 20000;
    temp = _timeCost;
    swap_bytes_4((unsigned char *)&temp);
    [data appendBytes:&temp length:4];
    
    [data appendData:[_sensorList[GSMSENSOR] readDataStream]];
    
    [udpSocket sendData:data toHost:self.serverUrl port:self.port withTimeout:-1 tag:_msgId];
    [self createLogEntry];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceUpdatedNotification" object:self];
    data = nil;
}

- (void)createLogEntry {
    NSMutableString *entry = [[NSMutableString alloc] init];
    
    [entry appendString:[NSString stringWithFormat:@"GSM ID     : %@\n", self.deviceName]];
    [entry appendString:[NSString stringWithFormat:@"Message ID : %ld\n", self.msgId]];
    [entry appendString:[NSString stringWithFormat:@"Last Udpate: %@\n", self.lastUpdate]];
    [entry appendString:[NSString stringWithFormat:@"Time Cost  : %ld\n", (long)self.timeCost]];
    [entry appendString:@"---------------------------------------------\n"];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[LOCATIONSENSOR] description]]];
    [entry appendString:[NSString stringWithFormat:@"%@\n",[self.sensorList[LOCATIONSENSOR] describeStatus]]];
    [entry appendString:@"---------------------------------------------\n"];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[BATTERYSENSOR] description]]];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[BATTERYSENSOR] describeStatus]]];
    [entry appendString:@"---------------------------------------------\n"];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[ACCELERATIONSENSOR] description]]];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[ACCELERATIONSENSOR] describeStatus]]];
    [entry appendString:@"---------------------------------------------\n"];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[GSMSENSOR] description]]];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[GSMSENSOR] describeStatus]]];
    [entry appendString:@"=============================================\n"];
    
    NSFileHandle *aFileHandle;
    NSString *aFile;
    
    aFile = @"/Users/andreas/WualaCloud/Development/platformtesting/multimcsim.log"; //setting the file to write to
    aFile = [aFile stringByExpandingTildeInPath];
    
    aFileHandle = [NSFileHandle fileHandleForWritingAtPath:aFile]; //telling aFilehandle what file write to
    [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
    
    [aFileHandle writeData:[entry dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
    [aFileHandle closeFile];
}

- (NSData *)byteStreamFromDate:(NSDate *)theDate {
    NSMutableData *stream = [[NSMutableData alloc] init];
    char y,m,d,H,M,S;
    
    NSCalendarDate *cal = [theDate dateWithCalendarFormat:@"%Y%m%d%H%M%S" timeZone:nil];
    y = [cal yearOfCommonEra] - 2000;
    m = [cal monthOfYear];
    d = [cal dayOfMonth];
    H = [cal hourOfDay];
    M = [cal minuteOfHour];
    S = [cal secondOfMinute];
    
    [stream appendBytes:&y length:1];
    [stream appendBytes:&m length:1];
    [stream appendBytes:&d length:1];
    [stream appendBytes:&H length:1];
    [stream appendBytes:&M length:1];
    [stream appendBytes:&S length:1];
    
    return stream;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"\nDevice name: %@\n", self.deviceName];
    [desc appendFormat:@"  sending to %@\n", self.serverUrl];
    //[desc appendFormat:@"  Virtual sensors: %@\n", self.builtinSensors];
    
    return (NSString *)desc;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

/***** UDPSocket delegate methods *****/

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSLog(@"RECV: %@", msg);
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}


@end
