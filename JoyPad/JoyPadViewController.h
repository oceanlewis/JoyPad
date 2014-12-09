//
//  JoyPadViewController.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLEPeripheral.h"

@interface JoyPadViewController : UIViewController
{
    CGPoint touchLocation;
    JoystickDelta deltaFromJStickCenter;
    CGPoint dpadOrigin;
    CGPoint dpadDestination;
}

@property (weak, nonatomic) IBOutlet UIImageView *joystickView;
@property (weak, nonatomic) IBOutlet UIButton *joystickBase;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UIButton *yButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) BTLEPeripheral *bluetoothServer;

@end
