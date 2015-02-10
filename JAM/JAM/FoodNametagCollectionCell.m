//
//  FoodNametagCollectionCell.m
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "FoodNametagCollectionCell.h"

@implementation FoodNametagCollectionCell

- (void)setFoodInfo:(FoodInfo *)foodInfo
{
    _foodInfo = foodInfo;
    foodImageView.image = [UIImage imageNamed:_foodInfo.photoName];
    foodNameLabel.text = _foodInfo.name;
}



@end
