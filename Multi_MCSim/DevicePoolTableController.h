//
//  DevicePoolTableController.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 19.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicePoolTableController : NSObject <NSTableViewDataSource>

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;

@end
