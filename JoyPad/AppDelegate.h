//
//  AppDelegate.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLEPeripheral.h"
#import "JoyPadViewController.h"
#import "ConfigurationsMenuViewController.h"
@class JoyPadViewController;
@class BTLEPeripheral;
@class ConfigurationsMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) BTLEPeripheral *bluetoothServer;
@property (retain, nonatomic) ConfigurationsMenuViewController *configurationsView;
@property (retain, nonatomic) JoyPadViewController *joypadView;

- (void)beginPairingProcess;
- (void)cancelConnectionToCentral;

@end