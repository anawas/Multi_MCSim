//
//  AppDelegate.h
//  Multi_MCSim
//
//  Created by Andreas Wassmer on 17.09.14.
//  Copyright (c) 2014 Phandroo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VMCConfigController.h"
#import "DevicePoolTableController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTableView *devicePoolTable;
@property (assign) IBOutlet NSWindow *window;
@property (strong) VMCConfigController *virtualMCView;
@property (strong) NSWindow *mcConfigWindow;
@property (strong) NSMutableArray *virtualDevicePool;
@property (strong) DevicePoolTableController *poolTableDatasource;
@property (weak) IBOutlet NSTextField *portNumberText;
@property (weak) IBOutlet NSMenu *stressTestPopup;

@property (weak) IBOutlet NSTextField *remoteHostUrlText;
@property (weak) IBOutlet NSTextField *remotePortNumberText;
@property (weak) NSString *targetHostUrl;
@property        NSInteger targetPort;
- (IBAction)menuItemSelected:(id)sender;

- (IBAction)segmentedControlClicked:(id)sender;
- (IBAction)serverTypeChanges:(id)sender;

- (void)controlTextDidEndEditing:(NSNotification *)aNotification;

@end
