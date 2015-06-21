//
//  SlideMenuViewController.h
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-20.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideMenuViewControllerDelegate <NSObject>

-(void)insertCategoryList:(NSString *)list;

@end

@interface SlideMenuViewController : UITableViewController

@property (nonatomic, weak) id<SlideMenuViewControllerDelegate> delegate;

@end
