//
//  detailByTab1.m
//  hospital
//
//  Created by Edward on 13/8/21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "detailByTab1.h"
#import "KxMenu.h"

@interface detailByTab1 ()


@end


@implementation detailByTab1

// object..
@synthesize name,addr,tel,level,pk,color,wait,bed;
// IBOulet..
@synthesize waitNum,address,telphone,colorLamp,bedRate,hosName,smile;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.text = str;
    //label.textColor
    self.navigationItem.titleView= label;
   // self.navigationItem.
    [label sizeToFit];
     */
    /*
    UIButton *qaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qaButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [qaButton setImage:[UIImage imageNamed:@"小幫手 3 (1).png"] forState:UIControlStateNormal];
    qaButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    
    UIBarButtonItem *qaButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qaButton];
    self.navigationItem.rightBarButtonItem = qaButtonItem;
    */
    
   // UILabel *label = [UILabel alloc];
    
    address.text = addr;
    address.font = [UIFont fontWithName:@"Arial" size:19.0];
    
    
    telphone.text = tel;
    telphone.font = [UIFont fontWithName:@"Arial" size:19.0];
    
    waitNum.text = [NSString stringWithFormat:@"%@",wait];
    waitNum.font = [UIFont fontWithName:@"Arial" size:19.0];
    
    
    bedRate.text = [NSString stringWithFormat:@"%.1f%%",bed*100];
    bedRate.font = [UIFont fontWithName:@"Arial" size:20.0];
    
    hosName.text = str;
    hosName.font = [UIFont fontWithName:@"Arial" size:18.0];
    //hosName.textColor =
    
    
    if ([color isEqualToString:@"1"]) {
        colorLamp.text = @"悠閒";
        colorLamp.font = [UIFont fontWithName:@"Arial" size:18.0];
       // colorLamp.textColor = [UIColor greenColor];
        smile.image = [UIImage imageNamed:@"綠燈.png"];
        
    }
    else if([color isEqualToString:@"2"]){
        colorLamp.text = @"普通";
        colorLamp.font = [UIFont fontWithName:@"Arial" size:18.0];
       // colorLamp.textColor = [UIColor yellowColor];
        smile.image = [UIImage imageNamed:@"黃燈.png"];
    }
    else{
        colorLamp.text = @"擁塞";
        colorLamp.font = [UIFont fontWithName:@"Arial" size:18.0];
      //  colorLamp.textColor = [UIColor redColor];
        smile.image = [UIImage imageNamed:@"紅燈.png"];
    }
   
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
    //[self.view addSubview:label];
    	
}
/*
- (IBAction)toolbarItemTapped:(id)sender
{
    MyViewController* content = [[MyViewController alloc] init];
    UIPopoverController* aPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:content];
    aPopover.delegate = self;
    
    // Store the popover in a custom property for later use.
    self.popoverController = aPopover;
    
    [self.popoverController presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
 */

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      /*
      [KxMenuItem menuItem:@"可愛的小幫手"
                     image:nil
                    target:nil
                    action:NULL],
      */
      [KxMenuItem menuItem:@"：急診佔床比率"
                     image:[UIImage imageNamed:@"急診佔床比率(圖)"]
                    target:self
                    action:NULL],
      
      [KxMenuItem menuItem:@"：等候人數"
                     image:[UIImage imageNamed:@"等候人數(圖)"]
                    target:self
                    action:NULL],
      
      [KxMenuItem menuItem:@"：急診壅塞狀況"
                     image:[UIImage imageNamed:@"緊急壅塞狀況(圖)"]
                    target:self
                    action:NULL],
      
      [KxMenuItem menuItem:@"讀取中..."
                     image:nil
                    target:self
                    action:NULL],
      /*
      [KxMenuItem menuItem:@"Go home"
                     image:[UIImage imageNamed:@"home_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
       */
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)googleMap{
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",addr];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

-(IBAction)call119{
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

-(IBAction)callTel{
    UIDevice* myDevice = [UIDevice currentDevice];
    if ([myDevice.model isEqualToString:@"iPhone"]) {
        //set phone number
        NSString* urlString =[NSString stringWithFormat:@"tel:%@",tel];
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


@end
