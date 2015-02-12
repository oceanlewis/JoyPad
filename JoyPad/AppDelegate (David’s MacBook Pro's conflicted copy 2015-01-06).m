//
//  AppDelegate.m
//  JoyPad
//
//  Created by David Lewis on 12/5/14.
//  Copyright (c) 2014 David Lewis. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()
@property (weak, nonatomic) UIStoryboard *mainStoryboard;
@end


@implementation AppDelegate
@synthesize bluetoothServer;\

@synthesize configurationsView;
@synthesize joypadView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationWasChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    self.mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.configurationsView = [self.mainStoryboard instantiateInitialViewController];
    self.joypadView = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"JoyPadView"];
    [self.configurationsView loadView];
    id delegate = [[UIApplication sharedApplication] delegate];
    delegate = self;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//#pragma mark - Custom Commands
//- (void)beginPairingProcess {
//    [self.bluetoothServer startAdvertisements];
//}
#pragma mark - Scene Transitions
- (void)deviceOrientationWasChanged:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIViewController *topView = self.window.rootViewController;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if (!(topView.presentedViewController == self.joypadView))
            [topView presentViewController:self.joypadView
                                  animated:YES
                                completion:nil];
    }
    else if (topView.presentedViewController == self.joypadView)
        [topView dismissViewControllerAnimated:YES
                                    completion:nil];
    
    [self.configurationsView finalizeConfigurations];
}

- (void)beginPairingProcess {
    if (!self.bluetoothServer) {
        self.bluetoothServer = [[BTLEPeripheral alloc] init];
        [self.bluetoothServer broadcastDisconnect:NO];
        if (!self.configurationsView.bluetoothServer)
            self.configurationsView.bluetoothServer = self.bluetoothServer;
        if (!self.joypadView.bluetoothServer)
            self.joypadView.bluetoothServer = self.bluetoothServer;
    }
}
- (void)cancelConnectionToCentral {
    [self.bluetoothServer broadcastDisconnect:YES];
    self.joypadView.bluetoothServer = nil;
    self.configurationsView.bluetoothServer = nil;
    self.bluetoothServer = nil;
}

@end
