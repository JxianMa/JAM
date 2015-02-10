//
//  BrowseDeviceViewController.m
//  Jam
//
//  Created by MaJixian on 2/9/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "BrowseDeviceViewController.h"
#import "AppDelegate.h"

@interface BrowseDeviceViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation BrowseDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConnection];
    [self searchForDevices];
    // Do any additional setup after loading the view.
}

- (void)setupConnection
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.CommunicationHandler setupConnectionWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.CommunicationHandler setupSession];
    [self.appDelegate.CommunicationHandler advertiseSelf];

}

- (void)searchForDevices
{
    if (self.appDelegate.CommunicationHandler.session != nil) {
        [[self.appDelegate CommunicationHandler] setupBrowser];
        [[[self.appDelegate CommunicationHandler] browser] setDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
