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
#import "Story.h"
#import "DynamoDB.h"
#import "StoryModel.h"

@interface AddViewController ()<UITextFieldDelegate,UITextViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addStoryNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addStoryDescTextField;
@property (weak, nonatomic) IBOutlet UITextView *addStoryTextView;
@property (weak, nonatomic) IBOutlet UIView *storyBoardView;
@property (nonatomic,strong) NSArray *textFieldArray;
@property (weak, nonatomic) IBOutlet UIButton *addStoryPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,strong) UIImage *photoDefaultImage;
@property (nonatomic,strong) StoryModel *story;
@property (nonatomic,strong) Story *storyToLocal;
@end

@implementation AddViewController

#pragma mark UI setup
- (void)viewDidLoad
{
    NSLog(@"postalCode:%@",self.currentlocation);
    [self setUpStoryView];
    self.addStoryTextView.delegate = self;
    self.addStoryNameTextField.delegate = self;
    self.addStoryDescTextField.delegate = self;
    self.photoDefaultImage = [UIImage imageNamed:@"plus"];
    [self.addStoryPhotoBtn setBackgroundImage:self.photoDefaultImage forState:UIControlStateNormal];
    NSString *nameTextFieldPlacehrString = @"Enter your name...";
    UIColor *nameTextFieldPlacehrColor = [UIColor whiteColor];
    self.addStoryNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:nameTextFieldPlacehrString attributes:@{NSForegroundColorAttributeName:nameTextFieldPlacehrColor}];
    
    self.textFieldArray = @[self.addStoryNameTextField, self.addStoryDescTextField,self.addStoryTextView];
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
     [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setBackgroundImg];
}

- (void)setUpStoryView
{
    self.storyBoardView.layer.cornerRadius = 5;
    self.storyBoardView.layer.masksToBounds = YES;
}

- (void)setBackgroundImg
{
    UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImgView.image = self.backgroundImg;
    [self.view addSubview:backgroundImgView];
    [self.view sendSubviewToBack:backgroundImgView];
}

- (void)dismissKeyboard {
    for (UITextField *eachTextField in self.textFieldArray) {
        [eachTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addStoryPhoto:(UIButton *)sender
{
    self.addStoryPhotoBtn.titleLabel.text = nil;
    UIActionSheet *addPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", nil];
    [addPhotoActionSheet addButtonWithTitle:@"Choose from library"];
    [addPhotoActionSheet showInView:self.view];
}


- (void)saveInfoToLocalDB
{
        //NSLog(@"peopleInformation:%@", self.storyInformation);
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    self.storyToLocal = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:app.managedObjectContext];
    self.storyToLocal.storyName = self.story.storyName;
    self.storyToLocal.storyDescription = self.story.storyDescription;
    self.storyToLocal.story = self.story.story;
    self.storyToLocal.storyId = self.story.storyId;
    NSLog(@"storyId:%@",self.storyToLocal.storyId);
    double currentTime = [[NSDate date] timeIntervalSince1970];
    self.storyToLocal.uploadTime = [NSString stringWithFormat:@"%f",currentTime];
    
    self.storyToLocal.longtitude = [NSNumber numberWithDouble:(double)self.currentlocation.coordinate.longitude];
    self.storyToLocal.latitude = [NSNumber numberWithDouble:(double)self.currentlocation.coordinate.latitude];
    if (self.addStoryPhotoBtn.currentBackgroundImage) {
        NSData *photoData = UIImageJPEGRepresentation(self.addStoryPhotoBtn.currentBackgroundImage, 0.03);
        self.storyToLocal.photo = photoData;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentlocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placeMark = [placemarks objectAtIndex:0];
             self.storyToLocal.postalCode = placeMark.postalCode;
             [app saveContext];
             [app.managedObjectContext save:&error];
         }
     }];
    [self.saveBtn setEnabled:YES];
    [self.saveBtn setAlpha:1.0f];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (error) {
        UIAlertView *saveFaileAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"An error has happened during saving, please try again" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [self.view addSubview:saveFaileAlert];
        [self.saveBtn setEnabled:YES];
        [self.saveBtn setAlpha:1.0f];
    }
    
}

