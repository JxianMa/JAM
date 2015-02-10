//
//  PeopleViewController.h
//  Jam01
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  PeopleViewController;

@interface PeopleViewController : UIViewController <UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *peopleCollectionView;
    NSMutableArray *people;
}

@end
