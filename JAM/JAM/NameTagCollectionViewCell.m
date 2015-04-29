
//  NameTagCollectionViewCell.m
//  Jam
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "NameTagCollectionViewCell.h"
#import "AppDelegate.h"

@interface NameTagCollectionViewCell()

@end

@implementation NameTagCollectionViewCell


/*
- (void)setPersonInfo:(PersonInfo *)personInfo
{
    _personInfo = personInfo;
    //Default contents
   // self.personImageView.image = [UIImage imageNamed:_personInfo.photoName];
   // self.personNameTextField.text = _personInfo.name;
   // self.personSelfDescTextField.text = _personInfo.selfDescription;
   // self.personPhoneNumTextField.text = _personInfo.phoneNumber;
   // self.personEmailAddTextField.text = _personInfo.emailAdd;
}
*/

- (void)setStoryInfo:(StoryModel *)storyInfo
{
    _storyInfo = storyInfo;
    self.storyNameTextField.text = _storyInfo.storyName;
    self.storyDescTextField.text = _storyInfo.storyDescription;
    self.storyTextView.text = _storyInfo.story;
    self.storyId = _storyInfo.storyId;
    UIImage *storyImage = [UIImage imageWithData:_storyInfo.photo];
    self.storyImageView.image = storyImage;
    double uploadTime = [_storyInfo.uploadTime doubleValue];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger ti = currentTime - uploadTime;
    NSInteger hours = (ti / 3600);
    if (hours > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld hours ago", (long)hours];
    }else {
        NSInteger mins = (ti/60);
        if (mins > 0) {
            self.timeLabel.text = [NSString stringWithFormat:@"%ld mins ago", (long)mins];
        }else {
            NSInteger secs = ti;
            if (secs > 0) {
                self.timeLabel.text = [NSString stringWithFormat:@"%ld secs ago", (long)secs];
            }else {
                self.timeLabel.text = [NSString stringWithFormat:@"0 secs ago"];
            }
        }
    }
    self.countingLabel.text = @"0";
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}
- (IBAction)addJam:(UIButton *)sender
{
    NSUInteger jamCounting = [self.countingLabel.text integerValue];
    //self.countingLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)jamCounting++];
    jamCounting = jamCounting+1;
    [self.countingLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)jamCounting]];
}

/*
- (void)setPeopleInfo:(PeopleModel *)peopleInfo
{
    _peopleInfo = peopleInfo;
    self.storyNameTextField.text = _peopleInfo.storyName;
    self.storyDescTextField.text = _peopleInfo.storyDescription;
    self.storyTextView.text = _peopleInfo.story;
    UIImage *storyImage = [UIImage imageWithData:_peopleInfo.photo];
    self.storyImageView.image = storyImage;
    // NSString *nameTextFieldPhrString = @"Enter your name...";
    //UIColor *nameTextFieldPhrColor = [UIColor whiteColor];
    //self.personNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:nameTextFieldPhrString attributes:@{NSForegroundColorAttributeName:nameTextFieldPhrColor}];
    
    self.textFieldsStatusArray = @[self.personNameTextField,self.personSelfDescTextField,self.personPhoneNumTextField,self.personEmailAddTextField];
    for (UITextField *eachTextField in self.textFieldsStatusArray)
    {
        eachTextField.enabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self.viewForBaselineLayout addGestureRecognizer:tap];
    }
    if (self.personImageView.image)
    {
        self.addPhotoBtn.hidden = YES;
    }
    
    //Default contents
    //personImageView.image = [UIImage imageNamed:_personInfo.photoName];

}

/*
-(void)dismissKeyboard {
     for (UITextField *eachTextField in self.textFieldsStatusArray) {
    [eachTextField resignFirstResponder];
     }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//Lock the textfield and save the infomation into database
- (IBAction)editStatusStart:(UIButton *)sender
{
    //sender.backgroundColor = [UIColor lightGrayColor];
    sender.hidden = YES;
    self.editLockClose.hidden = NO;
     for (UITextField *eachTextField in self.textFieldsStatusArray) {
     eachTextField.enabled = NO;
     }
    [self addInfoToDic];
}

//Save the information that user just typed into the database
- (void)addInfoToDic
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    People *people = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:app.managedObjectContext];
    people.name = self.personNameTextField.text;
    people.selfDescription = self.personSelfDescTextField.text;
    people.phoneNumber = self.personPhoneNumTextField.text;
    people.emailAdd = self.personEmailAddTextField.text;
    [app saveContext];

}

//Unlock the textfield and let user to modify the information
- (IBAction)editStatusEnd:(UIButton *)sender
{
    sender.hidden = YES;
    self.editLockOpen.hidden = NO;
    for (UITextField *eachTextField in self.textFieldsStatusArray) {
        eachTextField.enabled = YES;
    }
    
}

- (IBAction)addPhoto:(UIButton *)sender
{

}
*/




@end
