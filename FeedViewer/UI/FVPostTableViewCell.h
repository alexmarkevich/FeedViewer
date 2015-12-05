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

@protocol FVPostTableViewCellDelegate <NSObject>

- (void)likeButtonPressedWithCellIndex:(NSInteger)cellIndex;

@end

@interface FVPostTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (weak, nonatomic) id <FVPostTableViewCellDelegate> delegate;
@property (assign, nonatomic) NSInteger cellIndex;

- (void)refillWithPost:(FVPost *)post;

@end
