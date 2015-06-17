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
@property (nonatomic, strong) NSString *playlistKey;
@property (nonatomic) ArtworkView *currentTrack;


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

#pragma mark - SwipeGesture

-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    NSUserDefaults *playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlistKey = [playlistKey objectForKey:@"playlistKey"];
    
    if ([sender isEqual: self.swipeLeft]) {
        [self.rdio.player next];
        [self.artworkView animateLeft];
        
    }

    if ([sender isEqual: self.swipeRight]) {
        
        if (self.playlistKey ==  nil) {
            
            NSDictionary *param = @{@"name": @"mobile playlist",
                                    @"description": @"mobile playlist",
                                    @"tracks": self.rdio.player.currentTrack};
            
            [self.rdio callAPIMethod:@"createPlaylist" withParameters:param success:^(NSDictionary *result) {
                
                NSLog(@"%@", result);
                
                self.playlistKey = [result objectForKey:@"key"];
                
                [playlistKey setObject:self.playlistKey forKey:@"playlistKey"];
                
                NSLog(@"Data Saved");

                
            } failure:^(NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
        }
        else {
            
            NSLog(@"key have been retrieved !!! %@", self.playlistKey);
            
            NSDictionary *param = @{@"playlist": self.playlistKey,
                                    @"tracks": self.rdio.player.currentTrack};
            
            [self.rdio callAPIMethod:@"addToPlaylist" withParameters:param success:^(NSDictionary *result) {
                
                NSLog(@"current track number %@", self.rdio.player.currentTrack);
                
                NSLog(@"playlist returned %@", result);
                
            } failure:^(NSError *error) {
                
                NSLog(@"%@", error);
                
            }];
          
        }
        [self.rdio.player next];
        [self.artworkView animateRight];
    }

}


-(void)nextView {
    CGRect nextViewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    ArtworkView *nextView = [[ArtworkView alloc]initWithFrame:nextViewRect];
    nextView.backgroundColor = [UIColor blackColor];
    
    [nextView setImage:[self fetchTrackImage]];
    [self.view addSubview:nextView];
    self.currentTrack = nextView;
}

#pragma mark - Rdio

-(BOOL)rdioIsPlayingElsewhere {
    
    return NO;
}

-(void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    //NSLog(@"Here HErer %@", self.rdio.player.currentSource);
    //NSDictionary *tracks = self.rdio.player.currentSource;
    NSLog(@"%d", self.rdio.player.currentTrackIndex);
    
    [self fetchTrackImage];


    }
    

    
    
-(UIImage *)fetchTrackImage {
    
    __block UIImage *fetchedImage = [[UIImage alloc]init];

    NSDictionary *currentTrack = [self.rdio.player valueForKey:@"currentTrackInfo_"];
    NSString *urlStr = [currentTrack valueForKey:@"icon400"];
    NSString *str = [urlStr stringByReplacingOccurrencesOfString:@"400" withString:@"600"];
    NSURL *url =[NSURL URLWithString:str ];
    NSLog(@"%@",url);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:location];
        
        fetchedImage = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.albumImage.image = fetchedImage;
            [self.currentTrack setImage:fetchedImage];
            
        });
    }];
    
    [task resume];
    
    return fetchedImage;
    
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
