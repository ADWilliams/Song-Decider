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



@end

@implementation ArtworkContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    RdioManager *manager = [RdioManager sharedRdio];
    self.rdio = manager.rdioInstance;
    
    [self.rdio preparePlayerWithDelegate:self];
    
    self.mainView.playlistKey = [NSUserDefaults standardUserDefaults];
    self.mainView.playlist = [self.mainView.playlistKey objectForKey:@"playlistKey"];
    
    NSLog(@"playlist key %@", self.mainView.playlistKey);
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
    
    
    
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
        [self animateLeft];
        [self.rdio.player next];
    }
    
    if ([sender isEqual: self.swipeRight]) {
        
        if (self.mainView.playlist ==  nil) {
            
            NSDictionary *param = @{@"name": @"mobile playlist",
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
        [self animateRight];
        [self.rdio.player next];
    }
}

-(void)animateLeft {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(-self.view.frame.size.width, self.view.center.y);
        
    } completion:^(BOOL finished) {
        
        self.view.center = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height);
        self.artworkImageView.image = nil;
        self.artworkImageView.image = self.nextImage;
        self.nextImage = nil;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = self.mainView.view.frame;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finnished) {
           
        }];
        
    }];
}


-(void)animateRight {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width * 2 , self.view.center.y);
        
    }completion:^(BOOL finished) {
        
        self.view.center = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height);
        self.artworkImageView.image = nil;
        self.artworkImageView.image = self.nextImage;
        self.nextImage = nil;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = self.mainView.view.frame;
            [self.view layoutIfNeeded];
        }];
        
    }];
}




#pragma mark - Rdio Delegate Methods

-(BOOL)rdioIsPlayingElsewhere{
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    //[self fetchTrackImage];
    
    
    
    
    if (oldState == RDPlayerStateInitializing && newState == RDPlayerStateBuffering) {
        [self fetchTrackImage];
        
    }
    if (newState == RDPlayerStatePlaying) {
        [self fetchNextImage];
        
        if (self.nextImage == nil) {
            [self fetchTrackImage];
        }
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
            //self.albumImage.image = fetchedImage;
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
