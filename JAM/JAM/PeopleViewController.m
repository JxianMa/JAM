//
//  PeopleViewController.m
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "PeopleViewController.h"
#import "NameTagCollectionViewCell.h"
#import "EBCardCollectionViewLayout.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "DynamoDB.h"
#import "UIImageView+AFNetworking.h"
#import "commentPageViewController.h"
#import "AddViewController.h"



@interface PeopleViewController () <UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIImageView *movingCell;
//Since the receive method and send method requires this AlertView, Declare it here.
@property (nonatomic,strong) UIAlertView *waitingForResponseAlertView;
@property (nonatomic,strong) UIAlertView *receiveDataAlertView;
@property (nonatomic,strong) UIAlertView *removeCellAlertView;
@property (nonatomic,strong) NSArray *storyInformation;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (nonatomic,strong) id receivedObject;
@property (nonatomic,strong) NSString *currentPostalCode;
@property (nonatomic,strong) NSNumber *storyId;
@property (strong,nonatomic)commentPageViewController *segueDestVC;
@end

@implementation PeopleViewController
#pragma mark Load the basic view

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOffsetOfCollectionView];
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self.peopleCollectionView alwaysBounceHorizontal];
    // UIPanGestureRecognizer * panner=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    //panner.delegate = self;
    //[self.view addGestureRecognizer:panner];
    //[self setupConnection];
    /*    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"JAM_DidReceiveDataNotification"
                                               object:nil];*/
}


- (IBAction)refreshBtn:(UIButton *)sender
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self getLocation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self getLocation];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}

- (void)getLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 100;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.currentlocation = [locations lastObject];
    NSLog(@"latitude:%+.6f, longtitude:%+.6f\n",self.currentlocation.coordinate.latitude,self.currentlocation.coordinate.longitude);
    [self setBackgroundImgWithLocation];
    [self getGeocodeLocation];
}

- (void)getGeocodeLocation
{
    NSLog(@"currentLocation:%@",self.currentlocation);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentlocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placeMark = [placemarks objectAtIndex:0];
             [self performDynamoDBScanWithPostalCode:placeMark.postalCode];
         }
     }];
}

- (void)performDynamoDBScanWithPostalCode:(NSString *)postalCode
{
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    /*AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.limit = @10;
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    attribute.S = postalCode;
    condition.attributeValueList = @[attribute];
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorEQ;
    scanExpression.scanFilter = @{@"postalCode":condition};*/
    AWSDynamoDBQueryExpression *dynamodbQueryExpression = [AWSDynamoDBQueryExpression new];
    dynamodbQueryExpression.hashKeyValues = postalCode;
    dynamodbQueryExpression.scanIndexForward = @NO;
    dynamodbQueryExpression.limit = @10;
    [[dynamoDBObjectMapper query:[StoryModel class] expression:dynamodbQueryExpression]
      continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error:[%@]",task.error);
         }
         if (task.result) {
             NSLog(@"taskResult:%@",task.result);
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             self.storyInformation = paginatedOutput.items;
             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
             [self.peopleCollectionView performBatchUpdates:^{
                 [self.peopleCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
             } completion:nil];
             //[self.peopleCollectionView reloadData];
             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         }
         return nil;
     }];
    //NSLog(@"peopleInformation:%@", self.storyInformation);
}


- (void)setBackgroundImgWithLocation
{
    NSURL *googleStreetViewURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/streetview?size=%dx%d&location=%f,%f&fov=90&heading=235&pitch=10",(int)self.view.frame.size.width,(int)self.view.frame.size.height, self.currentlocation.coordinate.latitude,self.currentlocation.coordinate.longitude]];
    NSLog(@"GooglestreetView:latitude:%+.6f, longtitude:%+.6f\n",self.currentlocation.coordinate.latitude,self.currentlocation.coordinate.longitude);    self.backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];

    [self.backgroundImgView setImageWithURL: googleStreetViewURL placeholderImage:nil];
    [self.view addSubview:self.backgroundImgView];
    [self.view sendSubviewToBack:self.backgroundImgView];
    
}


