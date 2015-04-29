//
//  commentPageViewController.m
//  JAM
//
//  Created by MaJixian on 3/25/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "commentPageViewController.h"
#import "DynamoDB.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3f;
@interface commentPageViewController ()
@property (assign,nonatomic) CGRect commentTextViewFrame;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *demoBgView;
@property (weak, nonatomic) IBOutlet UIImageView *storyImgView;
@property (weak, nonatomic) IBOutlet UITextField *storyNameView;
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong,nonatomic) CommentModel *commentData;
@property (strong,nonatomic) NSArray *commentArray;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;



@end
@implementation commentPageViewController

- (void)viewDidLoad
{
    NSLog(@"storyId:%@",self.storyId);
    [self setMapkit];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.backgroundImgView.image = self.strViewImg;
    self.demoBgView.layer.cornerRadius = 5;
    self.demoBgView.layer.masksToBounds = YES;
    self.storyImgView.image = self.storyImg;
    self.storyNameView.text = self.storyName;
    self.storyTextView.text = self.story;
    self.sendBtn.layer.cornerRadius = 3;
    self.sendBtn.clipsToBounds = YES;
    self.demoBgView.layer.cornerRadius = 3;
    self.demoBgView.clipsToBounds = YES;
    self.commentTextViewFrame = self.commentTextView.frame;
    //  [self createInputAccessoryView];
   // self.commentTextField.inputAccessoryView = self.inputAccView;
   // self.commentTextField.delegate = self;
   /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShowAction:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHideAction)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];*/
}
/*
-(void)keyboardShowAction:(NSNotification *)notification
{
    [self.inputAccTextField becomeFirstResponder];
   // [self animateForToNewYPositionUp:YES withDistance:220];
}
*/
- (void)dismissKeyboard
{
    [self.commentTextView resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self performDynamoDBScanWithStoryId:[NSString stringWithFormat:@"%@",self.storyId]];
    [self performDynamoDBScanWithStoryId:self.storyId];
}


- (void)setMapkit
{
    CLLocationCoordinate2D coord = {self.latitude,self.longtitude};
    MKCoordinateSpan span = {0.2, 0.2};
    MKCoordinateRegion region = {coord,span};
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [self.mapKitView addAnnotation:annotation];
    [self.mapKitView setRegion:region];
}


#pragma mark textView delegate
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
       // [self animateForToNewYPositionUp:YES withDistance:220];
    //self.inputAccTextField = textField;
    [self createInputAccessoryView];
    [textField setInputAccessoryView:self.inputAccView];
    //self.inputAccTextField = textField;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        [self animateForToNewYPositionUp:NO withDistance:440];
        [textField setText:@""];
    }
}

- (void)createInputAccessoryView
{
    self.inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    [self.inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    self.inputAccTextField = [[UITextField alloc] initWithFrame:self.commentTextField.frame];
    [self.inputAccTextField setBackgroundColor:[UIColor whiteColor]];
    self.inputAccTextField.layer.cornerRadius = 5;
    self.inputAccTextField.layer.masksToBounds = YES;
    //self.inputAccTextField.delegate = self;
    //self.inputAccTextField.tag = 2;
    
    self.sendAccBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendAccBtn.layer.cornerRadius = 5;
    self.sendAccBtn.layer.masksToBounds = YES;
    [self.sendAccBtn setFrame:self.sendBtn.frame];
    [self.sendAccBtn setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendAccBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendAccBtn setBackgroundColor:[UIColor blackColor]];
    [self.sendAccBtn addTarget: self action: @selector(sendToDB) forControlEvents: UIControlEventTouchUpInside];
    
    [self.inputAccView addSubview:self.inputAccTextField];
    [self.inputAccView addSubview:self.sendAccBtn];
}
*/

- (void)textViewDidChange:(UITextView *)textView
{
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGFloat fixedHeight = textView.frame.size.height;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    //[self animateTextView:textView up:YES withDistance:newFrame.size.height-fixedHeight];
    [self animateForToNewYPositionUp:YES withDistance:newFrame.size.height-fixedHeight];
    textView.frame = newFrame;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //[self animateTextView:textView up:YES withDistance:250];
    [self animateForToNewYPositionUp:YES withDistance:250];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //[self animateTextView:textView up:NO withDistance:250+(textView.frame.size.height - self.commentTextViewFrame.size.height)];
    [self animateForToNewYPositionUp:NO withDistance:250+(textView.frame.size.height - self.commentTextViewFrame.size.height)];
    CGRect newFrame = self.commentTextViewFrame;
    textView.frame = newFrame;
    [self.commentTextView setText:@""];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSDictionary *textAttributes = @{NSFontAttributeName : textView.font};
    CGFloat textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset));
    textWidth -= 2.0f * textView.textContainer.lineFragmentPadding;
    CGRect boundingRect = [newText boundingRectWithSize:CGSizeMake(textWidth, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             attributes:textAttributes
                                                context:nil];
    NSUInteger numberOfLines = CGRectGetHeight(boundingRect) / textView.font.lineHeight;
    return newText.length <= 500 && numberOfLines <= 3;
}
 
