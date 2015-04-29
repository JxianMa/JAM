//
//  commentPageViewController.h
//  JAM
//
//  Created by MaJixian on 3/25/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface commentPageViewController : UIViewController<UITableViewDataSource, UITextViewDelegate, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet MKMapView *mapKitView;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;
@property (strong, nonatomic) UIImage *storyImg;
@property (strong, nonatomic) NSString *storyName;
@property (strong, nonatomic) NSString *story;
@property (strong, nonatomic) UIImage *strViewImg;
@property (strong, nonatomic) NSNumber *storyId;

@end