#pragma mark setup database fetching
/*
- (NSMutableArray *)fetchRequestResult
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"People"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [request setReturnsObjectsAsFaults:NO];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    resultArray = (NSMutableArray *)[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    return resultArray;
}
*/




#pragma mark add & modify new businesscard and remove

/*
- (NameTagCollectionViewCell *)currentExploringCell
{
    NSArray *visibleCellArray = [self.peopleCollectionView visibleCells];
    for (NameTagCollectionViewCell *mainCell in visibleCellArray) {
        // The first card
        if (self.peopleCollectionView.contentOffset.x == 0 && [visibleCellArray count] == 2) {
            if (mainCell.frame.origin.x < (self.peopleCollectionView.contentOffset.x + mainCell.frame.size.width)) {
                return mainCell;
                break;
            }
        }
        // The last card
        if (self.peopleCollectionView.contentOffset.x > mainCell.frame.size.width && [visibleCellArray count] == 2) {
            if (mainCell.frame.origin.x > self.peopleCollectionView.contentOffset.x) {
                return mainCell;
                break;
            }
        }
        // The last one card remain
        else if ([visibleCellArray count] == 1)
        {
            return mainCell;
            break;
        }
        // The last two cards remain
        else if([people count] == 2)
        {
            if (self.peopleCollectionView.contentOffset.x >= mainCell.frame.size.width) {
                return mainCell;
                break;
            }
        }
        // Card in the middle
        else if ([visibleCellArray count] == 3)
        {
            if (mainCell.frame.origin.x > self.peopleCollectionView.contentOffset.x && mainCell.frame.origin.x < (self.peopleCollectionView.contentOffset.x   +mainCell.frame.size.width)) {
                return mainCell;
                break;
            }
        }
    }
    return nil;
}
 /*
// remove the current cell on the screen
- (void)removeCardAtCurrentCell:(NameTagCollectionViewCell *)ChosenCell
{
    NSString *removeAlertMessage = [NSString stringWithFormat:@"Make sure to remove %@'s businesscard",ChosenCell.peopleInfo.name];
    self.removeCellAlertView = [[UIAlertView alloc]initWithTitle:@"Remove Card" message:removeAlertMessage delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [self.removeCellAlertView show];
    self.removeChosenCell = ChosenCell;
}
*/

#pragma mark Communication setup

/*
- (void)setupConnection
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.CommunicationHandler setupConnectionWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.CommunicationHandler setupSession];
    [self.appDelegate.CommunicationHandler advertiseSelf];
    
}
- (IBAction)searchNearbyDevices:(UIButton *)sender
{
    if (self.appDelegate.CommunicationHandler.session != nil) {
        [[self.appDelegate CommunicationHandler] setupBrowser];
        [[[self.appDelegate CommunicationHandler] browser] setDelegate:self];
        [self presentViewController:self.appDelegate.CommunicationHandler.browser
                           animated:YES
                         completion:nil];
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.CommunicationHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.appDelegate.CommunicationHandler.browser dismissViewControllerAnimated:YES completion:nil];
}
*/

#pragma mark CollectionView setup

/* offset can control size of the card */
- (void) setOffsetOfCollectionView
{
    UIOffset collectionViewOffset = UIOffsetMake(40, 10);
    [(EBCardCollectionViewLayout *) self.peopleCollectionView.collectionViewLayout setOffset:collectionViewOffset];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.storyInformation count];
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NameTagCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionViewCell" forIndexPath:indexPath];
    cell.storyInfo = self.storyInformation[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NameTagCollectionViewCell *chosenCell = (NameTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath) {
        [self.segueDestVC setLatitude:self.currentlocation.coordinate.latitude];
        [self.segueDestVC setLongtitude:self.currentlocation.coordinate.longitude];
        self.segueDestVC.storyImg = chosenCell.storyImageView.image;
        self.segueDestVC.storyName = chosenCell.storyNameTextField.text;
        self.segueDestVC.storyId = chosenCell.storyId;
        self.segueDestVC.story = chosenCell.storyTextView.text;
        self.segueDestVC.strViewImg = self.backgroundImgView.image;
        NSLog(@"storyName:%@",self.segueDestVC.storyName);
    }
}

