//
//  artworkView.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-16.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "ArtworkView.h"

@implementation ArtworkView


-(void)animateLeft {
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(-self.frame.size.width, self.center.y);
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
