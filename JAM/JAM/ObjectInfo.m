//
//  PersonInfo.m
//  Jam00
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "ObjectInfo.h"

@implementation ObjectInfo

-(instancetype)initWithDictionary:(NSDictionary *)infoDictionary
{
    self = [self init];
    if (self) {
        self.name = infoDictionary[@"name"];
        self.photoName = infoDictionary[@"photoName"];
        self.selfDescription = infoDictionary[@"selfDescription"];
        self.phoneNumber = infoDictionary[@"phoneNumber"];
        self.emailAdd = infoDictionary[@"emailAdd"];
    }
    return self;
}

@end
