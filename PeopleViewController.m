//
//  PeopleViewController.m
//  Jam01
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "PeopleViewController.h"
#import "NameTagCollectionViewCell.h"
#import "EBCardCollectionViewLayout.h"
#import "ObjectInfo.h"
#import "ViewController.h"

@interface PeopleViewController ()

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
}




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
        if (cardPosition.y > attributes.center.y/2)
        {
            NSLog(@"Start sending");
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // Dragging has ended.
        // You could add layout constraints back to the content view here.
        CGPoint restorePosition = cellRecorder.center;
        restorePosition.y = orignialPosition.y;
        cellRecorder.center = restorePosition;
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
        
    }
    
}
- (IBAction)backButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *backToMain = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [backToMain setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:backToMain animated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
