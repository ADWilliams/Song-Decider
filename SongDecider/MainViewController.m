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





@end

@implementation MainViewController

- (IBAction)skip:(id)sender {
    [self.rdio.player next];
}



- (void)viewDidLoad{
       
    self.playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
   
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    self.rdio.delegate = self;
    
    
    
    
    
    [self.rdio preparePlayerWithDelegate:self];

    [self.rdio.player play:@"gr723"];
    
    
    
}

#pragma mark - SwipeGesture

-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    self.playlistKey = [self.playlistKey objectForKey:@"playlistKey"];
    
    if ([sender isEqual: self.swipeLeft]) {
        [self.rdio.player next];
        [self.artworkView animateLeft];
        
    }

    if ([sender isEqual: self.swipeRight]) {
        
        }
        [self.rdio.player next];
        [self.artworkView animateRight];
    }




-(void)nextView {
    CGRect nextViewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    ArtworkView *nextView = [[ArtworkView alloc]initWithFrame:nextViewRect];
    nextView.backgroundColor = [UIColor blackColor];
    
    //[nextView setImage:[self fetchTrackImage]];
    [self.view addSubview:nextView];
    //self.currentTrack = nextView;
}




#pragma mark - Rdio

-(BOOL)rdioIsPlayingElsewhere {
    
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    //NSLog(@"Here HErer %@", self.rdio.player.currentSource);
    //NSDictionary *tracks = self.rdio.player.currentSource;
    NSLog(@"%d", self.rdio.player.currentTrackIndex);
    
    //[self fetchTrackImage];


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
