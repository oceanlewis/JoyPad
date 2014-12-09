//  BTLEPeripheral.h
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define MAIN_TRANSFER_SERVICE_UUID                      @"B8C9D2F5-AB53-4D4A-8F41-C764EA5577C9"
#define GAMEPAD_STATE_CHARACTERISTIC_UUID               @"4B0CDC50-C3F6-4D64-8001-2C361BEF1D99"
#define GAMEPAD_CONFIGURATION_CHARACTERISTIC_UUID       @"3E128AE1-4BD6-4F7D-A49E-B3E789E6C4AC"

//Gamepad State Masks
#define A_BUTTON_MASK       0x0001
#define B_BUTTON_MASK       0x0002
#define X_BUTTON_MASK       0x0004
#define Y_BUTTON_MASK       0x0008
#define START_BUTTON_MASK   0x0010
#define SELECT_BUTTON_MASK  0x0020
#define DPAD_UP_MASK        0x0040
#define DPAD_DOWN_MASK      0x0080
#define DPAD_LEFT_MASK      0x0100
#define DPAD_RIGHT_MASK     0x0200

#pragma mark - Data Structure Definitions
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

typedef enum : NSUInteger {
    PeripheralConnectionStateDisconnected,
    PeripheralConnectionStateBooting,
    PeripheralConnectionStateScanning,
    PeripheralConnectionStateConnected,
    PeripheralConnectionStateDisconnecting
} PeripheralConnectionState;

#pragma mark - BTLEPeripheralDelegate (CENTRAL) Protocol
@protocol BTLEPeripheralDelegate <NSObject>
@optional
-(void) stateDidUpdate:(PeripheralConnectionState)state;
-(void) hardwareStateDidUpdate:(NSInteger)hardwareState;
@end

#pragma mark - BTLEPeripheral (THIS)
@interface BTLEPeripheral : NSObject <CBPeripheralManagerDelegate>
{
    CBPeripheralManager *peripheralManager;
    CBMutableService *transferService;
    CBMutableCharacteristic *gamepadState, *gamepadConfigurations;
    NSMutableDictionary *advertisement;
    NSMutableData *gamepadStateData;
    NSMutableData *gamepadConfigData;
    NSMutableDictionary *gamepadKeyBindings;
    BOOL preventInitialAdvertising;
}

@property id <BTLEPeripheralDelegate> delegate;
@property (nonatomic) PeripheralConnectionState state;
@property (nonatomic) GamepadState currentGamepadState;
@property (nonatomic) GamepadConfiguration gamepadConfiguration;
-(id) initWithDelegate:(id<BTLEPeripheralDelegate>)delegate;
-(id) initWithDelegate:(id<BTLEPeripheralDelegate>)delegate WithoutAdvertising:(BOOL)preventAdvertising;

#pragma mark - JoyPad Events
- (void)buttonEvent:(NSString *)buttonName buttonState:(BOOL)wasPresssed;
- (void)joystickEvent:(JoystickDelta)deltas;

#pragma mark - Broadcasts
-(void) broadcastNewConfigurations:(NSData*)data;
-(void) broadcastJoypadState:(GamepadState)newState;

/* ==Hardware States Reference==
 * 0 BLEHardwareStateUnknown,
 * 1 BLEHardwareStateResetting,
 * 2 BLEHardwareStateUnsupported,
 * 3 BLEHardwareStateUnauthorized,
 * 4 BLEHardwareStatePoweredOff,
 * 5 BLEHardwareStatePoweredOn 
    ^- only one which should allow code to progress */
-(NSUInteger) hardwareState;


// advertising
@property (readonly) BOOL isAdvertising;
-(void) startAdvertisements;
-(void) stopAdvertisements:(BOOL)serverAlreadyDisconnected;


@end
