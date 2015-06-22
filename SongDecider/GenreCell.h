//
//  GenreCell.h
//  SongDecider
//
//  Created by Ian Tsai on 2015-06-22.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@interface GenreCell : UITableViewCell

@property (nonatomic, strong) Genre *genre;

@property (weak, nonatomic) IBOutlet UILabel *genreLabel;



@end
