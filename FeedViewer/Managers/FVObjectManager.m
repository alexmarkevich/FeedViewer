//
//  FVObjectManager.m
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import "FVObjectManager.h"
#import "FVMappingProvider.h"

@implementation FVObjectManager

+ (instancetype)sharedManager {
    static FVObjectManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://45.55.15.229:3001"];
        
        sharedManager = [self managerWithBaseURL:url];
        sharedManager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        [sharedManager setupResponseDescriptors];
        
        [sharedManager.HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"566093410c5a8cd0485fb4c7"]];
    });
    
    return sharedManager;
}

- (void)getFeedWithOffset:(NSInteger)offset limit:(NSInteger)limit success:(void (^)(FVResponce *))success failure:(void (^)(RKObjectRequestOperation *, NSError *))failure {
    
    [self cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@"/api/posts"];
    
    NSDictionary *parameters = @{@"distance" : @"16093.44005584717",
                                  @"lat" : @"53.911641",
                                  @"limit" : [NSNumber numberWithInteger:limit],
                                  @"lon" : @"27.595961",
                                  @"offset" : [NSNumber numberWithInteger:offset]};
    
    [self getObjectsAtPath:@"/api/posts" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            FVResponce *responce = (FVResponce *)[mappingResult.array firstObject];
            success(responce);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void) setupResponseDescriptors {
    RKResponseDescriptor *authenticatedUserResponseDescriptors = [RKResponseDescriptor responseDescriptorWithMapping:[FVMappingProvider responceMapping] method:RKRequestMethodGET pathPattern:@"/api/posts" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:authenticatedUserResponseDescriptors];
}

@end
