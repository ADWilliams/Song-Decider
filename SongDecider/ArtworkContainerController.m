//
//  ArtworkContainerController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-17.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "ArtworkContainerController.h"
#import "MainViewController.h"
#import "RdioManager.h"

@interface ArtworkContainerController () <RDPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

@property (nonatomic)MainViewController *mainView;

@property (nonatomic) Rdio *rdio;

@property (nonatomic) UIImage *nextImage;

@property (nonatomic) NSArray *genres;

@property (nonatomic, strong) NSString *selectedGenreKey;



@end

@implementation ArtworkContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.genres = @[ @"gr359",@"sr2885343",@"gr498",@"gr58",@"gr324",@"gr216",@"gr575",@"gr593", @"gr443",@"gr308",@"gr723",@"gr227", @"gr471",@"gr14",@"gr381",@"gr201", @"gr122",@"gr538",@"gr593",@"gr155",@"gr489",@"gr560",@"gr71", @"gr205", @"gr515",@"gr493",@"gr293",@"gr53",@"gr312",@"gr1",@"gr155", @"gr342", @"gr105",@"gr385", @"gr339"];
    
    self.leftSwipeCounter = 0;
    self.switching = NO;
    
    RdioManager *manager = [RdioManager sharedRdio];
    self.rdio = manager.rdioInstance;
    
    [self.rdio preparePlayerWithDelegate:self];
    
    self.artworkImageView.image = nil;
    
    int rand = arc4random() % (self.genres.count -1);

    [self.rdio.player play:self.genres[rand]];
    
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.switching = YES;
    self.nextImage = nil;
    
    self.selectedGenreKey = [self.mainView.playlistKey objectForKey:@"selectedGenreKey"];
    
    NSLog(@"%@", self.selectedGenreKey);
    
    if (self.selectedGenreKey != nil) {
        
        [self.rdio.player play:self.selectedGenreKey];
        
    }
    else {
        int rand = arc4random() % (self.genres.count -1);

        [self.rdio.player play:self.genres[rand]];
        
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.mainView = (MainViewController *)self.parentViewController;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeHandler: (UISwipeGestureRecognizer *)sender {
    if ([sender isEqual:self.swipeLeft]) {
        self.leftSwipeCounter += 1;
        
        if (self.leftSwipeCounter > 4) {
            self.leftSwipeCounter = 0;
            NSLog(@"genre switch");
            
            self.nextImage = nil;
            
            [self animateLeft];
            
            int rand = arc4random() % (self.genres.count -1);
            NSLog(@"%d", rand);
            [self.rdio.player play:self.genres[rand]];
            
            self.switching = YES;
            
        }
        else {
            NSLog(@"Swiped Left");
            [self animateLeft];
            [self.rdio.player next];
        }
    }
    
    if ([sender isEqual: self.swipeRight]) {
        self.switching = YES;
        
        self.leftSwipeCounter = 0;
        self.nextImage = nil;
        [self addToPlaylist];
        
        NSString *stationKey = [[ [self.rdio.player valueForKey:@"currentTrackInfo_" ]objectForKey:@"radio" ]valueForKey:@"key"];
        NSDictionary *params = @{@"keys":stationKey};
        [self.rdio callAPIMethod:@"get" withParameters:params success:^(NSDictionary *result) {
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (NSString *string in [result objectForKey:stationKey]) {
                if ([string isEqualToString:@"icon400"]) {
                    [array addObject:string];
                }
                
                
            }
            
            NSString *urlStr = [array firstObject];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest *request = [ NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                NSData *imageData = [NSData dataWithContentsOfURL:location];
                UIImage *image = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.artworkImageView.image = image;
                });
            }];
            [task resume];
            ;
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        [self.rdio.player play:stationKey];
        
        
        [self animateRight];
        
        
    }
}

-(void)animateLeft {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(-self.view.frame.size.width, self.view.center.y);
        self.view.transform = CGAffineTransformMakeRotation(-0.4);
        
    } completion:^(BOOL finished) {
        
        self.view.center = CGPointMake(self.mainView.view.center.x, -(self.view.frame.size.height));
        self.view.transform = CGAffineTransformMakeRotation(0);
        
        self.artworkImageView.image = nil;
        
        if (self.switching == NO) {
            
            self.artworkImageView.image = self.nextImage;
            self.mainView.bgImage.image = self.artworkImageView.image;
            
            if (self.nextImage == nil) {
                self.artworkImageView.image = nil;
            }
            
            [self dropInAnimation];
            self.nextImage = nil;
        }
        
        
    }];
}


