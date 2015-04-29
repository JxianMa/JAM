//
//  CommentModel.h
//  JAM
//
//  Created by MaJixian on 4/12/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"
#import <Foundation/Foundation.h>
#import <AWSiOSSDKv2/DynamoDB.h>

@interface CommentModel : AWSDynamoDBObjectModel<AWSDynamoDBModeling>

@property (nonatomic,strong) NSNumber *storyId;
@property (nonatomic,strong) NSString *uploadTime;
@property (nonatomic,strong) NSString *comment;

@end
