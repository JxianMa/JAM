//
//  ViewController.m
//  Jam
//
//  Created by MaJixian on 1/29/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//
#import "ViewController.h"
#import "PeopleViewController.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RPSlidingMenuViewController


-(NSInteger)numberOfItemsInSlidingMenu{
    // 10 for demo purposes, typically the count of some array
    return 8;
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row{
    
    switch (row) {
        case 0:
            slidingMenuCell.textLabel.text = @"For People";
            slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"image2_320x210"];
            break;
        case 1:
            slidingMenuCell.textLabel.text = @"For Food";
            slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"foodMenuBG.jpg"];
            break;
        default:
            slidingMenuCell.textLabel.text = @"For Things";
            slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"image1_320x210"];
            break;
    }
    // alternate for demo.  Simply set the properties of the passed in cell
    /*
     if (row % 2 == 0) {
     slidingMenuCell.textLabel.text = @"People";
     slidingMenuCell.detailTextLabel.text = @"Food";
     slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"image1_320x210"];
     }else{
     
     slidingMenuCell.textLabel.text = @"This Thing Too";
     slidingMenuCell.detailTextLabel.text = @"This thing will blow your mind.";
     slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"image2_320x210"];
     }
     */
}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row{
    
    [super slidingMenu:slidingMenu didSelectItemAtRow:row];
    // when a row is tapped do some action
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Tapped"
     message:[NSString stringWithFormat:@"Row %ld tapped.", (long)row]
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
     [alert show];*/
    switch (row) {
        case 0:
            [self pushPeopleView];
            break;
        case 1:
            [self pushFoodView];
            break;
        default:
            break;
    }
    
    
}

-(void)pushPeopleView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *peopleViewController = [storyboard instantiateViewControllerWithIdentifier:@"peopleViewController"];
    [peopleViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:peopleViewController animated:YES completion:NULL];
}


-(void)pushFoodView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *foodViewController = [storyboard instantiateViewControllerWithIdentifier:@"foodViewController"];
    [foodViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:foodViewController animated:YES completion:NULL];
}

@end
