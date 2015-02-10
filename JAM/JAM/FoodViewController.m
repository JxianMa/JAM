//
//  FoodViewController.m
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodNametagCollectionCell.h"
#import "EBCardCollectionViewLayout.h"
#import "FoodInfo.h"
#import "ViewController.h"

@interface FoodViewController ()

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *peopleData = @[@{@"name": @"Cheese Burger", @"photoName": @"cheeseburger.jpg"},
                            @{@"name": @"Chicken Sandwich", @"photoName": @"chickensandwich.jpg"},
                            @{@"name": @"Big Mac", @"photoName": @"bigmac.jpg"}];
    food = [[NSMutableArray alloc] init];
    for (NSDictionary *personDict in peopleData) {
        FoodInfo    *aPerson = [[FoodInfo alloc] initWithDictionary:personDict];
        [food addObject:aPerson];
    }
    [self setOffsetOfCollectionView];
    UIPanGestureRecognizer * panner=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panner.delegate = foodCollectionView;
    [self.view addGestureRecognizer:panner];
}




/* offset can control size of the card */
- (void) setOffsetOfCollectionView
{
    UIOffset collectionViewOffset = UIOffsetMake(40, 10);
    [(EBCardCollectionViewLayout *) foodCollectionView.collectionViewLayout setOffset:collectionViewOffset];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [food count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodNametagCollectionCell  *retVal = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCollectionViewCell"
                                                                                     forIndexPath:indexPath];
    retVal.foodInfo = food[indexPath.row];
    return retVal;
}



- (BOOL)shouldAutorotate {
    [foodCollectionView.collectionViewLayout invalidateLayout];
    
    BOOL retVal = YES;
    return retVal;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    CGPoint swipeLocation = [gestureRecognizer locationInView:foodCollectionView];
    NSIndexPath *swipedIndexPath = [foodCollectionView indexPathForItemAtPoint:swipeLocation];
    FoodNametagCollectionCell *swipedCell = [foodCollectionView cellForItemAtIndexPath:swipedIndexPath];
    UICollectionViewLayoutAttributes *attributes = [foodCollectionView layoutAttributesForItemAtIndexPath:swipedIndexPath];
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
