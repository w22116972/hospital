//
//  TVCtab2.m
//  hospital
//
//  Created by Edward on 13/8/20.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "TVCtab2.h"
#import "KxMenu.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface TVCtab2 ()

@end

@implementation TVCtab2

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner,latitude,longitude,locationManager,currentLocation;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (void)setupStrings{
    textPull = @"拉下來以更新";
    textRelease = @"放開後開始更新...";
    textLoading = @"載入中...";
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    [locationManager startUpdatingLocation];
    //[self ]

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"請選擇醫院";
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    locationManager = [[CLLocationManager alloc] init];
    currentLocation = [[CLLocation alloc]init];
    [self checkAndCreateDatabase];
    [self getDataFromLevel1];
    [self getDataFromLevel2];
    [self getDataFromLevel3];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self addPullToRefreshHeader];
    /*
    UIButton *qaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qaButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [qaButton setImage:[UIImage imageNamed:@"小幫手 3 (1).png"] forState:UIControlStateNormal];
    qaButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    
    UIBarButtonItem *qaButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qaButton];
    self.navigationItem.rightBarButtonItem = qaButtonItem;
     */
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 4;
            break;
        default:
            return 3;
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sec1=@"重度醫療責任醫院";
    NSString *sec2=@"中度醫療責任醫院";
    NSString *sec3=@"輕度醫療責任醫院";
    NSMutableArray *titleForSec=[[NSMutableArray alloc]initWithObjects:sec1,sec2,sec3,nil];
    return [titleForSec objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellByTab2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    appusers *dataOfLevel1;
    appusers *dataOfLevel2;
    appusers *dataOfLevel3;
    
    switch (indexPath.section) {
        case 0:
            dataOfLevel1=(appusers *)[sortedSec1 objectAtIndex:indexPath.row];
            cell.textLabel.text=dataOfLevel1.name;
            cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.1f km",dataOfLevel1.dis/1000];
            if([dataOfLevel1.color isEqualToString:@"1"]){
               // cell.textLabel.textColor=[UIColor greenColor];
                cell.imageView.image=[UIImage imageNamed:@"綠燈.png"];
            }
            else if ([dataOfLevel1.color isEqualToString:@"2"]){
                //cell.textLabel.textColor=[UIColor yellowColor];
                cell.imageView.image=[UIImage imageNamed:@"黃燈.png"];
            }
            else if([dataOfLevel1.color isEqualToString:@"3"]){
                //cell.textLabel.textColor=[UIColor redColor];
                cell.imageView.image=[UIImage imageNamed:@"紅燈.png"];
            }
            break;
        case 1:
            dataOfLevel2=(appusers *)[sortedSec2 objectAtIndex:indexPath.row];
            cell.textLabel.text=dataOfLevel2.name;
            cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.1f km",dataOfLevel2.dis/1000];
                if([dataOfLevel2.color isEqualToString:@"1"])
                    cell.imageView.image=[UIImage imageNamed:@"綠燈.png"];
                else if ([dataOfLevel2.color isEqualToString:@"2"])
                    cell.imageView.image=[UIImage imageNamed:@"黃燈.png"];
                else if([dataOfLevel2.color isEqualToString:@"3"])
                    cell.imageView.image=[UIImage imageNamed:@"紅燈.png"];
            break;
        case 2:
            dataOfLevel3=(appusers *)[sortedSec3 objectAtIndex:indexPath.row];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.1f km",dataOfLevel3.dis/1000];
            cell.textLabel.text=dataOfLevel3.name;
            if([dataOfLevel3.color isEqualToString:@"1"])
                cell.imageView.image=[UIImage imageNamed:@"綠燈.png"];
            else if ([dataOfLevel3.color isEqualToString:@"2"])
                cell.imageView.image=[UIImage imageNamed:@"黃燈.png"];
            else if([dataOfLevel3.color isEqualToString:@"3"])
                cell.imageView.image=[UIImage imageNamed:@"紅燈.png"];
            break;
        default:
            break;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appusers *dataOfLevel1;
    appusers *dataOfLevel2;
    appusers *dataOfLevel3;
    detailByTab1 *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailByTab1"];
    switch (indexPath.section) {
        case 0:
            dataOfLevel1=(appusers *)[sortedSec1 objectAtIndex:indexPath.row];
            detailViewController.addr=dataOfLevel1.addr;
            detailViewController.tel=dataOfLevel1.tel;
            detailViewController.wait=dataOfLevel1.wait;
            detailViewController.color=dataOfLevel1.color;
            detailViewController.bed=dataOfLevel1.bed;
            detailViewController.title=dataOfLevel1.name;
           // detailViewController.
            break;
        case 1:
            dataOfLevel2=(appusers *)[sortedSec2 objectAtIndex:indexPath.row];
            detailViewController.addr=dataOfLevel2.addr;
            detailViewController.tel=dataOfLevel2.tel;
            detailViewController.wait=dataOfLevel2.wait;
            detailViewController.color=dataOfLevel2.color;
            detailViewController.bed=dataOfLevel2.bed;
            detailViewController.title=dataOfLevel2.name;
            break;
        case 2:
            dataOfLevel3=(appusers *)[sortedSec3 objectAtIndex:indexPath.row];
            detailViewController.addr=dataOfLevel3.addr;
            detailViewController.tel=dataOfLevel3.tel;
            detailViewController.wait=dataOfLevel3.wait;
            detailViewController.color=dataOfLevel3.color;
            detailViewController.bed=dataOfLevel3.bed;
            detailViewController.title=dataOfLevel3.name;
            break;
        default:
            break;
    }
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - code

-(void) checkAndCreateDatabase{
    databaseName = @"v9.sqlite";
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	// If the database already exists then return without doing anything
	if(success) return;
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

-(void) getDataFromLevel1{
    sqlite3 *database;
	sec1Data = [[NSMutableArray alloc] init];
    sortedSec1 = [[NSMutableArray alloc] init];
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level=1";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
           // NSLog(@"prepare ok");
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int pkTemp = sqlite3_column_int(compiledStatement, 0);
                NSString *Pk=[[NSString alloc]initWithFormat:@"%d",pkTemp];
				NSString *Name = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 1) encoding:NSUTF8StringEncoding];
                int levelTemp = sqlite3_column_int(compiledStatement, 2);
                NSString *Level=[[NSString alloc]initWithFormat:@"%d",levelTemp];
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
                NSString *Tel =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,3) encoding:NSUTF8StringEncoding];
                NSString *Col =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,6) encoding:NSUTF8StringEncoding];
                NSString *Wait=[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,7) encoding:NSUTF8StringEncoding];
                double bedTemp = sqlite3_column_double(compiledStatement, 8);
                appusers *user = [[appusers alloc] initWithPk:Pk name:Name level:Level addr:Addr tel:Tel color:Col wait:Wait bed:bedTemp];
                user.dis=sqlite3_column_double(compiledStatement, 9);
                [sec1Data addObject:user];
			}
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sortedSec1=[self sortByDistance:sec1Data];
	}
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }
	sqlite3_close(database);
}

