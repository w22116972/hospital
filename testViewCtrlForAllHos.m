//
//  testViewCtrlForAllHos.m
//  hospital
//
//  Created by Edward on 10/29/13.
//  Copyright (c) 2013 Edward. All rights reserved.
//

#import "testViewCtrlForAllHos.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 52.0f

@interface testViewCtrlForAllHos ()

@end

@implementation testViewCtrlForAllHos
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


/*
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
 textPull = @"下拉以更新...";
 textRelease = @"放開後來更新...";
 textLoading = @"讀取中...";
 }
 
 - (void)addPullToRefreshHeader {
 refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
 refreshHeaderView.backgroundColor = [UIColor clearColor];
 
 refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
 refreshLabel.backgroundColor = [UIColor clearColor];
 refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
 refreshLabel.textAlignment = NSTextAlignmentCenter;
 
 refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
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
 [self updateDistance];
 [self updateDatabase];
 [self readDatabase];
 [self.tableView reloadData];
 [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
 }
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 - (void) viewDidLayoutSubviews {
 CGRect viewBounds = self.view.bounds;
 CGFloat topBarOffset = self.topLayoutGuide.length;
 viewBounds.origin.y = topBarOffset * -1;
 self.view.bounds = viewBounds;
 }
 */
- (void)loadView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:0];
    self.view = views.lastObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.extendedLayoutIncludesOpaqueBars = NO;
    // self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    locationManager = [[CLLocationManager alloc] init];
    [self checkAndCreateDatabase];
    [self readDatabase];
    [self sortByDistance];
    [self loadView];
    
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //self.tableView.contentInset = UIEdgeInsetsMake(62.0f, 0.0f, 0.0f, 0.0f);
    /*
     self.edgesForExtendedLayout=UIRectEdgeNone;
     self.extendedLayoutIncludesOpaqueBars=NO;
     self.automaticallyAdjustsScrollViewInsets=NO;
     */
    // [self.tableView reloadData];
    // [self addPullToRefreshHeader];
    
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
    NSLog(@"%d",[sortedArray count]);
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [sortedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellAllHos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    appusers *rs=(appusers *)[sortedArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.1f km",rs.dis/1000];
    cell.textLabel.text=rs.name;
    //1=綠 2=黃 3=紅 4=黑 5=問號
    if([rs.color isEqualToString:@"1"]){
        //cell.textLabel.textColor=[UIColor greenColor];
        cell.imageView.image=[UIImage imageNamed:@"綠燈.png"];
    }
    else if ([rs.color isEqualToString:@"2"]){
        //cell.textLabel.textColor=[UIColor yellowColor];
        cell.imageView.image=[UIImage imageNamed:@"黃燈.png"];
    }
    else if([rs.color isEqualToString:@"3"]){
        //cell.textLabel.textColor=[UIColor redColor];
        cell.imageView.image=[UIImage imageNamed:@"紅燈.png"];
    }
    
    return cell;
}

-(void) checkAndCreateDatabase{
    databaseName = @"v7.sqlite";
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


-(void)readDatabase{
    sqlite3 *database;
    appuser = [[NSMutableArray alloc] init];
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
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
                [appuser addObject:user];
            }
        }
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
    }
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }
    
	sqlite3_close(database);
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailByTab1 *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailByTab1"];
    appusers *rs=(appusers *)[sortedArray objectAtIndex:indexPath.row];
    detailViewController.title=rs.name;
    detailViewController.addr=rs.addr;
    detailViewController.tel=rs.tel;
    detailViewController.wait=rs.wait;
    detailViewController.color=rs.color;
    detailViewController.bed=rs.bed;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)sortByDistance{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dis" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedArray = [appuser sortedArrayUsingDescriptors:sortDescriptors];
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

-(void)updateDatabase{
    sqlite3 *database;
	appuser = [[NSMutableArray alloc] init];
    
    NSURL *url= [NSURL URLWithString:@"http://140.117.71.78/hospital/login/iphone.php"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error;
    dataFromJSON=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        sqlite3_stmt *stmt;
        
        for (int i=0; i<45; i++) {
            dicFromJSON = [dataFromJSON objectAtIndex:i];
            NSString *sqlStr = [NSString stringWithFormat:@"UPDATE appstatus SET color = '%@',waitNum = '%@', bed = '%@', dis = '%.1f' WHERE id = '%@'",[dicFromJSON objectForKey:@"color"],[dicFromJSON objectForKey:@"waitNum"],[dicFromJSON objectForKey:@"bed"],disTest[i],[dicFromJSON objectForKey:@"id"]];
            const char *sqlNew=[sqlStr UTF8String];
            if (sqlite3_prepare_v2(database, sqlNew, -1, &stmt, NULL)!=SQLITE_OK)
                NSLog(@"%s",sqlite3_errmsg(database));
            else{
                if (sqlite3_step(stmt)!=SQLITE_DONE)
                    NSLog(@"%s",sqlite3_errmsg(database));
            }
        }
		sqlite3_finalize(stmt);
    }
    else
        NSLog(@"%s",sqlite3_errmsg(database));
	sqlite3_close(database);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - CLLocationManagerDelegate

-(void)getCurrentLocation{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    
    if (newLocation != nil) {
        longitude = [NSString stringWithFormat:@"%.5f", newLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%.5f", newLocation.coordinate.latitude];
    }
    [locationManager stopUpdatingLocation];
    
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
@end
