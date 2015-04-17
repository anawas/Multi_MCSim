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

- (BOOL)control:(NSControl *)control
textShouldEndEditing:(NSText *)fieldEditor {
    
    if (self.timeIntervalText.stringValue.integerValue <= 0) return NO;
    return YES;
}


@end
