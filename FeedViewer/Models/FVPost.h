//
//  FVPost.h
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FVPlace.h"
#import "FVUser.h"

@interface FVPost : NSObject

@property (assign, nonatomic) BOOL isCheckedIn;
@property (strong, nonatomic) NSString *photoUrlString;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *ts;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) FVPlace *place;
@property (strong, nonatomic) FVUser *author;

@end
