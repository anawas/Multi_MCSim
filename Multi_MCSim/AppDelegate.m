//
//  AppDelegate.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "AppDelegate.h"
#import "VirtualDevice.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.virtualMCView = [[VMCConfigController alloc] initWithNibName:@"VMCConfigController" bundle:[NSBundle mainBundle]];
    [_virtualMCView loadView];
    
    NSRect dialogBounds = NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, self.virtualMCView.view.bounds.size.width, self.virtualMCView.view.bounds.size.height);

    // we create a simple window without a red close button and set this class
    // as window delegate. Because there is no close button wecannot
    // respond to windowShoudlClose: but must listen to NSWindowsWillCloseNotification
    self.mcConfigWindow = [[NSWindow alloc] initWithContentRect:dialogBounds styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:YES];
    self.mcConfigWindow.delegate = self;
    self.mcConfigWindow.releasedWhenClosed = false;
    [_mcConfigWindow setContentView:self.virtualMCView.view];
    
    self.virtualDevicePool = [[NSMutableArray alloc] initWithCapacity:10];
}


- (IBAction)segmentedControlClicked:(id)sender {
    
    NSInteger segmentNr = [(NSSegmentedControl *)sender selectedSegment];
    
    switch (segmentNr) {
        case 0:
            NSLog(@"Adding a virtual device");
            [_mcConfigWindow makeKeyAndOrderFront:nil];
            break;
        case 1:
            NSLog(@"Removing a virtual device");
            break;
        case 2:
            NSLog(@"Advanced option clicked");
            break;
        default:
            break;
    }
}

/*
 * Window delegate methods
 */

- (void)windowWillClose:(NSNotification *)notification {
    NSLog(@"Adding device %@", self.virtualMCView.deviceName.stringValue);
    VirtualDevice *newDevice = [[VirtualDevice alloc] initWithDeviceName:self.virtualMCView.deviceName.stringValue andNumber:12];
    [self.virtualDevicePool addObject:newDevice];
    
    NSLog(@"Pool has %lu devices", (unsigned long)[self.virtualDevicePool count]);
    
}


@end
