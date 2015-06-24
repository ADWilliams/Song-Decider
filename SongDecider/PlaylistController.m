//
//  PlaylistController.m
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import "PlaylistController.h"
#import "RdioManager.h"
#import <Rdio/Rdio.h>
#import "PlaylistCell.h"
#import "Song.h"
#import "DetailViewController.h"

@interface PlaylistController () <RdioDelegate>

@property (nonatomic, strong) NSString *length;

@property (nonatomic, strong) Rdio *rdio;

@property (nonatomic, strong) NSMutableArray *songData;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic) BOOL isFreeUser;

@end

@implementation PlaylistController



- (void)viewDidLoad {
    
    NSUserDefaults *playlistKey = [NSUserDefaults standardUserDefaults];
    self.playlist = [playlistKey objectForKey:@"playlistKey"];
    self.isFreeUser = [playlistKey objectForKey:@"userStatus"];
    
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    NSLog(@"playlist key in table view %@", self.playlist);
    
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    //[self.rdio preparePlayerWithDelegate:nil];

    NSDictionary *param = @{@"keys": self.playlist,
                            @"extras": @"tracks"};
    
    [self.rdio callAPIMethod:@"get" withParameters:param success:^(NSDictionary *result) {
        
        NSMutableArray *temp = [NSMutableArray array];
        
        NSDictionary *tracks = [[result objectForKey:self.playlist] objectForKey:@"tracks"];
        
        for (NSDictionary *dictionary in tracks) {
            
            Song *song = [[Song alloc] init];
            
            song.songName = [dictionary objectForKey:@"name"];
            song.albumName = [dictionary objectForKey:@"album"];
            song.artistName = [dictionary objectForKey:@"artist"];
            song.albumImage = [dictionary objectForKey:@"icon"];
            song.songTrackKey = [dictionary objectForKey:@"key"];
            
            NSLog(@">>>>>>>>>>>>>>>>>song key %@", song.songTrackKey);
            
            BOOL containsSong = NO;
            
            for (Song *playlistSong in temp) {
                
                if ([playlistSong.songTrackKey isEqualToString:song.songTrackKey]) {
                    
                    containsSong = YES;
                    
                }
                
            }
            
            if (!containsSong) {
                
                [temp addObject:song];
                
            }
            
        }
        
        self.songData = temp;
        
        NSLog(@"%lu", (unsigned long)self.songData.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
        });
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPlaylist:(NSString *)playlist {
    
    _playlist = playlist;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSLog(@"song data coount %lu", (unsigned long)[self.songData count]);
    
    return [self.songData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.song = (self.songData)[indexPath.row];
    
    UISwipeGestureRecognizer *swipeToRemove = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeTrack:)];
    swipeToRemove.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeToRemove];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaylistCell *cell = (PlaylistCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.iTunesButton.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    
    if (self.selectedIndexPath != nil && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        
        [self.rdio.player stop];
        
        self.selectedIndexPath = nil;
        
        [self.tableView beginUpdates];
        
        [self.tableView endUpdates];
        
    }
    else {
        
        self.selectedIndexPath = indexPath;
        
        Song *song = [self.songData objectAtIndex:self.selectedIndexPath.row];
        
        NSLog(@"%@", song.songTrackKey);
        
        if (self.isFreeUser != NO) {
            
            [self.rdio.player play:song.songTrackKey];

        }
        
        [self.tableView beginUpdates];
        
        [self.tableView endUpdates];

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndexPath != nil && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        
        return 150;
    }
    
    return 100;
}

-(void)removeTrack:(UISwipeGestureRecognizer *)sender {
    
    CGPoint pt = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pt];
    
    Song *song = [self.songData objectAtIndex:indexPath.row];
    
    NSDictionary *param = @{@"playlist": self.playlist,
                            @"index": [NSString stringWithFormat:@"%lu", (unsigned long)[self.songData indexOfObject:song]],
                            @"count": @"1",
                            @"tracks": song.songTrackKey};
    
    [self.rdio callAPIMethod:@"removeFromPlaylist" withParameters:param success:^(NSDictionary *result) {
        
        NSLog(@">>>>>> Succeed %@", result);
        
        self.playlist = [result objectForKey:@"key"];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    [self.songData removeObject:song];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//
//    if ([[segue identifier] isEqualToString:@"showPlaylistDetail"]) {
//        
//        DetailViewController *playlistDetailVC = segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Song *song = (self.songData)[indexPath.row];
//        
//    }
//    
//
//}
@end