/*
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
*/
- (void) animateForToNewYPositionUp:(BOOL) up withDistance: (int)movementDistance {
    // move for kdb

    int movement = (up ? -movementDistance : movementDistance);
    // start animation
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    // move it
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
 
/*
    int movement = (up ? -movementDistance : movementDistance);
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = CGRectOffset(self.view.frame, 0, movement);
                     }
                     completion:^(BOOL finished){
                         [self.view setUserInteractionEnabled:YES];
                     }];

 */
}

#pragma mark retrieve action

- (void)performDynamoDBScanWithStoryId:(NSNumber *)storyId
{
    NSLog(@"performDBScan storyID:%@",storyId);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBQueryExpression *dynamoDBQueryExpression = [AWSDynamoDBQueryExpression new];
    dynamoDBQueryExpression.hashKeyValues = storyId;
    dynamoDBQueryExpression.scanIndexForward = @NO;
    [[dynamoDBObjectMapper query:[CommentModel class] expression:dynamoDBQueryExpression]
     continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error:[%@]",task.error);
         }
         if (task.result) {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             self.commentArray = paginatedOutput.items;
             NSLog(@"retrieved data:%@",self.commentArray);
             [self.commentTableView reloadData];
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         }
         return nil;
     }];
}

#pragma mark UITableview datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"commentTableCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    cell.comment = self.commentArray[indexPath.row];
    return cell;
}


#pragma mark save action
- (IBAction)sendToDB:(UIButton *)sender
{
    self.commentData = [[CommentModel alloc]init];
    self.commentData.storyId = self.storyId;
    self.commentData.comment = self.commentTextView.text;
    [self saveUploadTime:self.commentData];
    [self saveToAWSDynamoDB];
    [sender setEnabled:NO];
    [sender setAlpha:0.6];
}



- (void)saveUploadTime:(CommentModel *)comment
{
    double currentTime = [[NSDate date] timeIntervalSince1970];
    comment.uploadTime = [NSString stringWithFormat:@"%f",currentTime];
}


- (void)saveToAWSDynamoDB
{
    NSLog(@"commentData:%@",self.commentData);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
             [[[dynamoDBObjectMapper save:self.commentData]
               continueWithSuccessBlock:^id(BFTask *task){
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self performDynamoDBScanWithStoryId:self.storyId];
                       [self.commentTableView reloadData];
                       [self dismissKeyboard];
                       [self.commentTextView setText:@""];
                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                       [self.sendBtn setEnabled:YES];
                       [self.sendBtn setAlpha:1.0f];
                   });
                   return nil;
               }]
              continueWithBlock:^id(BFTask *task) {
                  if (task.error) {
                      NSLog(@"The request failed. Error: [%@]", task.error);
                      dispatch_async(dispatch_get_main_queue(), ^{
                          UIAlertView *saveFaileAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"An error has happened during saving, please try again" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                          [self.sendBtn setEnabled:YES];
                          [self.sendBtn setAlpha:1.0f];
                          [saveFaileAlert show];
                      });
                  }
                  return nil;
              }];
}


@end
