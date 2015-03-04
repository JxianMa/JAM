//
//  AddViewController.m
//  JAM
//
//  Created by MaJixian on 2/23/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "AddViewController.h"
#import "PeopleViewController.h"
#import "AppDelegate.h"
#import "People.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addPeopleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPeopleDescTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPeoplePhoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPeopleEmailAddTextField;
@property (nonatomic,strong) NSArray *textFieldArray;
@property (weak, nonatomic) IBOutlet UIButton *addPeoplePhotoBtn;
@property (nonatomic,strong) UIImage *photoDefaultImage;
@end

@implementation AddViewController

#pragma mark UI setup
- (void)viewDidLoad
{
    self.photoDefaultImage = [UIImage imageNamed:@"plus"];
    [self.addPeoplePhotoBtn setBackgroundImage:self.photoDefaultImage forState:UIControlStateNormal];
    NSString *nameTextFieldPlacehrString = @"Enter your name...";
    UIColor *nameTextFieldPlacehrColor = [UIColor whiteColor];
    self.addPeopleNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:nameTextFieldPlacehrString attributes:@{NSForegroundColorAttributeName:nameTextFieldPlacehrColor}];
    self.textFieldArray = @[self.addPeopleNameTextField, self.addPeopleDescTextField,self.addPeoplePhoneNoTextField,self.addPeopleEmailAddTextField];
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
     [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    for (UITextField *eachTextField in self.textFieldArray) {
        [eachTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addPhotoButton:(UIButton *)sender
{
    self.addPeoplePhotoBtn.titleLabel.text = nil;
    UIImagePickerController *peopleImagePicker = [[UIImagePickerController alloc] init];
    peopleImagePicker.delegate = self;
    peopleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:peopleImagePicker animated:YES completion:nil];
}

- (IBAction)backToPeople:(UIButton *)sender
{
    [self backToPeopleCollectionView];
}


- (void)backToPeopleCollectionView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PeopleViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"peopleViewController"];
    [peopleViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:peopleViewController animated:YES completion:NULL];
}

- (IBAction)savePeopleInfo:(UIButton *)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    People *people = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:app.managedObjectContext];
    people.name = self.addPeopleNameTextField.text;
    people.selfDescription = self.addPeopleDescTextField.text;
    people.phoneNumber = self.addPeoplePhoneNoTextField.text;
    people.emailAdd = self.addPeopleEmailAddTextField.text;
    [self saveImageInfo:people];
    [app saveContext];
    NSError *error;
    [app.managedObjectContext save:&error];
    if (!error) {
        [self backToPeopleCollectionView];
    }
    else {
        UIAlertView *saveFaileAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"An error has happened during saving, please try again" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [self.view addSubview:saveFaileAlert];
    }
}


- (void)saveImageInfo:(People *)people
{
    if (self.addPeoplePhotoBtn.currentBackgroundImage) {
        NSData *photoData = UIImagePNGRepresentation(self.addPeoplePhotoBtn.currentBackgroundImage);
        people.photo = photoData;
    }
}


#pragma mark implement the UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.addPeoplePhotoBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];
}

#pragma mark facebooklogin button




@end
