//
//  FVPostTableViewCell.h
//  FeedViewer
//
//  Created by Gansta_les on 04.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVPost.h"
#import "TTTAttributedLabel.h"

@interface FVPostTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

- (void)refillWithPost:(FVPost *)post;

@end
