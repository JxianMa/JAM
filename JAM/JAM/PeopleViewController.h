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
#import <CoreLocation/CoreLocation.h>


@class  PeopleViewController;

@interface PeopleViewController : UIViewController <UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegate, NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    //__weak IBOutlet UICollectionView *peopleCollectionView;
    NSMutableArray *people;
}
@property (copy,nonatomic) NameTagCollectionViewCell *nametagCell;
@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;
@property (nonatomic, strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) CLLocation *currentlocation;
@property (nonatomic, assign) double radiusInMeters;

@end