- (IBAction)savePeopleInfo:(UIButton *)sender
{
    self.story = [[StoryModel alloc]init];
    self.story.storyName = self.addStoryNameTextField.text;
    self.story.storyDescription = self.addStoryDescTextField.text;
    self.story.story = self.addStoryTextView.text;
    [self saveUploadTime:self.story];
    [self saveImageInfo:self.story];
    [self savePostalCode:self.story];
    [sender setEnabled:NO];
    [sender setAlpha:0.5f];
}

- (void)savePostalCode:(StoryModel *)story
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentlocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placeMark = [placemarks objectAtIndex:0];
             story.postalCode = placeMark.postalCode;
             [self saveToAWSDynamoDB];
         }
     }];
}

- (void)saveToAWSDynamoDB
{
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    NSError *error;
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    [[dynamoDBObjectMapper scan:[StoryModel class] expression:scanExpression]
     continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error:[%@]",task.error);
         }
         if (task.result) {
             AWSDynamoDBPaginatedOutput *output = task.result;
             NSInteger scannedCountInt = [output.items count];
             self.story.storyId = [NSNumber numberWithInteger:scannedCountInt++];
             [[[dynamoDBObjectMapper save:self.story]
               continueWithSuccessBlock:^id(BFTask *task){
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self saveInfoToLocalDB];
                       [self.navigationController popViewControllerAnimated:YES];
                   });
                   return nil;
               }]
              continueWithBlock:^id(BFTask *task) {
                  if (task.error) {
                      NSLog(@"The request failed. Error: [%@]", task.error);
                      dispatch_async(dispatch_get_main_queue(), ^{
                          UIAlertView *saveFaileAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"An error has happened during saving, please try again" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                          [saveFaileAlert show];
                      });
                  }
                  return nil;
              }];
             if (error) {
                 UIAlertView *saveFaileAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"An error has happened during saving, please try again" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                 [self.view addSubview:saveFaileAlert];
             }
             
         }
         return nil;
     }];
    
}


- (void)saveUploadTime:(StoryModel *)story
{
    double currentTime = [[NSDate date] timeIntervalSince1970];
    story.uploadTime = [NSString stringWithFormat:@"%f",currentTime];
}



- (void)saveImageInfo:(StoryModel *)story
{
    if (self.addStoryPhotoBtn.currentBackgroundImage) {
        NSData *photoData = UIImageJPEGRepresentation(self.addStoryPhotoBtn.currentBackgroundImage, 0.03);
        story.photo = photoData;
        NSLog(@"stored photo size:%@", [NSByteCountFormatter stringFromByteCount:photoData.length countStyle:NSByteCountFormatterCountStyleFile]);
    }
}

#pragma mark slide up view when editing

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView:textView up:YES withDistance:200];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO withDistance:200];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addStoryNameTextField) {
        [self animateTextField: textField up: YES withDistance:40];
    }
    if (textField == self.addStoryDescTextField) {
        [self animateTextField: textField up: YES withDistance:60];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.addStoryNameTextField) {
        [self animateTextField: textField up: NO withDistance:40];
    }
    if (textField == self.addStoryDescTextField) {
        [self animateTextField: textField up: NO withDistance:60];
    }
}


- (void) animateTextField: (UITextField *) textField up: (BOOL) up withDistance: (int)movementDistance
{
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) animateTextView: (UITextView *) textView up: (BOOL) up withDistance: (int)movementDistance
{
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {}
    if (buttonIndex == 2) {
        UIImagePickerController *peopleImagePicker = [[UIImagePickerController alloc] init];
        peopleImagePicker.delegate = self;
        peopleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:peopleImagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 0) {
        UIImagePickerController *peopleImagePicker = [[UIImagePickerController alloc] init];
        peopleImagePicker.delegate = self;
        peopleImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:peopleImagePicker animated:YES completion:nil];
    }
}


#pragma mark implement the UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.addStoryPhotoBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];
}


@end
