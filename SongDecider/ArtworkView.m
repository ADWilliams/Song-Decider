//
//  artworkView.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-16.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "ArtworkView.h"

@interface ArtworkView ()

@property (nonatomic) UIImageView *imageView;

@end

@implementation ArtworkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setImage: (UIImage *)image {
    self.imageView.image = image;
}

-(void)setupView {
    self.imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:self.imageView];
    
}

-(void)animateLeft {
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(-self.frame.size.width, self.center.y);
    }];
}

-(void)animateRight {
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(self.frame.size.width * 2 , self.center.y);
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
