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
#import "ArtworkContainerController.h"
#import "SlideMenuViewController.h"


@interface MainViewController () <RdioDelegate, RDPlayerDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet ArtworkView *artworkView;

@property (nonatomic, strong) ArtworkContainerController *artworkContainerController;

@property (nonatomic, strong) SlideMenuViewController *slideMenuViewController;
@property (nonatomic, assign) BOOL showSlideMenu;





@end

@implementation MainViewController





- (void)viewDidLoad{
       
    self.playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
    
    [super viewDidLoad];
    
    //Setup Slide Menu Controller
    
    
    
    
    // Do any additional setup after loading the view.

    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    //self.rdio.delegate = self;
    

}


#pragma mark - SwipeGesture

-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
    
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
    
    self.artworkContainerController = [[ArtworkContainerController alloc]init];
    [self.artworkContainerController awakeFromNib];
    [self addChildViewController:self.artworkContainerController];
    
    //[nextView setImage:[self fetchTrackImage]];
    [self.view addSubview:self.artworkContainerController.view];
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



- (IBAction)slideMenuWasPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"Button was pressed");
    
    UIBarButtonItem *button = sender;
    
    switch (button.tag) {
        case 0:
            [self slideBackToOriginalSpot];
            NSLog(@"button tag at 0");
            break;
        case 1:
            [self slideRight];
            NSLog(@"button tag at 1");
            
        default:
            break;
    }
}

-(void)slideRight {
    
    UIView *childView = [self getSlideMenu];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.artworkContainerController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.artworkView.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.slideMenuBarButton.tag = 0;
            NSLog(@"button tag slide right");
        }
        
    }];
}

-(void)slideBackToOriginalSpot {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.artworkContainerController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.artworkView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self resetView];
        
    }];
}

-(void)resetView {
    
    if (self.slideMenuViewController != nil) {
        
        [self.slideMenuViewController.view removeFromSuperview];
        self.slideMenuViewController = nil;
        
        self.slideMenuBarButton.tag = 1;
        self.showSlideMenu = NO;
        NSLog(@"button tag reset");

    }
    
}

- (UIView *)getSlideMenu {
    
    if (self.slideMenuViewController == nil) {
        
        self.slideMenuViewController = [[SlideMenuViewController alloc] init];
        self.slideMenuViewController.view.tag = 2;
        self.slideMenuViewController.delegate = self.artworkContainerController;
        
        [self.view addSubview:self.slideMenuViewController.tableView];
        [self addChildViewController:self.slideMenuViewController];
        [self.slideMenuViewController didMoveToParentViewController:self];
        
        
        self.slideMenuViewController.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
    self.showSlideMenu = YES;
    
    UIView *view = self.slideMenuViewController.tableView;
    
    return view;
    
}


@end
