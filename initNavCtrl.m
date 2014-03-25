//
//  initNavCtrl.m
//  hospital
//
//  Created by Edward on 13/9/28.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "initNavCtrl.h"

@interface initNavCtrl ()

@end

@implementation initNavCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    /*
    UIBarButtonItem *backButton = [UIBarButtonItem new];
    // Put the image inside the button
    [backButton setImage:[UIImage imageNamed:@"back.png"]];
    // [backButton setTitle:NSLocalizedString(@"Back", nil)];
    [[self navigationItem] setBackBarButtonItem:backButton];
	// Do any additional setup after loading the view.
     */
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
