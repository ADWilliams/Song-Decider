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
    
//    self.itunesButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.itunesButton setTitle:@"iTunes" forState:UIControlStateNormal];
//    [self.itunesButton setBackgroundColor:[UIColor blackColor]];
//    [self.itunesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.itunesButton addTarget:self action:@selector(openItunes:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.itunesButton];
    

    // Configure the view for the selected state
}

-(void)setSong:(Song *)song {
    
    _song = song;
    
    [self configure];
}

-(void)configure {
    
    self.albumNameLabel.text = self.song.albumName;
    self.artistNameLabel.text = self.song.artistName;
    self.songNameLabel.text = self.song.songName;
    [self configureImage];
    
    [self modifyCell];
    
}

-(void)configureImage {
    
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
    self.songNameLabel.backgroundColor = [UIColor blackColor];
    
    self.albumNameLabel.textColor = [UIColor grayColor];
    self.artistNameLabel.textColor = [UIColor grayColor];
    self.songNameLabel.textColor = [UIColor grayColor];
    
}










- (IBAction)iTunesButtonPressed:(UIButton *)sender {
}
@end
