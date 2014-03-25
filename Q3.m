//
//  Q3.m
//  hospital
//
//  Created by Edward on 11/3/13.
//  Copyright (c) 2013 Edward. All rights reserved.
//

#import "Q3.h"
#import "tabBarCtrlDis.h"

@interface Q3 ()

@end

@implementation Q3{
    NSArray *class;
    NSMutableArray *mulSelect;

}

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
    self.navigationItem.title =@"請選擇科別";
    mulSelect = [[NSMutableArray alloc]init];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    class=@[@"  內科",@"  外科",@"  五官科",@"  婦產科",@"  小兒科",@"  牙科"];
    
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

-(IBAction)initModal{
    tabBarCtrlDis *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarCtrlDis"];
    [self presentViewController:detail animated:YES completion:Nil];
}

-(void)confirmCheck{
   // NSLog(@"bebe");
    detailClassTVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detailClassTVC"];
    NSString *sql = [[NSString alloc]init];
    for (NSIndexPath *index in mulSelect) {
        switch (index.row) {
            case 0:
                sql = [sql stringByAppendingString:@" appambu.medical > 0 AND "];
                break;
            case 1:
                sql = [sql stringByAppendingString:@" appambu.surgical > 0 AND "];
                break;
            case 2:
                sql = [sql stringByAppendingString:@" appambu.five > 0 AND "];
                break;
            case 3:
                sql = [sql stringByAppendingString:@" appambu.woman > 0 AND "];
                break;
            case 4:
                sql = [sql stringByAppendingString:@" appambu.child > 0 AND "];
                break;
            case 5:
                sql = [sql stringByAppendingString:@" appambu.teeth > 0 AND "];
                break;
            default:
                break;
        }
    }
    //  NSLog(@"%@",sql);
    detail.sqlClass= sql;
    // detail.sqlClass = sql;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==6)
        return 72;
    else
        return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellClass";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==6)
        cell.textLabel.text = @"\t確認";
    else
        cell.textLabel.text = class[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image=[UIImage imageNamed:@"內科"];
            break;
        case 1:
            cell.imageView.image=[UIImage imageNamed:@"外科 (1)"];
            break;
        case 2:
            cell.imageView.image=[UIImage imageNamed:@"五官 (2)"];
            break;
        case 3:
            cell.imageView.image=[UIImage imageNamed:@"婦產科 (1)"];
            break;
        case 4:
            cell.imageView.image=[UIImage imageNamed:@"小兒科 (3)"];
            break;
        case 5:
            cell.imageView.image=[UIImage imageNamed:@"mouth (2)"];
            break;
        case 6:
            cell.imageView.image=[UIImage imageNamed:@"yes (2).png"];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    //cell.textLabel.font = [UIFont b]
    // cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.textColor=[UIColor grayColor];
    
    
    if([mulSelect containsObject:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==6) {
        [self confirmCheck];
    }
    else{
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [mulSelect addObject:indexPath];
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [mulSelect removeObject:indexPath];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }

}



@end
