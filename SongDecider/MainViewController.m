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


@interface MainViewController () <RdioDelegate, RDPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet ArtworkView *artworkView;

@property (weak, nonatomic) IBOutlet UITableView *slideMenuView;





@end

@implementation MainViewController





- (void)viewDidLoad{
       
    self.playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
    self.slideMenuView.delegate = self;
   
    
    [super viewDidLoad];
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




//-(void)nextView {
//    
//    ArtworkContainerController *nextView = [[ArtworkContainerController alloc]init];
//    [nextView awakeFromNib];
//    [self addChildViewController:nextView];
//    
//    [nextView setImage:[self fetchTrackImage]];
//    [self.view addSubview:nextView];
//    self.currentTrack = nextView;
//}




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

#pragma mark - TableView Delegate and Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.slideMenuView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
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
