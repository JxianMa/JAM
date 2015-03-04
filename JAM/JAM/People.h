//
//  People.h
//  JAM
//
//  Created by MaJixian on 3/4/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * emailAdd;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * selfDescription;

@end
