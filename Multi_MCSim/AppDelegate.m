//
//  AppDelegate.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "AppDelegate.h"
#import "VirtualDevice.h"

@interface AppDelegate () {
    BOOL useLocalHost;
}
- (void)toggleServerControlState;
@end


@implementation AppDelegate {
    BOOL userStartedEditing;
}

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
    
    self.poolTableDatasource = [[DevicePoolTableController alloc] init];
    self.poolTableDatasource.devicePool = self.virtualDevicePool;
    
    self.devicePoolTable.dataSource = self.poolTableDatasource;
    self.remoteHostUrlText.delegate = self;
    useLocalHost = true;
    [self toggleServerControlState];
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

- (IBAction)serverTypeChanges:(id)sender {
    NSURL *hostUrl;
    
    if ([[[sender selectedCell] title] isEqualToString:@"Localhost"]) {
        hostUrl = [[NSURL alloc] initWithString:@"http://localhost"];
        if (![_portNumberText isEnabled]) {
            [self toggleServerControlState];
        }
    } else {
        hostUrl = [[NSURL alloc] initWithString:self.remoteHostUrlText.stringValue];
        if ([self.apiKeyCheckBox state] == NSOnState) {
            self.apiKeyText.stringValue = [self.apiKeyCheckBox stringValue];
        }
        if (![_remoteHostUrlText isEnabled]) {
            [self toggleServerControlState];
        }
    }
    NSLog(@"%@", hostUrl);
}

/*
 * Window delegate methods
 */
- (void)windowWillClose:(NSNotification *)notification {
    // close was called when app is terminating
    if (!userStartedEditing) {return;}

    
    // if the user pressed cancel we must not add a device;
    if (self.virtualMCView.cancelPressed) {
        userStartedEditing = false;
        return;
    }
    
    userStartedEditing = false;
    
    int deviceNr = rand();
    VirtualDevice *newDevice = [[VirtualDevice alloc] initWithDeviceName:self.virtualMCView.deviceName.stringValue andNumber:deviceNr];
    newDevice.builtinSensors = [_virtualMCView retrieveBuiltinSensors];
    newDevice.serverUrl = [[NSURL alloc] initWithString:self.remoteHostUrlText.stringValue];
    newDevice.updateInterval = 2;
    
    [self.virtualDevicePool addObject:newDevice];
    [newDevice startMeasuring];
    NSLog(@"%@", [newDevice description]);
    NSLog(@"Pool has %lu devices", (unsigned long)[self.virtualDevicePool count]);
    [_devicePoolTable reloadData];
    
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    [self.virtualMCView resetControls];
    userStartedEditing = true;
    
}

/*
 * NSTextFieldDelegate
 */
- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    NSControl *postingObject = [aNotification object]; // the object that posted the notification

    switch ([postingObject tag]) {
        case 1001:
            // the user edited the localhost port
            // --> update port in devices
            break;
        case 1002:
            // the user edited the remote host url.
            // --> update remote server urls in devices
            break;
        case 1003:
            // the user edited the api key.
            // --> update api in devices
            break;
            
        default:
            break;
    }
    NSLog(@"posted by: %@ (tag: %ld)", postingObject, [postingObject tag]);
}

/*
 * Private Methods
 */
- (void)toggleServerControlState {

    BOOL enabled = [_remoteHostUrlText isEnabled];
    
        [_remoteHostUrlText setEnabled:!enabled];
        [_apiKeyText setEnabled:!enabled];
        [_apiKeyCheckBox setEnabled:!enabled];
        [_portNumberText setEnabled:enabled];
}

@end
