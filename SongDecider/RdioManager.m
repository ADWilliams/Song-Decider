//
//  RdioInstance.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "RdioManager.h"

@implementation RdioManager

@synthesize rdioInstance;

+(id)sharedRdio {
    
    static RdioManager *sharedRdio = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedRdio = [[self alloc]init];
    });
    return sharedRdio;
}

-(instancetype)init {
    if (self = [super init]) {
        rdioInstance = [[Rdio alloc]initWithClientId:@"v2m4glmzrjahhahztx3qzn5skq" andSecret:@"1Vc9Hhe-JNLMIkc7UR-k2g" delegate:nil];
    }
    return self;
}


@end
