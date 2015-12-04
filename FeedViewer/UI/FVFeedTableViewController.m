//
//  FVFeedTableViewController.m
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import "FVFeedTableViewController.h"
#import "FVObjectManager.h"
#import "FVResponce.h"
#import "FVPost.h"
#import "FVPostTableViewCell.h"

@interface FVFeedTableViewController()

@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation FVFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.posts = [NSMutableArray new];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [[FVObjectManager sharedManager] getFeed:^(FVResponce *responce) {
        NSLog(@"%@", responce.status);
        [self.posts addObjectsFromArray:responce.data];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FVPostTableViewCell";
    FVPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FVPostTableViewCell alloc] init];
    }
    FVPost *post = self.posts[indexPath.row];
    [cell refillWithPost:post];
    return cell;
}

@end
