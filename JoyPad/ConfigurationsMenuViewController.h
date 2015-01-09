//
//  ConfigurationsMenuViewController.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoyPadViewController.h"
#import "AppDelegate.h"

@class BTLEPairingViewController;

@interface ConfigurationsMenuViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *dpadUp;
@property (retain, nonatomic) IBOutlet UITextField *dpadDown;
@property (retain, nonatomic) IBOutlet UITextField *dpadLeft;
@property (retain, nonatomic) IBOutlet UITextField *dpadRight;
@property (retain, nonatomic) IBOutlet UITextField *aButton;
@property (retain, nonatomic) IBOutlet UITextField *bButton;
@property (retain, nonatomic) IBOutlet UITextField *xButton;
@property (retain, nonatomic) IBOutlet UITextField *yButton;
@property (retain, nonatomic) IBOutlet UITextField *startButton;
@property (retain, nonatomic) IBOutlet UITextField *selectButton;
@property (retain, nonatomic) IBOutlet UIButton *beginPairingButton;
@property (retain, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak) BTLEPeripheral *bluetoothServer;

- (void)finalizeConfigurations;

@end
