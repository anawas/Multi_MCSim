//
//  AppDelegate.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VMCConfigController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) VMCConfigController *virtualMCView;
@property (strong) NSWindow *mcConfigWindow;
@property (strong) NSMutableArray *virtualDevicePool;

- (IBAction)segmentedControlClicked:(id)sender;

@end
