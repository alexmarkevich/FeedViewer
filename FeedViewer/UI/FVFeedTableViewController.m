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

@interface FVFeedTableViewController()

@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isFeedLoading;
@property (assign, nonatomic) BOOL isFeedLoaded;

@end

@implementation FVFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"BlendaScript" size:30],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    self.navigationItem.title = @"Vicinity";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] init];
    UIImage *leftBarButtonImage = [[UIImage imageNamed:@"leftBarButtonIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButton setImage:leftBarButtonImage];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] init];
    UIImage *rightBarButtonImage = [[UIImage imageNamed:@"rightBarButtonIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightBarButton setImage:rightBarButtonImage];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.posts = [NSMutableArray new];
    self.tableView.estimatedRowHeight = 200.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(updateFeed)
                  forControlEvents:UIControlEventValueChanged];
    [self updateFeed];
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
    cell.delegate = self;
    cell.cellIndex = indexPath.row;

    if (((self.posts.count - indexPath.row) < 10) & !self.isFeedLoading & !self.isFeedLoaded) {
        [self loadNextFeedPart];
    }
    
    return cell;
}

- (void)updateFeed {
    self.isFeedLoading = YES;
    __weak typeof(self) weakSelf = self;
    [[FVObjectManager sharedManager] getFeedWithOffset:0 limit:20 success:^(FVResponce *responce) {
        NSLog(@"%@", responce.status);
        [weakSelf.posts removeAllObjects];
        [weakSelf.posts addObjectsFromArray:responce.data];
        [weakSelf.tableView reloadData];
        [weakSelf.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.1];
        weakSelf.isFeedLoading = NO;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.isFeedLoading = NO;
    }];
}

- (void)loadNextFeedPart {
    self.isFeedLoading = YES;
    __weak typeof(self) weakSelf = self;
    [[FVObjectManager sharedManager] getFeedWithOffset:(self.posts.count + 1) limit:10 success:^(FVResponce *responce) {
        NSLog(@"%@", responce.status);
        weakSelf.isFeedLoading = NO;
        if (responce.data.count) {
            [weakSelf.posts addObjectsFromArray:responce.data];
            [weakSelf.tableView reloadData];
            if (responce.data.count < 10) {
                weakSelf.isFeedLoaded = YES;
            }
        }
        else {
            weakSelf.isFeedLoaded = YES;
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        weakSelf.isFeedLoading = NO;
    }];
}

- (void)likeButtonPressedWithCellIndex:(NSInteger)cellIndex {
    FVPost *post = self.posts[cellIndex];
    post.likes = [NSNumber numberWithInteger:[post.likes integerValue] + (post.isLiked ? -1 : 1)];
    post.isLiked = !post.isLiked;
    [self.posts removeObjectAtIndex:cellIndex];
    [self.posts insertObject:post atIndex:cellIndex];
    [self.tableView reloadData];
}

@end
