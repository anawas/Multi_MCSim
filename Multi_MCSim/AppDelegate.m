//
//  AppDelegate.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "AppDelegate.h"
#import "VirtualDevice.h"

@class VirtualDevice;

@interface AppDelegate () {
    BOOL useLocalHost;
}
- (void)toggleServerControlState;
- (VirtualDevice *)createVirtualDeviceWithName:(NSString *)deviceName
                                     andNumber:(NSInteger)number
                                updateInterval:(NSInteger)interval
                                 andMultiplier:(NSInteger)multiplier;
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
    
    // the ip of our ec2 instance
    self.remoteHostUrlText.stringValue = @"52.24.130.149";
    useLocalHost = true;
    self.targetHostUrl = @"localhost";
    self.targetPort = 47053;
    self.portNumberText.stringValue = [NSString stringWithFormat:@"%ld", (long)_targetPort];
    [self toggleServerControlState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(aDeviceUpdated:)
            name:@"DeviceUpdatedNotification"
            object:nil];
}

- (void)aDeviceUpdated:(NSNotification *)notification {
    [_devicePoolTable reloadData];
}


- (IBAction)menuItemSelected:(id)sender {
    long itemTagSelected = [(NSMenuItem *)sender tag];
    int i;
    
    switch (itemTagSelected) {
        case 1:
            for (i = 0; i < 20; i++) {
                long deviceNr = rand();
                VirtualDevice *newDevice = [self createVirtualDeviceWithName:[NSString stringWithFormat:@"%010ld", deviceNr]
                                                                   andNumber:deviceNr
                                                              updateInterval:1
                                                               andMultiplier:MULTIPLIER_SECONDS];
                
                // now we add it to our pool
                [self.virtualDevicePool addObject:newDevice];
                
                [newDevice startMeasuring];
                newDevice.deviceIsRunning = YES;
            }
            [_devicePoolTable reloadData];
            [self savePrefernces];
            break;
        case 2:
            NSLog(@"Cleaning up stress test");
            break;
            
        default:
            break;
    }
}

-(void)savePrefernces {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *devicelist = [NSMutableArray arrayWithCapacity:30];
    
    for (VirtualDevice *device in self.virtualDevicePool) {
        [devicelist addObject:[device deviceName]];
    }
    
    [defaults setObject:(NSArray *)devicelist forKey:@"devicepool"];
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
            [self.stressTestPopup popUpMenuPositioningItem:nil atLocation:[NSEvent mouseLocation] inView:nil];
            
             
            break;
        default:
            break;
    }
}

- (IBAction)serverTypeChanges:(id)sender {
    NSURL *hostUrl;
    
    if ([[[sender selectedCell] title] isEqualToString:@"Localhost"]) {
        self.targetHostUrl = @"localhost";
        self.targetPort = self.portNumberText.integerValue;
        if (![_portNumberText isEnabled]) {
            [self toggleServerControlState];
        }
    } else {
        self.targetHostUrl = self.remoteHostUrlText.stringValue;
        self.targetPort = self.remotePortNumberText.integerValue;
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
    VirtualDevice *newDevice;
    
    int multiplier = 0;
    if ([self.virtualMCView.timeFrame.selectedItem.title compare:@"Seconds"] == 0) {
        multiplier = MULTIPLIER_SECONDS;
    } else if ([self.virtualMCView.timeFrame.selectedItem.title compare:@"Minutes"] == 0) {
        multiplier = MULTIPLIER_MINUTES;
    } else {
        multiplier= MULTIPLIER_HOURS;
    }

    newDevice = [self createVirtualDeviceWithName:self.virtualMCView.deviceName.stringValue
                                        andNumber:deviceNr
                                   updateInterval:self.virtualMCView.timeIntervalText.integerValue
                                    andMultiplier:multiplier];
    newDevice.port = self.targetPort;

    // now we add it to our pool
    [self.virtualDevicePool addObject:newDevice];

    [newDevice startMeasuring];
    newDevice.deviceIsRunning = YES;
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
            self.targetPort = self.portNumberText.integerValue;
            // the user edited the localhost port
            // --> update port in devices
            break;
        case 1002:
            self.targetHostUrl = self.remoteHostUrlText.stringValue;
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
    [_remotePortNumberText setEnabled:!enabled];
    [_portNumberText setEnabled:enabled];
    
    useLocalHost = !enabled;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}


- (VirtualDevice *)createVirtualDeviceWithName:(NSString *)deviceName
                                     andNumber:(NSInteger)number
                                updateInterval:(NSInteger)interval
                                 andMultiplier:(NSInteger)multiplier
{
    VirtualDevice *newDevice = [[VirtualDevice alloc] initWithDeviceName:deviceName
                                                               andNumber:number];
    newDevice.serverUrl = self.remoteHostUrlText.stringValue;
    newDevice.port = self.remotePortNumberText.integerValue;
    
    [newDevice setUpdateInterval:self.virtualMCView.timeIntervalText.integerValue withMutliplier:multiplier];
    [newDevice startSocketAtPort:self.targetPort andUrl:self.targetHostUrl];
    return newDevice;
}



@end
