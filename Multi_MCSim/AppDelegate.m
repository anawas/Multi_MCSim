//
//  AppDelegate.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.virtualMCView = [[VirtualMC alloc] initWithNibName:@"VirtualMC" bundle:[NSBundle mainBundle]];
    [_virtualMCView loadView];
    
    NSRect dialogBounds = NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, self.virtualMCView.view.bounds.size.width, self.virtualMCView.view.bounds.size.height);
    self.test = [[NSWindow alloc] initWithContentRect:dialogBounds styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:YES];
    [_test setContentView:self.virtualMCView.view];
    [_test makeKeyAndOrderFront:nil];
}


- (IBAction)segmentedControlClicked:(id)sender {
    
    NSInteger segmentNr = [(NSSegmentedControl *)sender selectedSegment];
    
    switch (segmentNr) {
        case 0:
            NSLog(@"Adding a virtual device");
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
@end
