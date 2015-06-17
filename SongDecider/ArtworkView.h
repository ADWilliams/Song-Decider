//
//  artworkView.h
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-16.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtworkView : UIView
@property (nonatomic) UIImageView *imageView;


-(void)animateRight;

-(void)animateLeft;

-(void)setImage: (UIImage *)image;



@end