-(void) getDataFromLevel2{
    sqlite3 *database;
	sec2Data = [[NSMutableArray alloc] init];
    sortedSec2 = [[NSMutableArray alloc] init];
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level=2";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int pkTemp = sqlite3_column_int(compiledStatement, 0);
                NSString *Pk=[[NSString alloc]initWithFormat:@"%d",pkTemp];
                
				NSString *Name = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 1) encoding:NSUTF8StringEncoding];
                int levelTemp = sqlite3_column_int(compiledStatement, 2);
                NSString *Level=[[NSString alloc]initWithFormat:@"%d",levelTemp];
    
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
                NSString *Tel =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,3) encoding:NSUTF8StringEncoding];
                NSString *Col =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,6) encoding:NSUTF8StringEncoding];
                NSString *Wait=[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,7) encoding:NSUTF8StringEncoding];
                double bedTemp = sqlite3_column_double(compiledStatement, 8);
                appusers *user = [[appusers alloc] initWithPk:Pk name:Name level:Level addr:Addr tel:Tel color:Col wait:Wait bed:bedTemp];
                user.dis=sqlite3_column_double(compiledStatement, 9);
                [sec2Data addObject:user];
			}
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sortedSec2=[self sortByDistance:sec2Data];
	}
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }
	sqlite3_close(database);
}

