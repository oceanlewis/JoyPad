//
//  BTLEPeripheral.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "BTLEPeripheral.h"

@implementation BTLEPeripheral
@synthesize currentGamepadState;
@synthesize gamepadConfiguration;
#pragma mark - INIT
/* Most of this has been lifted from 'Hoverpad' taken from Github.
 In the interest of time I just wanted Bluetooth working
 as I couldn't get it to work before. D: */

- (id)init {
    self = [super init];
    if (self) {
        [self buildService];
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                             queue:nil
                                                           options:nil];
    }
    return self;
}
-(id) initWithDelegate:(id<BTLEPeripheralDelegate>)delegate{
    self = [super init];
    if(self){
        _delegate = delegate;
        [self buildService];
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        //        NSLog(@" 1 : PERIPHERAL : 1 - INIT");
    }
    return self;
}
-(id) initWithDelegate:(id<BTLEPeripheralDelegate>)delegate WithoutAdvertising:(BOOL)preventAdvertising{
    self = [super init];
    if(self){
        _delegate = delegate;
        [self buildService];
        preventInitialAdvertising = preventAdvertising;
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        //        NSLog(@" 1 : PERIPHERAL : 1 - INIT");
    }
    return self;
}
- (void)buildService {
    gamepadConfigurations = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:GAMEPAD_CONFIGURATION_CHARACTERISTIC_UUID] properties:(CBCharacteristicPropertyRead|CBCharacteristicPropertyNotify) value:nil permissions:CBAttributePermissionsReadable];
    gamepadState = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:GAMEPAD_STATE_CHARACTERISTIC_UUID] properties:(CBCharacteristicPropertyRead|CBCharacteristicPropertyNotify) value:nil permissions:CBAttributePermissionsReadable];
    transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:MAIN_TRANSFER_SERVICE_UUID] primary:YES];
    transferService.characteristics = @[gamepadConfigurations, gamepadState];
    advertisement = [NSMutableDictionary dictionary];
    [advertisement setObject:[self getName] forKey:CBAdvertisementDataLocalNameKey];
    [advertisement setObject:@[[CBUUID UUIDWithString:MAIN_TRANSFER_SERVICE_UUID]] forKey:CBAdvertisementDataServiceUUIDsKey];
    
    currentGamepadState.stateFlags = 0;
    currentGamepadState.deltaX = 0.0;
    currentGamepadState.deltaY = 0.0;
}

