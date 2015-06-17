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
#import "PlaylistController.h"

@interface MainViewController () <RdioDelegate, RDPlayerDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet ArtworkView *artworkView;

@property (nonatomic, strong) NSString *playlist;

@property (nonatomic, strong) NSUserDefaults *playlistKey;


@end

@implementation MainViewController

- (IBAction)skip:(id)sender {
    [self.rdio.player next];
}



- (void)viewDidLoad {

    self.playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    self.rdio.delegate = self;
    
    
    
    NSLog(@"playlist key %@", self.playlistKey);
    
    
    [self.rdio preparePlayerWithDelegate:self];

    [self.rdio.player play:@"gr723"];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
    
}

#pragma mark - SwipeGesture

-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    self.playlistKey = [self.playlistKey objectForKey:@"playlistKey"];
    
    if ([sender isEqual: self.swipeLeft]) {
        [self.rdio.player next];
        [self.artworkView animateLeft];
        
    }

    if ([sender isEqual: self.swipeRight]) {
        
        if (self.playlist ==  nil) {
            
            NSDictionary *param = @{@"name": @"mobile playlist",
                                    @"description": @"mobile playlist",
                                    @"tracks": self.rdio.player.currentTrack};
            
            [self.rdio callAPIMethod:@"createPlaylist" withParameters:param success:^(NSDictionary *result) {
                
                NSLog(@"%@", result);
                
                self.playlist = [result objectForKey:@"key"];
                
                [self.playlistKey setObject:self.playlist forKey:@"playlistKey"];
                
                NSLog(@"Data Saved");

                
            } failure:^(NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
        }
        else {
            
            NSLog(@"key have been retrieved !!! %@", self.playlist);
            
            NSDictionary *param = @{@"playlist": self.playlist,
                                    @"tracks": self.rdio.player.currentTrack};
            
            [self.rdio callAPIMethod:@"addToPlaylist" withParameters:param success:^(NSDictionary *result) {
                
                NSLog(@"current track number %@", self.rdio.player.currentTrack);
                
                NSLog(@"playlist returned %@", result);
                
            } failure:^(NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
          
        }

//        [self.rdio.player next];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"playlistSegue"]) {
        
        PlaylistController *playlistVC = segue.destinationViewController;
        playlistVC.playlist = self.playlist;
        
    }
    
}


@end
