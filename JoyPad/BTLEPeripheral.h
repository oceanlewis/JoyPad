//
//  BTLEPeripheral.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define MAIN_TRANSFER_SERVICE_UUID                      @"B8C9D2F5-AB53-4D4A-8F41-C764EA5577C9"
#define GAMEPAD_STATE_CHARACTERISTIC_UUID               @"4B0CDC50-C3F6-4D64-8001-2C361BEF1D99"
#define GAMEPAD_CONFIGURATION_CHARACTERISTIC_UUID       @"3E128AE1-4BD6-4F7D-A49E-B3E789E6C4AC"

// Gamepad State Data
#define A_BUTTON_INDEX      0
#define B_BUTTON_INDEX      1
#define X_BUTTON_INDEX      2
#define Y_BUTTON_INDEX      3
#define START_BUTTON_INDEX  4
#define SELECT_BUTTON_INDEX 5
#define DPAD_UP_INDEX       6
#define DPAD_DOWN_INDEX     7
#define DPAD_LEFT_INDEX     8
#define DPAD_RIGHT_INDEX    9
#define DELTA_X_INDEX       16  // Floating Point Value
#define DELTA_Y_INDEX       48  // Floating Point Value

typedef uint16_t CGKeyCode;

typedef struct {
    float deltaX, deltaY;
    short int stateFlags;
} GamepadState;

typedef struct {
    CGKeyCode a, b, x, y, select, start;
} GamepadConfiguration;

typedef struct {
    float deltaX, deltaY;
} JoystickDelta;

@interface BTLEPeripheral : NSObject <CBPeripheralManagerDelegate>

@end
