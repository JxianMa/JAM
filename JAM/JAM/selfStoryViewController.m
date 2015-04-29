//
//  selfStoryViewController.m
//  JAM
//
//  Created by MaJixian on 4/5/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "selfStoryViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "selfStoryTableViewCell.h"
#import "Story.h"
#import "StoryModel.h"
#import "commentPageViewController.h"
#import "DynamoDB.h"

@interface selfStoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *selfStoryTableView;
@property (strong,nonatomic)AppDelegate *appDelegate;
@property (strong,nonatomic)NSArray *selfStoryArray;
@property (strong,nonatomic)commentPageViewController *segueDestVC;
@property (strong,nonatomic) NSNumber *storyId;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;
@property (strong,nonatomic)selfStoryTableViewCell *selectedCellForDelete;

@end

@implementation selfStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selfStoryArray = [self fetchRequestResult];
    self.selfStoryTableView.rowHeight = 70.0f;
    self.selfStoryTableView.allowsMultipleSelectionDuringEditing = NO;
    // Do any additional setup after loading the view.
}

#pragma mark setup database fetching

- (NSMutableArray *)fetchRequestResult
 {
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
     request.predicate = nil;
     request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uploadTime" ascending:NO]];
     [request setReturnsObjectsAsFaults:NO];
     self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     NSError *error;
     NSMutableArray *resultArray = [[NSMutableArray alloc]init];
     resultArray = (NSMutableArray *)[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
     return resultArray;
 }
 


#pragma UITableView delegate, UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selfStoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"selfStoryCell";
    selfStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell = [[selfStoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.selfStoryInfo = [self.selfStoryArray objectAtIndex:(NSUInteger)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selfStoryTableViewCell *cellselected = (selfStoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self deleteFromDynamoDBonSelectedCell:cellselected forTableView:tableView];
        self.selectedCellForDelete = cellselected;
        [self.selfStoryArray objectAtIndex:indexPath.row];
        [self deleteFromLocalDBForTableView:tableView];
    }
}

- (void)deleteFromDynamoDBonSelectedCell:(selfStoryTableViewCell *)cell forTableView:(UITableView *)tableView
{
    //AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    StoryModel *storyToDelete = [[StoryModel alloc]init];
    storyToDelete.postalCode = cell.selfStoryInfo.postalCode;
    storyToDelete.uploadTime = cell.selfStoryInfo.uploadTime;
    storyToDelete.storyId = cell.selfStoryInfo.storyId;
    storyToDelete.storyName = cell.selfStoryInfo.storyName;
    storyToDelete.story = cell.selfStoryInfo.story;
    storyToDelete.storyDescription = cell.selfStoryInfo.storyDescription;
    storyToDelete.photo = cell.selfStoryInfo.photo;
    /*[[dynamoDBObjectMapper remove:storyToDelete]
              continueWithBlock:^id(BFTask *task) {
                  
                  if (task.error) {
                      NSLog(@"The request failed. Error: [%@]", task.error);
                  }
                  if (task.exception) {
                      NSLog(@"The request failed. Exception: [%@]", task.exception);
                  }
                  if (task.result) {
                      //Item deleted.
                      NSLog(@"%@",task.result);
                      [self deleteFromLocalDBForTableView:tableView];
                  }
                  return nil;
              }];*/

}


-(void)deleteFromLocalDBForTableView:(UITableView *)tableView
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"storyId == %@",self.selectedCellForDelete.selfStoryInfo.storyId];
    NSError *error;
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    resultArray = (NSMutableArray *)[app.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"resultArray:%@",resultArray);
    for (NSManagedObject *managedObject in resultArray)
    {
        [app.managedObjectContext deleteObject:managedObject];
    }
    if (!error) {
        NSLog(@"The record has been deleted from local database");
        [app.managedObjectContext save:&error];
        [tableView reloadData];
    } else{
        UIAlertView *logOutAlert = [[UIAlertView alloc] initWithTitle:@"Logout Error" message:@"Something wrong...Please retry later" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [logOutAlert show];
    }
    
}

#pragma UINavigationController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"selfStoryCommentSegue"])
    {
        commentPageViewController *dest = [segue destinationViewController];
        self.segueDestVC = dest;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selfStoryTableViewCell *cellselected = (selfStoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath) {
        [self performSegueWithIdentifier:@"selfStoryCommentSegue" sender:nil];
        //self.segueDestVC.storyImgView.image = cellSelected.imageView.image;
        self.segueDestVC.storyName = cellselected.textLabel.text;
        self.segueDestVC.storyImg = cellselected.imageView.image;
        [self.segueDestVC setLongtitude:[cellselected.selfStoryInfo.longtitude doubleValue]];
        [self.segueDestVC setLatitude:[cellselected.selfStoryInfo.latitude doubleValue]];
        [self.segueDestVC setStoryId:cellselected.selfStoryInfo.storyId];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
