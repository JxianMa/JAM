//
//  NameTagCollectionViewCell.h
//  Jam00
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@interface NameTagCollectionViewCell : UICollectionViewCell

{

    __weak IBOutlet UIImageView *personImageView;
   
    __weak IBOutlet UILabel *personNameLabel;
    

}
@property (weak, nonatomic) PersonInfo *personInfo;
@end
