//
//  FoodViewController.h
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewController : UIViewController <UICollectionViewDataSource>

{
    __weak IBOutlet UICollectionView *foodCollectionView;
    NSMutableArray *food;
}

@end
