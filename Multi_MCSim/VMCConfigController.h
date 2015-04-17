//
//  VMCConfigController.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface VMCConfigController : NSViewController <NSTextFieldDelegate>
@property (strong) IBOutlet NSTextField *deviceName;
@property (weak) IBOutlet NSPopUpButton *intervalMultiplier;
@property BOOL cancelPressed;
@property (weak) IBOutlet NSPopUpButton *timeFrame;
@property (strong) IBOutlet NSTextField *timeIntervalText;

- (IBAction)startDeviceButtonPressed:(id)sender;
- (IBAction)stopDeviceButtonPressed:(id)sender;
- (NSDictionary *)retrieveBuiltinSensors;
- (void)resetControls;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)newIdButtonPressed:(id)sender;

- (void)controlTextDidEndEditing:(NSNotification *)aNotification ;
- (BOOL)control:(NSControl *)control
textShouldEndEditing:(NSText *)fieldEditor;
@end
