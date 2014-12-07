//
//  JoyPadViewController.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "JoyPadViewController.h"

@implementation JoyPadViewController

#pragma mark - Standard Button Functionality
- (IBAction)buttonDown:(id)sender {
    //NSLog([NSString stringWithFormat:@"%@",[sender restorationIdentifier]]);
    //    NSString *keyCode = [sender label];
    //[self forwardButtonEvent:sender keyState:YES];
}

- (IBAction)buttonRelease:(id)sender {
    //[self forwardButtonEvent:sender keyState:NO];
}


#pragma mark - Directional Pad Functionality
- (IBAction)longPressRecognized:(id)sender {
    if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [_longPressGestureRecognizer
                         locationInView:self.view];
        [self moveStickTo:touchLocation];
        [_joystickView setHidden:NO];
        //NSLog(@"AAH, TOUCHY!");
    }
    if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [_joystickView setHidden:YES];
        [self moveStickTo:joystickCenter];
        //NSLog(@"NO MORE TOUCHY!");
    }
    if ([_longPressGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        touchLocation = [_longPressGestureRecognizer
                         locationInView:self.view];
        [self moveStickTo:touchLocation];
    }
    //NSLog([NSString stringWithFormat:@"Location x:%f y:%f",touchLocation.x,touchLocation.y]);
}

- (IBAction)panRecognized:(id)sender {
    if ([_panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [_panGestureRecognizer locationInView:self.view];
        [self moveStickTo:touchLocation];
        [_joystickView setHidden:NO];
        //NSLog(@"AAH, TOUCHY!");
    }
    if ([_panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [_joystickView setHidden:YES];
        [self moveStickTo:joystickCenter];
        //NSLog(@"NO MORE TOUCHY!");
    }
    if ([_panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        touchLocation = [_panGestureRecognizer locationInView:self.view];
        [self moveStickTo:touchLocation];
    }
    //NSLog([NSString stringWithFormat:@"Location x:%f y:%f",touchLocation.x,touchLocation.y]);
}

- (void)moveStickTo:(CGPoint)location {
    _joystickView.center = location;
    touchDeltaXFromJStickCenter = [NSNumber numberWithFloat:(location.x - joystickCenter.x)];
    touchDeltaYFromJStickCenter = [NSNumber numberWithFloat:(location.y - joystickCenter.y)];
    //NSLog([NSString stringWithFormat:@"Current Touch deltaX: %@\t\tdeltaY: %@", touchDeltaXFromJStickCenter.stringValue,touchDeltaYFromJStickCenter.stringValue]);
}

- (void)restoreSticksLocation {
    _joystickView.center = joystickCenter;
    touchDeltaXFromJStickCenter = 0;
    touchDeltaYFromJStickCenter = 0;
    NSLog([NSString stringWithFormat:@"Reset Touch deltaX: %@\t\tdeltaY: %@", touchDeltaXFromJStickCenter.stringValue,touchDeltaYFromJStickCenter.stringValue]);
}

@end
