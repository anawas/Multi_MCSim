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
- (IBAction)adDeviceButtonPressed:(id)sender;

@end

@implementation VMCConfigController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.deviceName setStringValue:@"Test"];
        [self.virtualSensorMatrix selectCellAtRow:1 column:1];
        NSButtonCell *cell = self.virtualSensorMatrix.selectedCell;
        [cell setState:0];

    }
    return self;
}

- (IBAction)startDeviceButtonPressed:(id)sender {
}

- (IBAction)stopDeviceButtonPressed:(id)sender {
}

- (IBAction)adDeviceButtonPressed:(id)sender {
    [self.view.window close];
}

- (void)setVirtualSensorMatrixWithNumber:(NSInteger)sensors {
    if (sensors & SENSOR_TEMPERATURE) {
        
    }
    
    if (sensors & SENSOR_HUMIDITY) {
    
    }
    
    if (sensors & SENSOR_HUMIDITY) {
        
    }
    
    if (sensors & SENSOR_LEVEL) {
        
    }
    
    if (sensors & SENSOR_STATUS) {
        
    }
    
    if (sensors & SENSOR_GEOLOCATION) {
        
    }
    
    if (sensors & SENSOR_MESSAGE) {
    
    }
}
@end
