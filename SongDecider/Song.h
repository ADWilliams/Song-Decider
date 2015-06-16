//
//  Song.h
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Song : NSObject

@property (nonatomic, strong) NSString *songName;

@property (nonatomic, strong) NSString *songArtist;

@property (nonatomic, strong) NSString *songAlbum;

@property (nonatomic, strong) UIImage *albumImage;


@end
