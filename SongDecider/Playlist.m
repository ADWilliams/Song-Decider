//
//  Playlist.m
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-24.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (instancetype)initWithName:(NSString *)name key:(NSString *)key
{
    self = [super init];
    if (self) {
        
        _playlistKey = key;
        _playlistName = name;
        
    }
    return self;
}

@end
