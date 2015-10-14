//
//  VMCConfigController.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "VMCConfigController.h"
#import "VirtualDevice.h"

@interface VMCConfigController ()

@end

@implementation VMCConfigController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.deviceName setStringValue:@"Test"];
        [self.deviceName setDelegate:self];
        self.protocolVersion = 1;
        self.gpsSensorCheckbox.state = NSOffState;
        self.gpsSensorCheckbox.enabled = NO;
        self.hasGps = false;
    }
    return self;
}

- (IBAction)startDeviceButtonPressed:(id)sender {
   [self.view.window close];
}

- (IBAction)stopDeviceButtonPressed:(id)sender {
}

- (IBAction)cancelButtonPressed:(id)sender {
    self.cancelPressed = true;
    [self.view.window close];
}

- (IBAction)newIdButtonPressed:(id)sender {
    self.deviceName.stringValue = [[NSString alloc] initWithFormat:@"%08d", arc4random_uniform(10000000)+21000000];
}

- (IBAction)protocolVersionChanged:(id)sender {
    NSMatrix *theMatrix = (NSMatrix *)sender;
    if ([[[theMatrix selectedCell] title] isEqualToString:@"V 1.0"]) {
        self.protocolVersion = 1;
        self.gpsSensorCheckbox.state = NSOffState;
        self.gpsSensorCheckbox.enabled = NO;
    } else {
        self.protocolVersion = 2;
        self.gpsSensorCheckbox.enabled = YES;
    }
    NSLog(@"Stream version set to %d", self.protocolVersion);
}

- (IBAction)hasGpsChanged:(id)sender {
    
    if ([sender state] == NSOnState) {
        self.hasGps = NSOnState;
    } else {
        self.hasGps = NSOffState;
    }
}

- (NSDictionary *)retrieveBuiltinSensors {
    NSMutableDictionary *sensors = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    return (NSDictionary *)sensors;
}

- (void)resetControls {
    self.deviceName.stringValue = [[NSString alloc] initWithFormat:@"%08d", arc4random_uniform(10000000)+21000000];
    self.cancelPressed = false;
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

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    
    if (self.timeIntervalText.stringValue.integerValue <= 0) return NO;
    return YES;
}


@end
