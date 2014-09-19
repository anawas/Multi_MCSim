//
//  DevicePoolTableController.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicePoolTableController : NSObject <NSTableViewDataSource>
@property (weak) NSMutableArray *devicePool;

/*
 * TableDataSourceDelegates
 */
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
@end
