//
//  Song.m
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "Song.h"

@implementation Song

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        [coder encodeObject:self.songName forKey:@"SongName"];
        [coder encodeObject:self.artistName forKey:@"ArtistName"];
        [coder encodeObject:self.albumName forKey:@"AlbumName"];
        [coder encodeObject:self.albumImage forKey:@"AlbumImageLink"];
        [coder encodeObject:self.songTrackKey forKey:@"SongTrackKey"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    
    
    
    
}


@end
