//
//  MainViewController.h
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSString *playlist;

@property (nonatomic, strong) NSUserDefaults *playlistKey;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffect;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

-(void)nextView;

@end

