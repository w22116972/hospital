//
//  colorTab2.m
//  hospital
//
//  Created by Edward on 13/9/20.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "colorTab2.h"

@interface colorTab2 (){
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@end

@implementation colorTab2

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
    // [self getCurrentLocation];
    //[self testUpdateDatabase];
    [self checkAndCreateDatabase];
    [self readDB];
    [self sortByDistance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellColorTab2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    appusers *rs=(appusers *)[sortedArray objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.2f m",rs.dis];
    cell.textLabel.text=rs.name;
    if([rs.color isEqualToString:@"1"]){
        //cell.textLabel.textColor=[UIColor greenColor];
        cell.imageView.image=[UIImage imageNamed:@"綠燈.png"];
    }
    else if ([rs.color isEqualToString:@"2"]){
        //cell.textLabel.textColor=[UIColor yellowColor];
        cell.imageView.image=[UIImage imageNamed:@"黃燈.png"];
    }
    // Configure the cell...
    
    return cell;
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

#pragma mark - sqlite

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

-(void) readDB{
    sqlite3 *database;
    appuser = [[NSMutableArray alloc] init];
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id AND appstatus.color < 3";
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
                // NSLog(@"%f",user.dis);
                //   NSLog(@"%f",user.dis);
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


-(void)sortByDistance{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dis" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedArray = [appuser sortedArrayUsingDescriptors:sortDescriptors];
}
@end