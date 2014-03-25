//
//  VCQ2.m
//  hospital
//
//  Created by Edward on 13/9/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "VCQ2.h"
#import "VCQ3.h"

@interface VCQ2 ()

@end

@implementation VCQ2

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
    if(self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // NSLog(@"test");
        // [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    //[self addSegmentCtrl];
	// Do any additional setup after loading the view.
}

-(IBAction)yesBtn:(id)sender{
    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"建議" message:@"請考慮轉往門診處理" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
