//
//  VCQ1.m
//  hospital
//
//  Created by Edward on 13/9/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "VCQ1.h"
#import "VCQ2.h"
#import "TVCtab1.h"
#import "PullRefreshDisTab1.h"
#import "tabBarCtrlDis.h"

@interface VCQ1 ()

@end

@implementation VCQ1

//@synthesize question;

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"側拉 2 (2).png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(IBAction)yesBtn:(id)sender{
    
    //tabBarCtrlDis *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarCtrlDis"];
   // [self.navigationController m]
  //  [self presentViewController:detailViewController animated:YES completion:nil];
   // [self presentModalViewController:detailViewController animated:YES];
    
   // [self performSegueWithIdentifier:@"tabBarCtrlDis" sender:self];
    //[self presentModalViewController:<#(UIViewController *)#> animated:YES];
    
    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"建議" message:@"請考慮立刻就診" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"撥打119",nil];
    
    [alertView show];
    
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self call119];
            break;
        default:
            break;
    }
    
    
}

-(void)call119{
    UIDevice* myDevice = [UIDevice currentDevice];
    if ([myDevice.model isEqualToString:@"iPhone"]) {
        //set phone number
        NSString* urlString =[NSString stringWithFormat:@"tel:119"];
        //open url to call
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        NSString* msgString =@"需要 iphone 才能支援喔！";
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                      message:msgString delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [msg show];
        // [msg release];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
