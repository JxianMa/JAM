//
//  PeopleViewController.h
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "NameTagCollectionViewCell.h"

@class  PeopleViewController;

@interface PeopleViewController : UIViewController <UICollectionViewDataSource,MCBrowserViewControllerDelegate, UITextViewDelegate, UICollectionViewDelegate, NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    //__weak IBOutlet UICollectionView *peopleCollectionView;
    NSMutableArray *people;
}
@property(weak,nonatomic) NameTagCollectionViewCell *nametagCell;
@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;

@end
