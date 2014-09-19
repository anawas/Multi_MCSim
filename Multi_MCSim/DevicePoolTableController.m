//
//  DevicePoolTableController.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "DevicePoolTableController.h"

@implementation DevicePoolTableController

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 100;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [NSNumber numberWithInt:(int)row];
}

@end
