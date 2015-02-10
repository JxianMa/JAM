//
//  FoodNametagCollectionCell.h
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodInfo.h"

@interface FoodNametagCollectionCell : UICollectionViewCell
{
    __weak IBOutlet UIImageView *foodImageView;
    __weak IBOutlet UILabel *foodNameLabel;
    
}
@property (weak, nonatomic) FoodInfo *foodInfo;
@end
