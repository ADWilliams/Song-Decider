//
//  Genre.m
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-22.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "Genre.h"

@implementation Genre

- (instancetype)initWithName:name Key:key
{
    self = [super init];
    if (self) {
        
        _genreName = name;
        _genreKey = key;
    }
    return self;
}

@end
