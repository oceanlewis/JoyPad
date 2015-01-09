//
//  ConfigurationsMenuViewController.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "ConfigurationsMenuViewController.h"
#import "AppDelegate.h"

@implementation ConfigurationsMenuViewController
{
    AppDelegate *appDelegate;
}
@synthesize dpadUp;
@synthesize dpadDown;
@synthesize dpadLeft;
@synthesize dpadRight;
@synthesize aButton;
@synthesize bButton;
@synthesize xButton;
@synthesize yButton;
@synthesize startButton;
@synthesize selectButton;
@synthesize beginPairingButton;
@synthesize disconnectButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.bluetoothServer = self->appDelegate.bluetoothServer;
}

#pragma mark - Text Handling
- (IBAction)textFieldDoneEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.dpadUp resignFirstResponder];
    [self.dpadDown resignFirstResponder];
    [self.dpadLeft resignFirstResponder];
    [self.dpadRight resignFirstResponder];
    [self.aButton resignFirstResponder];
    [self.bButton resignFirstResponder];
    [self.xButton resignFirstResponder];
    [self.yButton resignFirstResponder];
    [self.selectButton resignFirstResponder];
    [self.startButton resignFirstResponder];
    NSLog(@"Background Tapped, stuff resigned.");
}

- (void)finalizeConfigurations {
    NSArray *keys = [NSArray arrayWithObjects:@"A_Button", @"B_Button" ,@"X_Button", @"Y_Button", @"Start_Button", @"Select_Button", @"DPad_Up", @"DPad_Down", @"DPad_Left", @"DPad_Right", nil];
    NSArray *objects = [NSArray arrayWithObjects:self.aButton.text, [self.bButton text], [self.xButton text], [self.yButton text], [self.startButton text], [self.selectButton text], [self.dpadUp text], [self.dpadDown text], [self.dpadLeft text], [self.dpadRight text], nil];
    NSDictionary *gamepadConfigurations = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [self.bluetoothServer updateConfigurations:gamepadConfigurations];
}

- (IBAction)beginPairingProcess:(id)sender {
    [self->appDelegate beginPairingProcess];
    [self.beginPairingButton setHidden:YES];
    [self.disconnectButton setHidden:NO];
}
- (IBAction)disconnectFromCentral:(id)sender {
    [self->appDelegate cancelConnectionToCentral];
    [self.beginPairingButton setHidden:NO];
    [self.disconnectButton setHidden:YES];
}

@end
