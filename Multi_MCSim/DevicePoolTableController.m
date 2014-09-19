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
    VirtualDevice *device = [_devicePool objectAtIndex:row];
    if ([device.deviceName length] > 0)
        return device.deviceName;
    else
        return @"NN";
}

@end
