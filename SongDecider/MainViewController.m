//
//  MainViewController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "MainViewController.h"
#import "RdioManager.h"
#import <Rdio/Rdio.h>

@interface MainViewController () <RdioDelegate, RDPlayerDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    self.rdio.delegate = self;
    
    
    [self.rdio preparePlayerWithDelegate:self];
    
    [self.rdio.player play:@"gr723"];
    
    
//    self.trackArray = [NSMutableArray array];
    
//    NSDictionary *param = @{@"type": @"stations"};
//    [self.rdio callAPIMethod:@"getHeavyRotation" withParameters:param success:^(NSDictionary *result) {
//        
//        for (NSDictionary *track in result) {
//            
//            [self.trackArray addObject: [track objectForKey:@"key"]];
//        }
    
//        NSLog(@"%@", self.trackArray);
    
    
//        [self.rdio.player.queue add:self.trackArray];
//        
//        [self.rdio.player playFromQueue:0];
        
//    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    

    
    
    
}

-(BOOL)rdioIsPlayingElsewhere {
    
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    NSLog(@"Here HErer %@", self.rdio.player.currentSource);
    NSDictionary *tracks = self.rdio.player.currentSource;
//    NSDictionary *currentTrack = [[tracks objectForKey:@"tracks"]objectAtIndex:self.rdio.player.currentTrackIndex];
//    NSURL *url = [NSURL URLWithString:[currentTrack objectForKey:@"bigIcon"]];
//    NSLog(@"%@",url);
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//        
//
//        NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
//        
//        UIImage *image = [[UIImage alloc] initWithData:imageData];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.albumImage.image = image;
//        });
//  
//    }];
//    
//    [task resume];
    

    
    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
