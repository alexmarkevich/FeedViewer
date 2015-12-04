//
//  FVPostTableViewCell.m
//  FeedViewer
//
//  Created by Gansta_les on 04.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import "FVPostTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FVComment.h"

@interface FVPostTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *checkedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllCommentsButton;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenPostImageViewAndCommentLabelConstraint;

@end

@implementation FVPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.width / 2;
}

- (void)refillWithPost:(FVPost *)post {
    self.checkedInLabel.text = post.author.nickname;
    self.timeLabel.text = [post.ts stringValue];
    self.distanceLabel.text = [post.distance stringValue];
    self.locationLabel.text = post.place.name;
    
    self.authorImageView.image = nil;
    if (post.author.avatarURLString) {
        [self.authorImageView setImageWithURL:[NSURL URLWithString:post.author.avatarURLString]];
    }
    
    self.postTextLabel.text = post.text;
    
    self.postImageView.image = nil;
    if (post.photoUrlString) {
        self.postImageViewHeightConstraint.constant = self.postImageView.frame.size.width;
        [self.postImageView setImageWithURL:[NSURL URLWithString:post.photoUrlString]];
    }
    else {
        self.postImageViewHeightConstraint.constant = 0;
    }

    if ([post.likes integerValue]) {
        self.likesLabel.text = [post.likes stringValue];
    }
    else {
        self.likesLabel.text = nil;
    }
    
    if ([post.commentsNumber integerValue] > 2) {
        [self.showAllCommentsButton setTitle:[NSString stringWithFormat:@"View all %@ comments", post.commentsNumber] forState:UIControlStateNormal];
        self.showAllCommentsButton.hidden = NO;
    }
    else {
        self.showAllCommentsButton.hidden = YES;
    }
    
    if (![post.likes integerValue] & ([post.commentsNumber integerValue] <= 2)) {
        self.spaceBetweenPostImageViewAndCommentLabelConstraint.constant = 0;
    }
    else {
        self.spaceBetweenPostImageViewAndCommentLabelConstraint.constant = 30;
    }
    
    NSMutableString *comments = [NSMutableString new];
    for (FVComment *comment in post.comments) {
        [comments appendFormat:@"%@\n", comment.text];
    }
    self.commentsLabel.text = comments;
}

@end
