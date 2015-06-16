//
//  ViewController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-13.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//
#import "MainViewController.h"
#import "LoginController.h"
#import "RdioManager.h"


@interface LoginController () <RdioDelegate>

@property (nonatomic)Rdio *rdio;

@end

@implementation LoginController

-(void)viewWillAppear:(BOOL)animated {
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    self.rdio.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.rdio.delegate = self;
    


    
    
}
- (IBAction)loginButtonPressed:(id)sender {
    [self.rdio logout];
    [self.rdio authorizeFromController:self];
}

-(void)rdioDidAuthorizeUser:(NSDictionary *)user {
    
    [self performSegueWithIdentifier:@"showMainView" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
