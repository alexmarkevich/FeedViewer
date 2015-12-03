//
//  FVMappingProvider.m
//  FeedViewer
//
//  Created by Gansta_les on 03.12.15.
//  Copyright (c) 2015 Gansta_les. All rights reserved.
//

#import "FVMappingProvider.h"
#import "FVResponce.h"
#import "FVPost.h"
#import "FVComment.h"
#import "FVUser.h"
#import "FVPlace.h"

@implementation FVMappingProvider

+ (RKObjectMapping *)responceMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FVResponce class]];
    
    NSDictionary *mappingDictionary = @{@"status": @"status"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    [mapping addRelationshipMappingWithSourceKeyPath:@"data" mapping:[self postMapping]];
    
    return mapping;
}

+ (RKObjectMapping *)postMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FVPost class]];
    
    NSDictionary *mappingDictionary = @{@"photo": @"photoUrlString",
                                        @"description": @"text",
                                        @"isCheckedIn": @"isCheckedIn",
                                        @"ts": @"ts",
                                        @"distance": @"distance",
                                        @"likes": @"likes"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    [mapping addRelationshipMappingWithSourceKeyPath:@"place" mapping:[self placeMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"author" mapping:[self userMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"comments" mapping:[self commentMapping]];
    
    return mapping;
}

+ (RKObjectMapping *)commentMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FVComment class]];
    
    NSDictionary *mappingDictionary = @{@"text": @"text"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    [mapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:[self userMapping]];
    
    return mapping;
}

+ (RKObjectMapping *)userMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FVUser class]];
    
    NSDictionary *mappingDictionary = @{@"avatarUrl": @"avatarURLString",
                                        @"nickname": @"nickname"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    
    return mapping;
}

+ (RKObjectMapping *)placeMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[FVPlace class]];
    
    NSDictionary *mappingDictionary = @{@"name": @"name",
                                        @"land": @"land"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];
    
    return mapping;
}

@end
