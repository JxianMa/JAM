//
//  AddViewController.h
//  JAM
//
//  Created by MaJixian on 2/23/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AddViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong)UIImage *backgroundImg;
@property (nonatomic, strong) CLLocation *currentlocation;

@end
