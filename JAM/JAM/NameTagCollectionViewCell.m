//
//  NameTagCollectionViewCell.m
//  Jam
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "NameTagCollectionViewCell.h"

@implementation NameTagCollectionViewCell

- (void)setPersonInfo:(PersonInfo *)personInfo
{
    _personInfo = personInfo;
    personImageView.image = [UIImage imageNamed:_personInfo.photoName];
    personNameLabel.text = _personInfo.name;
}



@end
