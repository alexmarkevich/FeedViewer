//
//  FVObjectManager.h
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import "RKObjectManager.h"
#import "FVResponce.h"

@interface FVObjectManager : RKObjectManager

+ (instancetype)sharedManager;

- (void)getFeed:(void (^)(FVResponce *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure;

@end
