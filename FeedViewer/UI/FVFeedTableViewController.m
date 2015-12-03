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

@implementation FVFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[FVObjectManager sharedManager] getFeed:^(FVResponce *responce) {
        NSLog(@"%@", responce.status);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}
@end
