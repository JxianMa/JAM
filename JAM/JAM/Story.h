//
//  Story.h
//  JAM
//
//  Created by MaJixian on 4/21/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Story : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * story;
@property (nonatomic, retain) NSString * storyDescription;
@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSString * storyName;
@property (nonatomic, retain) NSString * uploadTime;

@end
