//
//  VMCConfigController.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VMCConfigController : NSViewController
@property (strong) IBOutlet NSTextField *deviceName;
@property (weak) IBOutlet NSSlider *updateInterval;
@property (weak) IBOutlet NSPopUpButton *intervalMultiplier;
@property (weak) IBOutlet NSMatrix *virtualSensorMatrix;

- (void)setVirtualSensorMatrixWithNumber:(NSInteger)sensors;

@end
