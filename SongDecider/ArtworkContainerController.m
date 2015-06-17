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

@interface ArtworkContainerController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;

@property (nonatomic) UISwipeGestureRecognizer *swipeRight;

//@property (nonatomic)MainViewController *mainView;

@property (nonatomic) Rdio *rdio;

@end

@implementation ArtworkContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    RdioManager *manager = [RdioManager sharedRdio];
    self.rdio = manager.rdioInstance;
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeLeft];
    

    
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
        [self animateRight];
        [self.rdio.player next];
    }
}


-(void)animateLeft {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(-self.view.frame.size.width, self.view.center.y);
        
    }];
}


-(void)animateRight {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width * 2 , self.view.center.y);
    }];
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
            self.artworkImageView.image = fetchedImage;
            
        });
    }];
    
    [task resume];
    
    return fetchedImage;
    
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
