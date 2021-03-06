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
#import "Playlist.h"


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

@property (nonatomic, strong) NSString *userStatus;

@property (nonatomic, strong) NSString *currentUserKey;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;


@end

@implementation MainViewController

- (void)viewDidLoad{
    
    UIVisualEffectView *vibrancy = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.visualEffect.contentView addSubview:vibrancy];
    
    self.playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [self.playlistKey objectForKey:@"playlistKey"];
    self.slideMenuView.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    //self.rdio.delegate = self;
    
    
    if (!self.playlist) {
        NSDictionary *currentUser = @{@"": @""};
        
        [self.rdio callAPIMethod:@"currentUser" withParameters:currentUser success:^(NSDictionary *result) {
            
            self.currentUserKey = [result objectForKey:@"key"];
            
            NSDictionary *param = @{@"user": self.currentUserKey};
            
            
            [self.rdio callAPIMethod:@"getPlaylists" withParameters:param success:^(NSDictionary *result) {
                
                NSLog(@">>>>>>>>> %@", result);
                
                NSMutableArray *tempArray = [NSMutableArray array];
                
                NSDictionary *ownedDictionary = [result objectForKey:@"owned"];
                
                for (NSDictionary *playlistDictonary in ownedDictionary) {
                    
                    Playlist *playlist = [[Playlist alloc] initWithName:[playlistDictonary objectForKey:@"name"] key:[playlistDictonary objectForKey:@"key"]];
                    
                    [tempArray addObject:playlist];
                    
                }
                
                for (Playlist *playlist in tempArray) {
                    
                    if ([playlist.playlistName isEqualToString:@"Adio Playlist"]) {
                        
                        self.playlist = playlist.playlistKey;
                        
                        [self.playlistKey setObject:self.playlist forKey:@"playlistKey"];
                        
                    }
                    
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.instructionLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.instructionLabel.alpha = 0;
        } completion:nil];
    }];

    self.userStatus = [self.rdio.user objectForKey:@"productAccess"];
    NSLog(@"%@", self.userStatus);
    
    //Initialize Genre from plist
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GenreList" ofType:@"plist"];
    NSDictionary *genreDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *tempArray = [NSArray array];
    
    self.genreArray = [NSMutableArray array];
    
    tempArray = [genreDictionary objectForKey:@"Genre"];
    
    for (NSDictionary *dic in tempArray) {
        
        Genre *genre = [[Genre alloc] initWithName:[dic objectForKey:@"Name"] Key:[dic objectForKey:@"Key"]];
        
        [self.genreArray addObject:genre];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [self.rdio.player stop];
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
        case 0:
            [self closeMenu];
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
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.slidemenuWidthConstraint.constant = 200;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.slideoutMenuButton.tag = 0;
            
        }
        
    }];
    
}

-(void)closeMenu {
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.slidemenuWidthConstraint.constant = 0;
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.slideoutMenuButton.tag = 1;
            
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
            
            ArtworkContainerController * container = (ArtworkContainerController *)[self.childViewControllers firstObject];
            container.switching = YES;
            container.leftSwipeCounter = 0;
            [container animateLeft];
        }
        
    }];
    
}

















@end
