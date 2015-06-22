//
//  Genre.h
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-22.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject

@property (nonatomic, strong) NSString *genreName;

@property (nonatomic, strong) NSString *genreKey;

- (instancetype)initWithName:(NSString *)name Key:(NSString *)key;


@end
