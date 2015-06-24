//
//  PlaylistCell.m
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-16.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "PlaylistCell.h"

@interface PlaylistCell ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@end

@implementation PlaylistCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSong:(Song *)song {
    
    _song = song;
    
    [self configure];
}

-(void)configure {
    
    self.albumImageView.image = nil;
    
    self.artistNameLabel.text = self.song.artistName;

//    self.albumNameLabel.text = [NSString stringWithFormat:@"Album: %@", self.song.albumName];
//    self.songNameLabel.text = [NSString stringWithFormat:@"Song: %@", self.song.songName];
    
    self.albumNameLabel.text = self.song.albumName;
    self.songNameLabel.text = self.song.songName;
    
    [self configureImage];
    
    [self modifyCell];
    
}

-(void)configureImage {
    
    self.imageView.image = nil;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:self.song.albumImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.albumImageView.image = image;
                
            });
        }
    }];
    
    [task resume];

}

-(void)modifyCell {
    
    self.backgroundColor = [UIColor blackColor];
    self.albumNameLabel.backgroundColor = [UIColor blackColor];
    self.artistNameLabel.backgroundColor = [UIColor blackColor];
    self.albumNameLabel.backgroundColor = [UIColor blackColor];
    
    self.albumNameLabel.textColor = [UIColor grayColor];
    self.songNameLabel.textColor = [UIColor grayColor];
    self.artistNameLabel.textColor = [UIColor grayColor];
    
    self.iTunesButton.layer.cornerRadius = 12;
    
}


-(void)prepareForReuse {
    [super prepareForReuse];
    self.albumImageView.image = nil;
}

- (IBAction)iTunesButtonPressed:(UIButton *)sender {
    
    NSString *artistString = [self.song.artistName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *songString = [self.song.songName stringByReplacingOccurrencesOfString:@" " withString:@"+"];

//    NSString *stringURL = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", artistString];
//    
//    NSURL *url = [NSURL URLWithString:stringURL];
//    
//    NSURL *urlTest = [NSURL URLWithString:@"twitter://user?screen_name=username"];
//    
//    [[UIApplication sharedApplication] openURL:urlTest];
    
//    NSString* artistTerm = self.artistField.text;  //the artist text.
//    NSString* songTerm = self.songField.text;      //the song text
//    // they both need to be non-zero for this to work right.
    if(artistString.length > 0 && songString.length > 0) {
        
        // this creates the base of the Link Maker url call.
        
        NSString* baseURLString = @"https://itunes.apple.com/search";
        NSString* searchTerm = [NSString stringWithFormat:@"%@ %@", artistString, songString];
        NSString* searchUrlString = [NSString stringWithFormat:@"%@?media=music&entity=song&term=%@&artistTerm=%@&songTerm=%@", baseURLString, searchTerm, artistString, songString];
        
//        searchUrlString = [searchUrlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        searchUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* searchUrl = [NSURL URLWithString:searchUrlString];
        NSLog(@"searchUrl: %@", searchUrl);
        
        NSURLRequest* request = [NSURLRequest requestWithURL:searchUrl];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(error) {
                
                NSLog(@"Error: %@", error);
                
            } else {
                
                NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                NSLog(@">>> result %@", dictData);
                
                NSString *urlString = dictData[@"results"][0][@"trackViewUrl"];
                
                NSLog(@">>>> url %@", urlString);
                
                NSURL *trackURL = [NSURL URLWithString:urlString];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] openURL:trackURL];
                    
                });
            }
            
        }];
    
    [task resume];
        
    }
    
}
@end
