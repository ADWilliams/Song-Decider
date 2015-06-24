//
//  Playlist.h
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-24.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property (nonatomic, strong) NSString *playlistName;

@property (nonatomic, strong) NSString *playlistKey;

- (instancetype)initWithName:(NSString *)name key:(NSString *)key;

@end
