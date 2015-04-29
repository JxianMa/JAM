//
//  StoryModel.h
//  JAM
//
//  Created by MaJixian on 3/24/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"

@interface StoryModel : AWSDynamoDBObjectModel<AWSDynamoDBModeling>

@property (nonatomic, strong) NSString * storyName;
@property (nonatomic, strong) NSString * storyDescription;
@property (nonatomic, strong) NSString * story;
@property (nonatomic, strong) NSData   * photo;
@property (nonatomic, strong) NSString * uploadTime;
@property (nonatomic, strong) NSString * postalCode;
@property (nonatomic, strong) NSNumber * storyId;


+ (void)getStoryInfo: (void (^)(NSArray *responseArray, NSError *error))block atLontitude:(double)longtitude latitude:(double)latitude ofRadius:(double)radiusInMeters;
+ (void)putInfo: (void (^)(NSArray *responseArray, NSError *error))block withInfoDict:(NSDictionary *)storyDict;
+ (void)getComment: (void (^)(NSArray *responseArray, NSError *error))block withStoryId:(NSNumber *)storyId;


@end
