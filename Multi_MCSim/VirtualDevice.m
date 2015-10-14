

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
    GSMSENSOR,
    GPSSENSOR
} sensorindex;


@implementation VirtualDevice

- (id)initWithDeviceName:(NSString *)devName number:(NSInteger)devNumber andProtocol:(NSInteger)version {
    self = [super init];
    
    if (self) {
        self.deviceName = devName;
        self.deviceNumber = [devName integerValue];
        self.msgId = 0;
        self.status = 1;
        self.protversion = version;
        self.hwstatus = 0x00;
        self.hasGpsSensor = false;
        self.deviceIsDetached = false;
        AccelerationSensor *accSens = [[AccelerationSensor alloc] init];
        BatterySensor *battSens = [[BatterySensor alloc] init];
        
        // we start somewhere near Schweizerhalle
        LocationSensor *locSensor = [[LocationSensor alloc] initWithLongitude: 8.545117
                                                                  andLatitude: 47.367069];


        GSMSensor *gsmSensor = [[GSMSensor alloc] init];
        GPSSensor *gpsSensor = [[GPSSensor alloc] initWithLongitude:8.545117
                                                        andLatitude:47.367069];
        
        self.sensorList = [[NSArray alloc] initWithObjects:locSensor, battSens, accSens, gsmSensor, gpsSensor, nil];
        
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
    
    if (self.protversion == 2) {
        self.status |= 0x80;
        [data appendBytes:&_status length:1];
        [data appendBytes:&_protversion length:1];

        if (self.deviceIsDetached) {
            self.hwstatus |= 0x02;
        } else {
            self.hwstatus = 0x00;
        }

        if (self.hasGpsSensor) {
            // the stream has GPS data
            self.hwstatus |= 0x01;
        }
        
        [data appendBytes:&_hwstatus length:1];
    } else {
        [data appendBytes:&_status length:1];
    }
    
    temp = _msgId;
    swap_bytes_4((unsigned char *)&temp);
    [data appendBytes:&temp length:4];
    
    NSData *dummy = [_sensorList[LOCATIONSENSOR] readDataStream];
    [data appendData: dummy];
    
    self.lastUpdate = [NSDate date];
    [data appendData:[self byteStreamFromDate:self.lastUpdate]];
    
    [data appendData:[_sensorList[BATTERYSENSOR] readDataStream]];
    [data appendData:[_sensorList[ACCELERATIONSENSOR] readDataStream]];
    
    // this mimics the impact detector
    _impactDetector = (unsigned char)arc4random_uniform(100);
    [data appendBytes:&_impactDetector length:1];
    
    _timeCost = arc4random_uniform(10000) + 20000;
    temp = _timeCost;
    swap_bytes_4((unsigned char *)&temp);
    [data appendBytes:&temp length:4];
    
    [data appendData:[_sensorList[GSMSENSOR] readDataStream]];
    
    if (self.hwstatus & 0x01) {
        [data appendData:[_sensorList[GPSSENSOR] readDataStream]];
    }

    [udpSocket sendData:data toHost:self.serverUrl port:self.port withTimeout:-1 tag:_msgId];
    [self createLogEntry];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceUpdatedNotification" object:self];
    data = nil;
}

- (void)switchDetachment {
    if (self.deviceIsDetached) self.deviceIsDetached = NO;
    else self.deviceIsDetached = YES;
    [self.deviceTimer fire];
}

- (void)createLogEntry {
    NSMutableString *entry = [[NSMutableString alloc] init];
    
    [entry appendString:[NSString stringWithFormat:@"GSM ID     : %@\n", self.deviceName]];
    [entry appendString:[NSString stringWithFormat:@"Message ID : %ld\n", self.msgId]];
    [entry appendString:[NSString stringWithFormat:@"Last Udpate: %@\n", self.lastUpdate]];
    [entry appendString:[NSString stringWithFormat:@"Time Cost  : %ld\n", (long)self.timeCost]];
    [entry appendString:[NSString stringWithFormat:@"Impacts    : %d\n", (unsigned char)self.impactDetector]];
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
    [entry appendString:@"---------------------------------------------\n"];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[GPSSENSOR] description]]];
    [entry appendString:[NSString stringWithFormat:@"%@\n", [self.sensorList[GPSSENSOR] describeStatus]]];
    [entry appendString:@"=============================================\n"];
    
    NSFileHandle *aFileHandle;
    NSString *aFile;
    
    aFile = @"/Users/andreas/SecureSafe/Private SecureSafe/Development/platformtesting/multimcsim.log"; //setting the file to write to
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
    [desc appendFormat:@"  sending to %@, port %ld\n", self.serverUrl, (long)self.port];
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
    if (data.length > 0) {
        NSMutableString *message = [[NSMutableString alloc] init];
        
        unsigned char *buffer = calloc(8, sizeof(unsigned char));
        [data getBytes:buffer length:data.length];
        
        for (int i = 0; i < data.length; i++) {
            [message appendString:[NSString stringWithFormat:@"%d", (unsigned char)(buffer[i])]];
            if (i < data.length -1)[message appendString:@","];
        }
        self.returnMessage = message;
        NSLog(@"RECV: %@", _returnMessage);

        free(buffer);
    } else {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        self.returnMessage = @"";
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
    
    /*
     NSString *msg = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
     if (msg)
     {
     }
     else
     {
     NSString *host = nil;
     uint16_t port = 0;
     [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
     
     NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
     }
     */
}


@end
