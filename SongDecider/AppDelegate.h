//
//  AppDelegate.h
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-13.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(Rdio *)sharedRdio;

@end

