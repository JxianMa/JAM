//
//  PeopleViewController.h
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@class  PeopleViewController;

@interface PeopleViewController : UIViewController <UICollectionViewDataSource,MCBrowserViewControllerDelegate, UITextViewDelegate>
{
    __weak IBOutlet UICollectionView *peopleCollectionView;
    NSMutableArray *people;
}

@end
