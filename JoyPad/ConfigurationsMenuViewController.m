//
//  ConfigurationsMenuViewController.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "ConfigurationsMenuViewController.h"

@implementation ConfigurationsMenuViewController
- (IBAction)beginPairingProcess:(id)sender {
    [self.bluetoothServer startAdvertisements];
}


@end
