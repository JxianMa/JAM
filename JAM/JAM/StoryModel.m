//
//  StoryModel.m
//  JAM
//
//  Created by MaJixian on 3/24/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "StoryModel.h"
#import "DynamoDB.h"
#import "AFNetworking.h"

static NSString *requestURL = @"http://ENVIRONMENT-NAME.elasticbeanstalk.com/PROJECT-NAME";

@implementation StoryModel

+ (NSString *)dynamoDBTableName
{
    return @"story-table";
}

+ (NSString *)hashKeyAttribute
{
    return @"postalCode";
}

+ (NSString *)rangeKeyAttribute
{
    return @"uploadTime";
}


+ (void)getStoryInfo: (void (^)(NSArray *responseArray, NSError *error))block atLontitude:(double)longtitude latitude:(double)latitude ofRadius:(double)radiusInMeters
{
    NSDictionary *requestDict = @{@"action":@"query-radius",
                                  @"request":@{
                                          @"longtitude":[NSNumber numberWithDouble:longtitude],
                                          @"latitude":[NSNumber numberWithDouble:latitude],
                                          @"radiusInMeter":[NSNumber numberWithDouble:radiusInMeters]
                                          }
                                  };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:requestURL parameters:requestDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *responseMutableArray = [[NSMutableArray alloc] init];
        NSLog(@"responseObject:%@",responseObject);
        if (block) {
            block([NSArray arrayWithArray:responseMutableArray],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (void)putInfo: (void (^)(NSArray *responseArray, NSError *error))block withInfoDict:(NSDictionary *)storyDict
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:requestURL parameters:storyDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *responseMutableArray = [[NSMutableArray alloc] init];
        NSLog(@"responseObject:%@",responseObject);
        if (block) {
            block([NSArray arrayWithArray:responseMutableArray],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+ (void)getComment: (void (^)(NSArray *responseArray, NSError *error))block withStoryId:(NSNumber *)storyId
{
    NSDictionary *requestDict = @{@"action":@"get-comment",
                                  @"request":@{
                                          @"storyId":storyId}
                                  };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:requestURL parameters:requestDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *responseMutableArray = [[NSMutableArray alloc] init];
        NSLog(@"responseObject:%@",responseObject);
        if (block) {
            block([NSArray arrayWithArray:responseMutableArray],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}




@end
