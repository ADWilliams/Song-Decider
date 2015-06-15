//
//  ViewController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-13.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "LoginController.h"
#import "RdioManager.h"


@interface LoginController ()

@property (nonatomic)Rdio *rdio;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    
    
    [self.rdio preparePlayerWithDelegate:nil];
    [self.rdio.player performSelector:@selector(play:) withObject:@"t1" afterDelay:2.0];

    
    
}
- (IBAction)loginButtonPressed:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