- (BOOL)shouldAutorotate {
    [self.peopleCollectionView.collectionViewLayout invalidateLayout];
    BOOL retVal = YES;
    return retVal;
}

#pragma mark Pan gesture recognizer

/*
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    //Create a image from the cell method:
    CGPoint locationPoint = [gestureRecognizer locationInView:self.peopleCollectionView];
    NSIndexPath *indexPathOfMovingCell = [self.peopleCollectionView indexPathForItemAtPoint:locationPoint];
    NameTagCollectionViewCell *swipedCell = (NameTagCollectionViewCell *)[self.peopleCollectionView cellForItemAtIndexPath:indexPathOfMovingCell];
    if ([self.peopleInformation count]){
        UICollectionViewLayoutAttributes *attributes = [self.peopleCollectionView layoutAttributesForItemAtIndexPath:indexPathOfMovingCell];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            UIGraphicsBeginImageContext(swipedCell.bounds.size);
            [swipedCell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
            self.movingCell.frame = CGRectMake(attributes.frame.origin.x, attributes.frame.origin.y, attributes.frame.size.width*0.7, attributes.frame.size.height*0.7);
            [self.movingCell setCenter:attributes.center];
            [self.movingCell setAlpha:0.75f];
            [self.peopleCollectionView addSubview:self.movingCell];
        
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
            if(!self.movingCell)   return;
            CGPoint translation = [gestureRecognizer translationInView:self.view];
            CGPoint cardPosition = self.movingCell.center;
            cardPosition.y += translation.y;
            self.movingCell.center = cardPosition;
            [gestureRecognizer setTranslation:CGPointZero inView:self.view];
        
        }
    
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{self.movingCell.alpha = 0.0;} completion:^(BOOL finish){if(finish)
                [self.movingCell removeFromSuperview];}];
            if (swipedCell.peopleInfo){
            [self startSendingBusinesscard:swipedCell];
            }
            NSLog(@"Start sending");
        }
    }
}
*/


#pragma mark Sending and receiving businesscard and response



