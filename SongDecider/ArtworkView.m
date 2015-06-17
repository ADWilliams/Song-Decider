//
//  artworkView.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-16.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "ArtworkView.h"

@interface ArtworkView () <UIGestureRecognizerDelegate>

@property (nonatomic)UISwipeGestureRecognizer *swipeRight;
@property (nonatomic)UISwipeGestureRecognizer *swipeLeft;

@end

@implementation ArtworkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints: NO];

        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageView setUserInteractionEnabled: NO];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setUserInteractionEnabled:YES];
        
        [self addSubview:self.imageView];
        
        
    }
    
    
//    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self.imageView action:@selector(swipeHandler:)];
//    
//    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self.imageView action:@selector(swipeHandler:)];
//    
//    
//    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    
//    [self.imageView addGestureRecognizer:self.swipeRight];
//    [self.imageView addGestureRecognizer:self.swipeLeft];

    
    return self;
}



-(void) swipeHandler: (UIGestureRecognizer *)sender {
    
    if ([sender isEqual: self.swipeLeft]) {
        //[self.rdio.player next];
        [self animateLeft];
        
    }
    
    if ([sender isEqual: self.swipeRight]) {
        //[self.rdio.player next];
        [self animateRight];
    }
    
    
    
    
}


-(void)setImage: (UIImage *)image {
    self.imageView.image = image;
}

-(void)setupView {
   
    
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
