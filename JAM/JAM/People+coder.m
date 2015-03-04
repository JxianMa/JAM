//
//  People+coder.m
//  JAM
//
//  Created by MaJixian on 3/2/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "People+coder.h"

@implementation People (coder)


- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.selfDescription = [decoder decodeObjectForKey:@"selfDescription"];
        self.emailAdd = [decoder decodeObjectForKey:@"emailAdd"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.selfDescription forKey:@"selfDescription"];
    [coder encodeObject:self.emailAdd forKey:@"emailAdd"];
    [coder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:self.photo forKey:@"photo"];
}

@end
