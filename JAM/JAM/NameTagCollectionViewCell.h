//
//  NameTagCollectionViewCell.h
//  Jam
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface NameTagCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UITextField *storyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *storyDescTextField;
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countingLabel;


@property (strong, nonatomic) NSArray *textFieldsStatusArray;
@property (strong, nonatomic) StoryModel *storyInfo;
@property (strong, nonatomic) NSNumber *storyId;
@end
