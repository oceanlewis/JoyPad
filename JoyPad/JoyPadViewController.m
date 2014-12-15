//
//  JoyPadViewController.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "JoyPadViewController.h"

@implementation JoyPadViewController

- (void)viewDidLoad {
    // [_joystickView setHidden:YES];
    window = [[UIApplication sharedApplication] keyWindow];
    CGRect joystickFrame = self.joystickBase.frame;
    dpadCenter = joystickFrame.origin;
    dpadCenter.x += joystickFrame.size.width / 2;
    dpadCenter.y += joystickFrame.size.height / 2;
    [_joystickBase setUserInteractionEnabled:YES];
    [super viewDidLoad];
}

//- (void)buttonEvent:(NSString *)buttonName buttonState:(BOOL)wasPresssed;
#pragma mark - Standard Button Functionality
- (IBAction)buttonDown:(id)sender {
    NSString *buttonName = [sender restorationIdentifier];
    //NSLog(@"%@ Pressed.",buttonName);
    [self.bluetoothServer buttonEvent:buttonName buttonState:YES];
}

- (IBAction)buttonRelease:(id)sender {
    NSString *buttonName = [sender restorationIdentifier];
    //NSLog(@"%@ Released.",buttonName);
    [self.bluetoothServer buttonEvent:buttonName buttonState:NO];
}


#pragma mark - Directional Pad Functionality
- (IBAction)longPressRecognized:(id)sender {
    if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [_longPressGestureRecognizer locationInView:window.viewForBaselineLayout];
        [self moveStickTo:touchLocation];
        [_joystickView setHidden:NO];
    }
    else if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [_joystickView setHidden:YES];
        [self moveStickTo:dpadCenter];
    }
    else if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        touchLocation = [_longPressGestureRecognizer locationInView:window.viewForBaselineLayout];
        [self moveStickTo:touchLocation];
    }
}

- (IBAction)panRecognized:(id)sender {
    if ([_panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [_panGestureRecognizer locationInView:window.viewForBaselineLayout];
        [self moveStickTo:touchLocation];
        [_joystickView setHidden:NO];
    }
    else if ([_panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [_joystickView setHidden:YES];
        [self moveStickTo:dpadCenter];
    }
    else if ([_panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        touchLocation = [_panGestureRecognizer locationInView:window.viewForBaselineLayout];
        [self moveStickTo:touchLocation];
    }
}

//- (void)joystickEvent:(JoystickDelta)deltas;
- (void)moveStickTo:(CGPoint)location {
    _joystickView.center = location;
    deltaFromJStickCenter.deltaX = (location.x - dpadCenter.x);
    deltaFromJStickCenter.deltaY = (location.y - dpadCenter.y);
    [self.bluetoothServer joystickEvent:deltaFromJStickCenter];
}

- (void)restoreSticksLocation {
    _joystickView.center = dpadCenter;
    deltaFromJStickCenter.deltaX = 0;
    deltaFromJStickCenter.deltaY = 0;
    [self.bluetoothServer joystickEvent:deltaFromJStickCenter];
}

@end
