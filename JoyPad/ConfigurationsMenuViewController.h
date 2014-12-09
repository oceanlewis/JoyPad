//
//  ConfigurationsMenuViewController.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "JoyPadViewController.h"

@class BTLEPairingViewController;

@interface ConfigurationsMenuViewController : UIViewController
@property BTLEPeripheral *bluetoothServer;
@end
