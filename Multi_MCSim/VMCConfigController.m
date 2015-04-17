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
- (IBAction)startDeviceButtonPressed:(id)sender;
- (IBAction)stopDeviceButtonPressed:(id)sender;

@end

@implementation VMCConfigController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.deviceName setStringValue:@"Test"];

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


@end
