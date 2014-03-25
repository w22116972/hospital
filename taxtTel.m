//
//  taxtTel.m
//  hospital
//
//  Created by Edward on 13/8/22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "taxtTel.h"

@interface taxtTel ()

@end

@implementation taxtTel
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellByTaxi";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"中華衛星車隊";
    }
    else if(indexPath.row==1){
        cell.textLabel.text=@"台灣大車隊";
    }
    else if (indexPath.row==2){
        cell.textLabel.text=@"尚無";
    }
    // Configure the cell...
    
    return cell;
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIDevice* myDevice = [UIDevice currentDevice];
    if ([myDevice.model isEqualToString:@"iPhone"]) {
        //set phone number
        if (indexPath.row==0) {
            NSString* urlString =[NSString stringWithFormat:@"tel:0800087778"];
            //open url to call
            NSLog(@"0800");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        else if(indexPath.row==1){
            NSString* urlString =[NSString stringWithFormat:@"tel:55688"];
            NSLog(@"55688");
            //open url to call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }

    }
    else{
        NSString* msgString =@"Your iOS Device is not supoorted!";
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                      message:msgString delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        [msg show];
        // [msg release];
    }

    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
