//
//  VMCConfigController.m
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import "VMCConfigController.h"

@interface VMCConfigController ()
@property (weak) IBOutlet NSTextFieldCell *deviceName;
@property (weak) IBOutlet NSSlider *updateInterval;
@property (weak) IBOutlet NSPopUpButton *intervalMultiplier;
@property (weak) IBOutlet NSMatrix *virtualSensorMatrix;

- (IBAction)startDeviceButtonPressed:(id)sender;
- (IBAction)stopDeviceButtonPressed:(id)sender;
@end

@implementation VMCConfigController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.virtualSensorMatrix selectCellAtRow:1 column:1];
        NSButtonCell *cell = self.virtualSensorMatrix.selectedCell;
        [cell setState:0];
        // Initialization code here.
    }
    return self;
}

- (IBAction)startDeviceButtonPressed:(id)sender {
}

- (IBAction)stopDeviceButtonPressed:(id)sender {
}
@end