#pragma mark - JoyPad Events
- (void)buttonEvent:(NSString *)buttonName buttonState:(BOOL)wasPressed {
    if ([buttonName isEqualToString:@"A_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= A_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~A_BUTTON_MASK;
    }
    else if ([buttonName isEqualToString:@"B_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= B_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~B_BUTTON_MASK;
    }
    else if ([buttonName isEqualToString:@"X_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= X_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~X_BUTTON_MASK;
    }
    else if ([buttonName isEqualToString:@"Y_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= Y_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~Y_BUTTON_MASK;
    }
    else if ([buttonName isEqualToString:@"Start_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= START_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~START_BUTTON_MASK;
    }
    else if ([buttonName isEqualToString:@"Select_Button"]) {
        if (wasPressed)
            currentGamepadState.stateFlags |= SELECT_BUTTON_MASK;
        else
            currentGamepadState.stateFlags &= ~SELECT_BUTTON_MASK;
    }
    // Don't forget we need to broadcast our new state!
    [self broadcastJoypadState:currentGamepadState];
    
    // Fuck yeah, debuggin'!
    [self debugJoyPadState:currentGamepadState];
}

- (void)debugJoyPadState:(GamepadState)currentState {
    short int stateFlags = currentState.stateFlags;
    short int aState, bState, xState, yState, startState, selectState, dUp, dDown, dLeft, dRight;
    
    aState = stateFlags & A_BUTTON_MASK;
    (aState > 0)?(aState = 1):(aState = 0);
    
    bState = stateFlags & B_BUTTON_MASK;
    (bState > 0)?(bState = 1):(bState = 0);
    
    xState = stateFlags & X_BUTTON_MASK;
    (xState > 0)?(xState = 1):(xState = 0);
    
    yState = stateFlags & Y_BUTTON_MASK;
    (yState > 0)?(yState = 1):(yState = 0);
    
    startState = stateFlags & START_BUTTON_MASK;
    (startState > 0)?(startState = 1):(startState = 0);
    
    selectState = stateFlags & SELECT_BUTTON_MASK;
    (selectState > 0)?(selectState = 1):(selectState = 0);
    
    dUp = stateFlags & DPAD_UP_MASK;
    (dUp > 0)?(dUp = 1):(dUp = 0);
    
    dDown = stateFlags & DPAD_DOWN_MASK;
    (dDown > 0)?(dDown = 1):(dDown = 0);
    
    dLeft = stateFlags & DPAD_LEFT_MASK;
    (dLeft > 0)?(dLeft = 1):(dLeft = 0);
    
    dRight = stateFlags & DPAD_RIGHT_MASK;
    (dRight > 0)?(dRight = 1):(dRight = 0);
    
    NSLog(@"deltaX: %6.2f\t\tdeltaY: %6.2f", currentGamepadState.deltaX, currentGamepadState.deltaY);
    NSLog(@"%d %d %d %d %d %d %d %d %d %d", dRight, dLeft, dDown, dUp, selectState, startState, yState, xState, bState, aState);
}

- (void)joystickEvent:(JoystickDelta)deltas {
    currentGamepadState.deltaX = deltas.deltaX;
    currentGamepadState.deltaY = deltas.deltaY;
    
    // Don't forget we need to broadcast our new state!
    [self broadcastJoypadState:currentGamepadState];
    
    [self debugJoyPadState:currentGamepadState];
}

#pragma mark - CUSTOM CALLS
//-(void) sendDisconnect{
//    unsigned char exit[1] = {0x3b};
//    if(peripheralManager)
//        [peripheralManager updateValue:[NSData dataWithBytes:&exit length:1] forCharacteristic:notifyCharacteristic onSubscribedCentrals:nil];
//}

-(void)broadcastNewConfigurations:(NSData *)gamepadConfigs{
    NSLog(@"New Configurations Broadcasted!");
    if(peripheralManager)
        [peripheralManager updateValue:gamepadConfigs
                     forCharacteristic:gamepadConfigurations
                  onSubscribedCentrals:nil];
    else NSLog(@"broadcastNewConfigurations FAILED - No PeripheralManager!");

}

-(void) broadcastJoypadState:(GamepadState)newState{
    NSLog(@"JoyPad State Broadcasted!");
    if(peripheralManager)
        [peripheralManager updateValue:[NSData dataWithBytes:&newState length:10]
                     forCharacteristic:gamepadState
                  onSubscribedCentrals:nil];
    else NSLog(@"broadcastJoypadState FAILED - No PeripheralManager!");
}

-(NSUInteger) hardwareState{
    return [peripheralManager state];
}

-(void) setState:(PeripheralConnectionState)state{
    _state = state;
    [_delegate stateDidUpdate:state];
    //    NSLog(@"STATE CHANGE: %d",(int)state);
    //    if(state == PeripheralConnectionStateDisconnected);
    //    if(state == PeripheralConnectionStateBooting);
    //    if(state == PeripheralConnectionStateScanning);
    //    if(state == PeripheralConnectionStateScanning);
    //    if(state == PeripheralConnectionStateDisconnecting);
}

- (NSString*)getName{
    //    return [NSString stringWithFormat:@"Hoverpad (%@)",_UUID];
    return @"JoyPad";
}

#pragma mark- CORE

- (void)startAdvertisements{
    [peripheralManager startAdvertising:advertisement];
    _isAdvertising = YES;
        NSLog(@" 3 : PERIPHERAL : 3 - STARTING ADVERTISEMENTS");
}

- (void)stopAdvertisements:(BOOL)disconnectServer{
    
    if(disconnectServer) {
        NSLog(@"Disconnect Server? Not handled.");
        //[self sendDisconnect];
    }
    
    [peripheralManager stopAdvertising];
    _isAdvertising = NO;
    
    //TODO: this is happening repeatedly
    [self setState:PeripheralConnectionStateDisconnected];
}

#pragma mark- DELEGATES - PERIPHERAL

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
        NSLog(@" 1b: PERIPHERAL : 1b- INIT DELEGATE RESPONSE");
    [_delegate hardwareStateDidUpdate:[peripheralManager state]];
    if([peripheralManager state] == CBPeripheralManagerStatePoweredOn){
        [peripheralManager addService:transferService];
                NSLog(@" 2 : PERIPHERAL : 2 - SERVICES ADDED");
    }
    else if ([peripheralManager state] == CBPeripheralManagerStateUnsupported){
                NSLog(@"WARNING: Bluetooth LE Unsupported");
    }
    else if([peripheralManager state] == CBPeripheralManagerStateUnauthorized){
                NSLog(@"WARNING: Bluetooth LE Unauthorized");
    }
    else if([peripheralManager state] == CBPeripheralManagerStateResetting){
                NSLog(@"WARNING: Bluetooth LE State Resetting");
    }
    else if([peripheralManager state] == CBPeripheralManagerStateUnknown){
                NSLog(@"WARNING: Bluetooth LE State Unknown");
    }
    else if([peripheralManager state] == CBPeripheralManagerStatePoweredOff){
                NSLog(@"WARNING: Bluetooth LE Manager Powered Off");
    }
}

-(void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    //    NSLog(@" 2b: PERIPHERAL : 2b- SERVICES ADDED DELEGATE RESPONSE");
    // TODO HANDLE ERROR
    if(!preventInitialAdvertising)
        [self startAdvertisements];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    // NSLog(@" 3b: PERIPHERAL : 3b- STARTING ADVERTISEMENTS DELEGATE RESPONSE");
    // TODO HANDLE ERROR
    [self setState:PeripheralConnectionStateScanning];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    //    NSLog(@"delegate: received write request");
    for(CBATTRequest* request in requests) {
        if([request.value bytes]){
            //            NSLog(@"WE RECEIVED INFO: %@",[request value]);
            if([[request value] length] == 2){
                unsigned char *msg = (unsigned char*)[[request value] bytes];
                if (msg[0] == 0x8F){ // version code
                    if(msg[1] == 0x01){  // release version 1
                        //                        NSLog(@"VERSION 1 SUCCESSFULLY RECEIVED");
                    }
                }
            }
            if([[request value] length] == 1){
                //            unsigned char exit[2] = {0x3b};
            }
        }
        [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    //    NSLog(@"delegate: received read request");
    //    NSString *valueToSend;
    //    NSDate *currentTime = [NSDate date];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"hh:mm:ss"];
    //    valueToSend = [dateFormatter stringFromDate: currentTime];
    //
    //    request.value = [valueToSend dataUsingEncoding:NSASCIIStringEncoding];
    //
    //    [peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    //    NSLog(@"delegate: Central subscribed to characteristic:%@",[characteristic UUID]);
    if(_state != PeripheralConnectionStateConnected)
        [self setState:PeripheralConnectionStateConnected];
}
-(void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    //    NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    //    NSLog(@"delegate: Central unsubscribed!");
    if([self state] != PeripheralConnectionStateDisconnected){
        //        [self setState:PeripheralConnectionStateDisconnected];
        [self stopAdvertisements:NO]; // this sets the disconnected state
    }
}

@end
