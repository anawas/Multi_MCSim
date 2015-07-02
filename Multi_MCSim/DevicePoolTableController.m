//
//  DevicePoolTableController.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "DevicePoolTableController.h"
#import "VirtualDevice.h"

@implementation DevicePoolTableController

/*
 * TableDataSourceDelegates
 */

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_devicePool count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *retValue;
    
    VirtualDevice *device = [_devicePool objectAtIndex:row];

    NSString *columnTitle = [[tableColumn headerCell] stringValue];
    
    if ([columnTitle isEqualToString:@"Device"]) {
        if ([device.deviceName length] > 0) {
            retValue = device.deviceName;
        } else {
            retValue = @"NN";
        }
    }

    if ([columnTitle isEqualToString:@"Status"]) {
        if (device.deviceIsRunning) {
            retValue = @"running";
        } else {
            retValue = @"stopped";
        }
    }

    if ([columnTitle isEqualToString:@"Last Update"]) {
        NSMutableString *message = [[NSMutableString alloc] init];
        [message appendString:[device.lastUpdate descriptionWithCalendarFormat:@"%d.%m.%Y %H:%M:%S" timeZone:nil locale:[NSLocale currentLocale]]];
        retValue = (NSString *)message;
    }
    
    if ([columnTitle isEqualToString:@"Return Value"]) {
        retValue = device.returnMessage;
    }
    
    if ([columnTitle isEqualToString:@"Msg ID"]) {
        retValue = [NSString stringWithFormat:@"%ld", device.msgId];

    }

    return retValue;
}

@end