-(void) getDataFromLevel3{
    sqlite3 *database;
	sec3Data = [[NSMutableArray alloc] init];
    sortedSec3 = [[NSMutableArray alloc] init];
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level=3";
		sqlite3_stmt *compiledStatement;
       // NSLog(@"open ok");
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int pkTemp = sqlite3_column_int(compiledStatement, 0);
                NSString *Pk=[[NSString alloc]initWithFormat:@"%d",pkTemp];
				NSString *Name = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 1) encoding:NSUTF8StringEncoding];
                int levelTemp = sqlite3_column_int(compiledStatement, 2);
                NSString *Level=[[NSString alloc]initWithFormat:@"%d",levelTemp];
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
                NSString *Tel =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,3) encoding:NSUTF8StringEncoding];
                NSString *Col =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,6) encoding:NSUTF8StringEncoding];
                NSString *Wait=[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,7) encoding:NSUTF8StringEncoding];
                double bedTemp = sqlite3_column_double(compiledStatement, 8);
                appusers *user = [[appusers alloc] initWithPk:Pk name:Name level:Level addr:Addr tel:Tel color:Col wait:Wait bed:bedTemp];
                user.dis=sqlite3_column_double(compiledStatement, 9);
                [sec3Data addObject:user];
                
			}
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
		sqlite3_finalize(compiledStatement);
		sortedSec3=[self sortByDistance:sec3Data];
	}
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }
	sqlite3_close(database);
}

-(NSMutableArray *)sortByDistance:(NSMutableArray *)data{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dis" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [data sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    if (currentLocation == nil) {
        currentLocation = [[CLLocation alloc]init];
    }
    currentLocation = [locations lastObject];
//    NSLog(@"update: %f",currentLocation.coordinate.latitude);
    [locationManager stopUpdatingLocation];
    
    [self checkAndCreateDatabase];
    [self updateDistance];
    [self updateDatabase];
    [self getDataFromLevel1];
    [self getDataFromLevel2];
    [self getDataFromLevel3];
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.5];

}


-(double)parseRoadDisByJSON:(NSString *)adr{
    
    NSString *googleURLByUserLoc =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@,%@&destinations=%@&mode=driving&language=fr-FR&sensor=false",latitude,longitude,adr];
    
    
    NSString *googleURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=22.630292,120.262821&destinations=%@&mode=driving&language=fr-FR&sensor=false",adr];
    
    NSURL *url = [NSURL URLWithString:[googleURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = NULL;
    NSString *theJSONString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    // Parse with TouchJSON
    NSDictionary *replyDict = [NSDictionary dictionaryWithJSONString:theJSONString error:&error];
    NSString *distanceString = [[[[[[replyDict objectForKey:@"rows"] objectAtIndex:0]
                                   objectForKey:@"elements"]
                                  objectAtIndex:0]
                                 objectForKey:@"distance"]
                                objectForKey:@"value"];
    return distanceString.doubleValue;
}

-(void) updateDistance{
    sqlite3 *database;
	appuser = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            int j=0;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
                distance=[self parseRoadDisByJSON:Addr];
                disTest[j]=distance;
                j++;
                if (j==46) {
                    break;
                }
            }
        }
        else
            NSLog(@"%s",sqlite3_errmsg(database));
        sqlite3_finalize(compiledStatement);
    }
    else
        NSLog(@"%s",sqlite3_errmsg(database));
	sqlite3_close(database);
}



@end
