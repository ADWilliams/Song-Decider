//
//  ViewController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-13.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController ()<RdioDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;

@property (nonatomic) NSDictionary *track;
@property (nonatomic) NSMutableArray *tracksArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rdio = [AppDelegate sharedRdio];
    self.rdio.delegate = self;
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    

    
    
   // self.imageView.image =
    
    
   }
- (IBAction)button:(id)sender {
        //[self.rdio authorizeFromController:self];
    
    
}

-(void)rdioDidAuthorizeUser:(NSDictionary *)user {
    NSDictionary *params = @{@"type": @"track"};
    [self.rdio callAPIMethod:@"getTopCharts" withParameters:params success:^(NSDictionary *result) {
        //NSLog(@"%@", result);
        self.tracksArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in result) {
            [self.tracksArray addObject:dict];
        }
        NSURL *url = [NSURL URLWithString:[self.tracksArray[3] objectForKey:@"icon400"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        self.track = self.tracksArray[0];
        self.imageView.image = [UIImage imageWithData:data];
        self.trackLabel.text = [self.tracksArray[3] objectForKey:@"artist"];
        

    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
    
    
    
    

    
}

-(void)viewWillAppear:(BOOL)animated {
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
