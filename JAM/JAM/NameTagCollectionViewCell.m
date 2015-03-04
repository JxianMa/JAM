
//  NameTagCollectionViewCell.m
//  Jam
//
//  Created by MaJixian on 1/27/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "NameTagCollectionViewCell.h"
#import "People.h"
#import "AppDelegate.h"

@interface NameTagCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;

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


- (void)setPeopleInfo:(People *)peopleInfo
{
    _peopleInfo = peopleInfo;
    
    NSString *nameTextFieldPhrString = @"Enter your name...";
    UIColor *nameTextFieldPhrColor = [UIColor whiteColor];
    self.personNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:nameTextFieldPhrString attributes:@{NSForegroundColorAttributeName:nameTextFieldPhrColor}];
    /*
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
     */
    //Default contents
    //personImageView.image = [UIImage imageNamed:_personInfo.photoName];
    self.personNameTextField.text = _peopleInfo.name;
    self.personSelfDescTextField.text = _peopleInfo.selfDescription;
    self.personPhoneNumTextField.text = _peopleInfo.phoneNumber;
    self.personEmailAddTextField.text = _peopleInfo.emailAdd;
    UIImage *peopleImage = [UIImage imageWithData:_peopleInfo.photo];
    self.personImageView.image = peopleImage;
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