-(void)animateRight {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width * 2 , self.view.center.y);
        self.view.transform = CGAffineTransformMakeRotation(0.4);
        
    }completion:^(BOOL finished) {
        
        self.view.center = CGPointMake(self.mainView.view.center.x, -self.view.frame.size.height);
        self.view.transform = CGAffineTransformMakeRotation(0);
        
        self.artworkImageView.image = nil;
        [self dropInAnimation];
        
        self.mainView.bgImage.image = self.artworkImageView.image;
        
        self.nextImage = nil;
        
        
    }];
}


-(void)dropInAnimation {
    
    self.switching = NO;
    
    
    if (self.artworkImageView.image != nil) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.frame = self.mainView.view.frame;
            //[self.view layoutIfNeeded];
            
        } completion:nil];
    }
    
    else {
        [self fetchTrackImage];
        [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.frame = self.mainView.view.frame;
            //[self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.mainView.bgImage.image = self.artworkImageView.image;
            
        }];
    }
    
}



#pragma mark - Rdio Delegate Methods




-(BOOL)rdioIsPlayingElsewhere{
    return NO;
}



-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    //[self fetchTrackImage];
    
    
    if (oldState == RDPlayerStateStopped && newState == RDPlayerStateBuffering) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL freeUser = (BOOL)[defaults valueForKey:@"userStatus"];
        
        if (freeUser == YES) {
            [self animateLeft];
        }
    }

    
    if (newState == RDPlayerStatePlaying) {

        
        
        if (self.switching == YES) {
            [self dropInAnimation];
            
        }
        
        if (self.artworkImageView.image == nil) {
            [self dropInAnimation];
        }
        
        if (self.nextImage == nil) {
            NSArray *trackKeys = [self.rdio.player valueForKey:@"trackKeys_"];
            if (trackKeys.count > 1 ) {
                [self fetchNextImage];
            }
        }
    }
    
    
}

-(void) addToPlaylist {
    if (self.mainView.playlist ==  nil) {
        
        NSDictionary *param = @{@"name": @"Adio Playlist",
                                @"description": @"mobile playlist",
                                @"tracks": self.rdio.player.currentTrack};
        
        [self.rdio callAPIMethod:@"createPlaylist" withParameters:param success:^(NSDictionary *result) {
            
            NSLog(@"%@", result);
            
            self.mainView.playlist = [result objectForKey:@"key"];
            
            [self.mainView.playlistKey setObject:self.mainView.playlist forKey:@"playlistKey"];
            
            NSLog(@"Data Saved");
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
    }
    else {
        
        NSLog(@"key have been retrieved !!! %@", self.mainView.playlist);
        
        NSDictionary *param = @{@"playlist": self.mainView.playlist,
                                @"tracks": self.rdio.player.currentTrack};
        
        [self.rdio callAPIMethod:@"addToPlaylist" withParameters:param success:^(NSDictionary *result) {
            
            NSLog(@"current track number %@", self.rdio.player.currentTrack);
            
            NSLog(@"playlist returned %@", result);
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }
    
}


-(UIImage *)fetchTrackImage {
    
    __block UIImage *fetchedImage = [[UIImage alloc]init];
    
    NSDictionary *currentTrack = [self.rdio.player valueForKey:@"currentTrackInfo_"];
    NSString *urlStr = [currentTrack valueForKey:@"icon400"];
    //NSString *str = [urlStr stringByReplacingOccurrencesOfString:@"400" withString:@"600"];
    NSURL *url =[NSURL URLWithString:urlStr ];
    NSLog(@"%@",url);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
        
        fetchedImage = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.artworkImageView.image = fetchedImage;
            
            
        });
    }];
    
    [task resume];
    
    return fetchedImage;
    
}


-(void)fetchNextImage {
    int nextTrackIndex = (int)[[self.rdio.player valueForKey:@"nextTrackIndex_"] integerValue];
    NSString *nextTrackKey =[[self.rdio.player valueForKey:@"trackKeys_"]objectAtIndex:nextTrackIndex];
    
    
    NSDictionary *params = @{@"keys":nextTrackKey};
    [self.rdio callAPIMethod:@"get" withParameters:params success:^(NSDictionary *result) {
        NSDictionary *nextTrack = [result objectForKey:nextTrackKey];
        
        NSURL *imageURL = [NSURL URLWithString:[nextTrack valueForKey:@"icon400"]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.nextImage = image;
            });
        }];
        
        [task resume];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
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
