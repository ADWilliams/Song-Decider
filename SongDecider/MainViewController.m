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
#import "ArtworkView.h"

@interface MainViewController () <RdioDelegate, RDPlayerDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet ArtworkView *artworkView;
@end

@implementation MainViewController

- (IBAction)skip:(id)sender {
    [self.rdio.player next];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    self.rdio.delegate = self;
    
    
    [self.rdio preparePlayerWithDelegate:self];
    
    [self.rdio.player play:@"gr723"];
    
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
    
}



-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    if ([sender isEqual: self.swipeLeft]) {
        [self.rdio.player next];
        [self.artworkView animateLeft];
        
    }
    
    if ([sender isEqual: self.swipeRight]) {
        [self.rdio.player next];
    }
}


#pragma mark - Rdio

-(BOOL)rdioIsPlayingElsewhere {
    
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    //NSLog(@"Here HErer %@", self.rdio.player.currentSource);
    //NSDictionary *tracks = self.rdio.player.currentSource;
    NSLog(@"%d", self.rdio.player.currentTrackIndex);
    
    
        NSDictionary *currentTrack = [self.rdio.player valueForKey:@"currentTrackInfo_"];
        NSString *urlStr = [currentTrack valueForKey:@"icon400"];
        NSString *str = [urlStr stringByReplacingOccurrencesOfString:@"400" withString:@"600"];
        NSURL *url =[NSURL URLWithString:str ];
        NSLog(@"%@",url);
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumImage.image = image;
            });
            
        }];
        
        [task resume];

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
