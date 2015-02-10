//
//  PersonInfo.h
//  Jam00
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//
//  Abstract class, must be implemented.

#import <Foundation/Foundation.h>

@interface ObjectInfo : NSObject

-(instancetype) initWithDictionary:(NSDictionary *)infoDictionary;

@property(strong)NSString *name;
@property(strong)NSString *photoName;

@end
