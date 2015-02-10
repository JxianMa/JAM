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
#import "ObjectInfo.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface PeopleViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

//Name problems still not solved.
@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *peopleData = @[@{@"name": @"Jixian", @"photoName": @"JixianMa.JPG"},
                            @{@"name": @"Mardhurima", @"photoName": @"2.JPG"},
                            @{@"name": @"Allen", @"photoName": @"3.JPG"}];
    people = [[NSMutableArray alloc] init];
    for (NSDictionary *personDict in peopleData) {
    ObjectInfo *aPerson = [[ObjectInfo alloc] initWithDictionary:personDict];
        [people addObject:aPerson];
    }
    [self setOffsetOfCollectionView];
    UIPanGestureRecognizer * panner=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panner.delegate = peopleCollectionView;
    [self.view addGestureRecognizer:panner];
    [self setupConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"JAM_DidReceiveDataNotification"
                                               object:nil];
}

- (void)addNameTag
{
    NSArray *addPeopleData = @[@{@"name":@"123",@"photoName":@"222.JPG"}];
    for (NSDictionary *addPeopleDict in addPeopleData) {
        ObjectInfo *addPerson = [[ObjectInfo alloc] initWithDictionary:addPeopleDict];
        [people addObject:addPerson];
    }
}

#pragma mark Communication setup

- (void)setupConnection
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.CommunicationHandler setupConnectionWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.CommunicationHandler setupSession];
    [self.appDelegate.CommunicationHandler advertiseSelf];
    
}
- (IBAction)searchNearbyDevices:(UIBarButtonItem *)sender
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


#pragma mark CollectionView setup

/* offset can control size of the card */
- (void) setOffsetOfCollectionView
{
    UIOffset collectionViewOffset = UIOffsetMake(40, 10);
    [(EBCardCollectionViewLayout *) peopleCollectionView.collectionViewLayout setOffset:collectionViewOffset];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [people count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NameTagCollectionViewCell  *retVal = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionViewCell"
                                                                                   forIndexPath:indexPath];
    retVal.personInfo = people[indexPath.row];
    return retVal;
}



- (BOOL)shouldAutorotate {
    [peopleCollectionView.collectionViewLayout invalidateLayout];
    
    BOOL retVal = YES;
    return retVal;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    CGPoint swipeLocation = [gestureRecognizer locationInView:peopleCollectionView];
    NSIndexPath *swipedIndexPath = [peopleCollectionView indexPathForItemAtPoint:swipeLocation];
    NameTagCollectionViewCell *swipedCell = [peopleCollectionView cellForItemAtIndexPath:swipedIndexPath];
    UICollectionViewLayoutAttributes *attributes = [peopleCollectionView layoutAttributesForItemAtIndexPath:swipedIndexPath];
    UICollectionViewCell *cellRecorder = swipedCell;
    CGPoint orignialPosition = attributes.center;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // Start of the gesture.
        // You could remove any layout constraints that interfere
        // with changing of the position of the content view.
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //if you swipe outside of the bounds of the collection view,
        //we can't resolve which cell it's over. So this ignores any
        //swipes outside the view and saves a ref to the last valid cell
        if(!swipedCell)
            return;
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        CGPoint cardPosition = swipedCell.center;
        cardPosition.y += translation.y;
        swipedCell.center = cardPosition;
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
        //if (cardPosition.y > attributes.center.y/3)
        //{
          //  [self startSendingBusinesscard:swipedCell];
            // NSLog(@"Start sending");
        //}
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // Dragging has ended.
        // You could add layout constraints back to the content view here.
        CGPoint restorePosition = cellRecorder.center;
        restorePosition.y = orignialPosition.y;
        cellRecorder.center = restorePosition;
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
        [self startSendingBusinesscard:swipedCell];
        NSLog(@"Start sending");
    }
    
}
- (IBAction)backButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *backToMain = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [backToMain setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:backToMain animated:YES completion:NULL];
}

#pragma mark Sending and receiving businesscard and response

- (void)startSendingBusinesscard:(NameTagCollectionViewCell *)cardToSend
{
    NSString *messageToSend = cardToSend.personInfo.name;
    NSData *dataToSend = [messageToSend dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    [self.appDelegate.CommunicationHandler.session sendData:dataToSend toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    if (error != nil) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (void)handleReceivedDataWithNotification:(NSNotification *)notification
{
    //Get the notification of the receiving data, including the sender's id and the data that has been sent
    NSDictionary *senderInfoDict = [notification userInfo];
    //Convert the received data to its orignial format
    NSData *receivedData = [senderInfoDict objectForKey:@"data"];
    NSString *messageReceived = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    //Get the sender's ID from the received info dictionary
    MCPeerID *senderID = [senderInfoDict objectForKey:@"peerID"];
    NSString *senderDisplayName = senderID.displayName;
    //If the received data is "received" or "declined", it means that this is the response information from receiver
    if ([messageReceived isEqualToString:@"received"]) {
        NSString *responseReceiveAlertMessage = [[NSString alloc]initWithFormat:@"%@ has received your businesscard!", senderDisplayName];
        UIAlertView *responseReceiveAlertView = [[UIAlertView alloc] initWithTitle:@"Response Received!" message:responseReceiveAlertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [responseReceiveAlertView show];
    }
    else if ([messageReceived isEqualToString:@"declined"]) {
        NSString *responseDeclineAlertMessage = [[NSString alloc]initWithFormat:@"%@ has declined your businesscard!",senderDisplayName];
        UIAlertView *responseDeclineAlertView = [[UIAlertView alloc] initWithTitle:@"Response Received!" message:responseDeclineAlertMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [responseDeclineAlertView show];
    }
    else {
        NSString *receiveDataAlertMessage = [[NSString alloc] initWithFormat:@"%@ wants to share businesscard with you!", senderDisplayName];
        UIAlertView *receiveDataAlertView = [[UIAlertView alloc] initWithTitle:@"New BusinessCard Received!" message:receiveDataAlertMessage delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
        [receiveDataAlertView show];
    }
}

//  If the target user get the received businesscard notification, we need to respond to the sender according to the target user's clicking
//  If the receiver touch Accept, then he/she will store the businesscard and reply 'received' to the sender
//  If the receiver touch Decline then he/she will drop the businesscard and reply 'declined' to the sender
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *receiveReply = @"received";
        NSData *receiveReplyData = [receiveReply dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        [self.appDelegate.CommunicationHandler.session sendData:receiveReplyData
                                                        toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers
                                                       withMode:MCSessionSendDataReliable error:&error];
    }
    if (buttonIndex == 0) {
        NSString *declineReply = @"declined";
        NSData *declineReplyData = [declineReply dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        [self.appDelegate.CommunicationHandler.session sendData:declineReplyData toPeers:self.appDelegate.CommunicationHandler.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    }
}

@end
