//
//  CommentModel.m
//  JAM
//
//  Created by MaJixian on 4/12/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "CommentModel.h"
#import "DynamoDB.h"

@implementation CommentModel

+ (NSString *)dynamoDBTableName
{
    return @"comment-table";
}

+ (NSString *)hashKeyAttribute
{
    return @"storyId";
}


+ (NSString *)rangeKeyAttribute
{
    return @"uploadTime";
}


@end
