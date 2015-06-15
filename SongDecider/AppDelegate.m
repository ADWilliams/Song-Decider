//
//  AppDelegate.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-13.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic)Rdio *rdio;
@end

static Rdio * _rdio;

@implementation AppDelegate


+(Rdio *)sharedRdio {
    if (_rdio == nil) {
        _rdio = [[Rdio alloc] initWithClientId:@"v2m4glmzrjahhahztx3qzn5skq" andSecret:@"1Vc9Hhe-JNLMIkc7UR-k2g" delegate:nil];
    }
    return _rdio;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //self.rdio = [[Rdio alloc] initWithClientId:@"v2m4glmzrjahhahztx3qzn5skq" andSecret:@"1Vc9Hhe-JNLMIkc7UR-k2g" delegate:nil];
    //[self.rdio preparePlayerWithDelegate:nil];
    
    //UINavigationController *nav = (UINavigationController *)[self.window rootViewController];

    //ViewController *viewController = [nav.viewControllers firstObject];
    //viewController.rdio = self.rdio;
    Rdio *r = [AppDelegate sharedRdio];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.rdio.user forKey:@"user"];
    [defaults synchronize];
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

@end
