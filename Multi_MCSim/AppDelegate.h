//
//  AppDelegate.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VirtualMC.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) VirtualMC *virtualMCView;
@property (strong) NSWindow *test;

- (IBAction)segmentedControlClicked:(id)sender;

@end
