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

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *checkedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllCommentsButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentsLabel;
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
    self.checkedInLabel.delegate = self;
    self.postTextLabel.delegate = self;
    self.commentsLabel.delegate = self;
    UIColor *linksColor = [UIColor colorWithRed:41/255.0 green:101/255.0 blue:160/255.0 alpha:1];
    self.checkedInLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: linksColor};
    self.postTextLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: linksColor};
    self.commentsLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: linksColor};
    self.postTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.commentsLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
}
- (void)refillWithPost:(FVPost *)post {
    
    NSMutableAttributedString *checkedInLabelText = [[NSMutableAttributedString alloc] initWithString:post.author.nickname attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    NSRange nicknameRange = NSMakeRange(0, post.author.nickname.length);
    NSRange placeNameRange;
    if (post.place.name) {
        [checkedInLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@" checked in at " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
        placeNameRange = NSMakeRange(checkedInLabelText.length, post.place.name.length);
        [checkedInLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:post.place.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}]];
    }
    self.checkedInLabel.text = checkedInLabelText;
    
    [self.checkedInLabel addLinkToURL:[NSURL URLWithString:post.author.nickname] withRange:nicknameRange];
    if (post.place.name) {
        [self.checkedInLabel addLinkToURL:[NSURL URLWithString:post.place.name] withRange:placeNameRange];
    }
    
    self.timeLabel.text = [post.ts stringValue];
    self.distanceLabel.text = [post.distance stringValue];
    self.locationLabel.text = post.place.land;
    
    self.authorImageView.image = nil;
    if (post.author.avatarURLString) {
        [self.authorImageView setImageWithURL:[NSURL URLWithString:post.author.avatarURLString]];
    }
    
    self.postTextLabel.text = post.text;
    [self makeHashtagsAndMentionsClicableInLabel:self.postTextLabel];
    
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
    
    NSMutableArray *nicknameRangesArray = [NSMutableArray new];
    NSMutableString *comments = [NSMutableString new];
    for (FVComment *comment in post.comments) {
        [nicknameRangesArray addObject:[NSValue valueWithRange:NSMakeRange(comments.length, comment.user.nickname.length)]];
        [comments appendFormat:@"%@ %@\n",comment.user.nickname, comment.text];
    }
    self.commentsLabel.text = comments;
    for (NSValue *value in nicknameRangesArray) {
        [self.commentsLabel addLinkToURL:[NSURL URLWithString:[comments substringWithRange:[value rangeValue]]] withRange:[value rangeValue]];
    }
    [self makeHashtagsAndMentionsClicableInLabel:self.commentsLabel];
}

- (void)makeHashtagsAndMentionsClicableInLabel:(TTTAttributedLabel *)label {
    NSString *text = label.text;
    if (text.length) {
        NSRegularExpression *mentionExpression = [NSRegularExpression regularExpressionWithPattern:@"[#@](\\w+)" options:NO error:nil];
        NSArray *matches = [mentionExpression matchesInString:text
                                                      options:0
                                                        range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSString *mentionString = [text substringWithRange:[match range]];
            [label addLinkToURL:[NSURL URLWithString:mentionString] withRange:[match range]];
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"%@", url.description);
}

@end