/*
- (void)startSendingBusinesscard:(NameTagCollectionViewCell *)cardToSend
{
    
    //NSString *messageToSend = cardToSend.personInfo.name;
    //NSData *dataToSend = [messageToSend dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionaryToSend = @{@"status":@"sending",
                                       @"name":cardToSend.peopleInfo.name,
                                       @"selfDescription":cardToSend.peopleInfo.selfDescription,
                                       @"phoneNumber":cardToSend.peopleInfo.phoneNumber,
                                       @"emailAdd":cardToSend.peopleInfo.emailAdd,
                                       @"photo":cardToSend.peopleInfo.photo};
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dictionaryToSend];
    NSError *error;
    if ([self.appDelegate.CommunicationHandler.session.connectedPeers count]) {
        [self.appDelegate.CommunicationHandler.session sendData:dataToSend toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
        self.waitingForResponseAlertView = [[UIAlertView alloc] initWithTitle:@"Waiting for response" message:@"Businesscard has been sent, waiting for response..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [self.waitingForResponseAlertView show];
    }
        if (error != nil) {
        NSLog(@"%@",[error localizedDescription]);
    }
}


- (void)handleReceivedDataWithNotification:(NSNotification *)notification
{
    //Get the notification of the receiving data, including the sender's id and the data that has been sent
    NSLog(@"receiving new info!");
    NSDictionary *senderInfoDict = [notification userInfo];
   
    //Convert the received data to its orignial format
    NSData *receivedData = [senderInfoDict objectForKey:@"data"];
    self.receivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    NSLog(@"status:%@",[self.receivedObject valueForKey:@"status"]);
    
    //Get the sender's ID from the received info dictionary
    MCPeerID *senderID = [senderInfoDict objectForKey:@"peerID"];
    NSString *senderDisplayName = senderID.displayName;
    
    //If the received data is "received" or "declined", it means that the data is the response information from receiver
    if ([[self.receivedObject valueForKey:@"staus"]isEqualToString:@"received"]){
        NSString *responseReceiveAlertMessage = [[NSString alloc]initWithFormat:@"%@ has received your businesscard!", senderDisplayName];
        UIAlertView *responseReceiveAlertView = [[UIAlertView alloc] initWithTitle:@"Response Received!" message:responseReceiveAlertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [responseReceiveAlertView show];
        [self.waitingForResponseAlertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    else if ([[self.receivedObject valueForKey:@"staus"]isEqualToString:@"declined"]) {
        NSString *responseDeclineAlertMessage = [[NSString alloc]initWithFormat:@"%@ has declined your businesscard!",senderDisplayName];
        UIAlertView *responseDeclineAlertView = [[UIAlertView alloc] initWithTitle:@"Response Received!" message:responseDeclineAlertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [responseDeclineAlertView show];
        [self.waitingForResponseAlertView dismissWithClickedButtonIndex:0 animated:YES];

        }
    
    //If the received data is neither "received" nor "declined", it means that the data is the businesscard from sender
    else if ([[self.receivedObject valueForKey:@"status"]isEqualToString:@"sending"]){
        NSString *receiveDataAlertMessage = [[NSString alloc] initWithFormat:@"%@ wants to share businesscard with you!", senderDisplayName];
        self.receiveDataAlertView = [[UIAlertView alloc] initWithTitle:@"New BusinessCard Received!" message:receiveDataAlertMessage delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
        [self.receiveDataAlertView show];
    }
}

//  If the target user get the received businesscard notification, we need to respond to the sender according to the target user's clicking
//  If the receiver touch Accept, then he/she will store the businesscard and reply 'received' to the sender
//  If the receiver touch Decline then he/she will drop the businesscard and reply 'declined' to the sender
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == self.receiveDataAlertView){
        if (buttonIndex == 1) {
            NSDictionary *receiveDicReply = @{@"staus":@"received"};
            NSData *receiveReplyData = [NSKeyedArchiver archivedDataWithRootObject:receiveDicReply];
            NSError *error;
            [self.appDelegate.CommunicationHandler.session sendData:receiveReplyData
                                                            toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers
                                                           withMode:MCSessionSendDataReliable error:&error];
            [self savePeopleInfoToLocalDB];
        //When new object was added to local database, refetch the data and reload the UI
            self.peopleInformation = [self fetchRequestResult];
            [self.peopleCollectionView performBatchUpdates:^{[self.peopleCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];} completion:nil];
        }
        if (buttonIndex == 0) {
            NSDictionary *declineDicReply = @{@"staus":@"declined"};
            NSData *declineReplyData = [NSKeyedArchiver archivedDataWithRootObject:declineDicReply];
            NSError *error;
            [self.appDelegate.CommunicationHandler.session sendData:declineReplyData toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
        }
    }
    if (alertView == self.removeCellAlertView){
        if (buttonIndex == 1) {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.managedObjectContext deleteObject:self.removeChosenCell.peopleInfo];
            [app saveContext];
            self.peopleInformation = [self fetchRequestResult];
            [self.peopleCollectionView performBatchUpdates:^{[self.peopleCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];} completion:nil];
        }
    }
    
}
*/

// When the user choose to accept the card, all the information on the card will be stored into local database
/*
- (void)savePeopleInfoToLocalDB
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    People *newPeopleInfo = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:app.managedObjectContext];
    newPeopleInfo.name = [self.receivedObject valueForKey:@"name"];
    newPeopleInfo.selfDescription = [self.receivedObject valueForKey:@"selfDescription"];
    newPeopleInfo.phoneNumber = [self.receivedObject valueForKey:@"phoneNumber"];
    newPeopleInfo.emailAdd = [self.receivedObject valueForKey:@"emailAdd"];
    newPeopleInfo.photo = [self.receivedObject valueForKey:@"photo"];
    [app saveContext];
    NSError *error;
    [app.managedObjectContext save:&error];

}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"commentSegue"]) {
        commentPageViewController *cpc = [segue destinationViewController];
        self.segueDestVC = cpc;
    }
    if ([[segue identifier] isEqualToString:@"addViewSegue"]) {
        AddViewController *avc = [segue destinationViewController];
        [avc setBackgroundImg:self.backgroundImgView.image];
        [avc setCurrentlocation:self.currentlocation];
        NSLog(@"currentPostalCode:::%@",self.currentPostalCode);
    }
}


@end
