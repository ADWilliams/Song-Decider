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
#import "GenreCell.h"
#import "Genre.h"


@interface MainViewController () <RdioDelegate, RDPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet ArtworkView *artworkView;

@property (weak, nonatomic) IBOutlet UITableView *slideMenuView;

@property (nonatomic, strong) NSMutableArray *genreArray;

@property (nonatomic, strong) Genre *selectedGenre;

@property (nonatomic, strong) NSString *selectedGenreKey;


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
    
    self.genreArray = [NSMutableArray array];
    
    Genre *genre = [[Genre alloc] initWithName:@"Pop" Key:@"gr723"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Soft Hits" Key:@"sr2885343"];
    [self.genreArray addObject:genre];
      
    genre = [[Genre alloc] initWithName:@"Country" Key:@"gr359"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Rock" Key:@"gr498"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Indie" Key:@"gr58"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Hip Hop" Key:@"gr324"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Electronic" Key:@"gr216"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Reggae" Key:@"gr575"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Dance" Key:@"gr593"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Jazz" Key:@"gr308"];
    [self.genreArray addObject:genre];
    
    genre = [[Genre alloc] initWithName:@"Blues" Key:@"gr475"];
    [self.genreArray addObject:genre];

}

-(void)viewDidDisappear:(BOOL)animated {
    
    [self.rdio.player stop];
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
    
    return self.genreArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GenreCell *cell = [self.slideMenuView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.genre = [self.genreArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedGenre = [self.genreArray objectAtIndex:indexPath.row];
    
    [self slideBackToOriginalSpot];
    
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


- (IBAction)slideoutMenuButtonWasPressed:(UIBarButtonItem *)sender {
    
    NSLog(@"Button was pressed");
    
    UIBarButtonItem *button = sender;
    
    switch (button.tag) {
//        case 0:
//            [self slideBackToOriginalSpot];
//            NSLog(@"button tag at 0");
//            break;
        case 1:
            [self slideRight];
            NSLog(@"button tag at 1");
            
        default:
            break;
    }
    
}

-(void)slideRight {
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.slidemenuWidthConstraint.constant = 200;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.slideoutMenuButton.tag = 0;
            
        }
        
    }];
    
}

-(void)slideBackToOriginalSpot {
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.slidemenuWidthConstraint.constant = 0;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.selectedGenreKey = [self.selectedGenre genreKey];
            
            [self.playlistKey setObject:self.selectedGenreKey forKey:@"selectedGenreKey"];
            
            [self.rdio.player play:[self.selectedGenre genreKey]];
            
            self.slideoutMenuButton.tag = 1;
            
        }
        
    }];
    
}

















@end
