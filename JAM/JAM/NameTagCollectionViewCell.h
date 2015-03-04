//
//  NameTagCollectionViewCell.h
//  Jam
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"
#import "People.h"

@interface NameTagCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UITextField *personNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *personSelfDescTextField;
@property (weak, nonatomic) IBOutlet UITextField *personPhoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *personEmailAddTextField;

@property (strong, nonatomic) NSArray *textFieldsStatusArray;
@property (strong, nonatomic) PersonInfo *personInfo;
@property (strong, nonatomic) People *peopleInfo;
@end
