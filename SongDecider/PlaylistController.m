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

@end

@implementation PlaylistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    NSLog(@"playlist key in table view %@", self.playlist);
    
    RdioManager *rdioManager = [RdioManager sharedRdio];
    self.rdio = rdioManager.rdioInstance;
    //self.rdio.delegate = self;
    
    NSDictionary *param = @{@"keys": self.playlist,
                            @"extras": @"tracks"};
    
    [self.rdio callAPIMethod:@"get" withParameters:param success:^(NSDictionary *result) {
        
        NSMutableArray *temp = [NSMutableArray array];
        
        NSString *numTracks = [[result objectForKey:self.playlist] objectForKey:@"length"];
        
        NSDictionary *tracks = [[result objectForKey:self.playlist] objectForKey:@"tracks"];
        
        for (NSDictionary *dictionary in tracks) {
            
            Song *song = [[Song alloc] init];
            
            song.songName = [dictionary objectForKey:@"name"];
            song.albumName = [dictionary objectForKey:@"album"];
            song.artistName = [dictionary objectForKey:@"artist"];
            song.albumImage = [dictionary objectForKey:@"icon400"];
            
            NSLog(@"song %@", song);
            
            [temp addObject:song];
            
        }
        
        self.songData = temp;
        
        self.length = numTracks;
        
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
    
    NSLog(@"song data coount %d", [self.length intValue]);
    
    return [self.length intValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.song = (self.songData)[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaylistCell *cell = (PlaylistCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.iTunesButton.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    
    if (self.selectedIndexPath != nil && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        
        self.selectedIndexPath = nil;
        
        [self.tableView beginUpdates];
        
//        cell.iTunesButton.hidden = YES;
//        [self.tableView bringSubviewToFront:cell.iTunesButton];
        
        [self.tableView endUpdates];
        
    }
    else {
        
        self.selectedIndexPath = indexPath;
        
        [self.tableView beginUpdates];
        
//        cell.iTunesButton.hidden = NO;
        
        [self.tableView endUpdates];

    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndexPath != nil && [self.selectedIndexPath compare:indexPath] == NSOrderedSame) {
        
        return 150;
    }
    
    return 100;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
