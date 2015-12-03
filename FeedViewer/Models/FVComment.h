//
//  FVComment.h
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FVUser.h"

@interface FVComment : NSObject

@property (strong, nonatomic) FVUser *user;
@property (strong, nonatomic) NSString *text;

@end
