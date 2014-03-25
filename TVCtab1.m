//
//  TVCtab1.m
//  hospital
//
//  Created by Edward on 13/8/19.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "TVCtab1.h"
#import "appusers.h"
#import "detailByTab1.h"
#import "NSDictionary_JSONExtensions.h"
#import "CoreLocation/CoreLocation.h"


@interface TVCtab1 ()

@end

@implementation TVCtab1{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
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
    locationManager = [[CLLocationManager alloc] init];
   // [self getCurrentLocation];
    //[self testUpdateDatabase];
    [self checkAndCreateDatabase];
    [self readDB];
    
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
  //  UIBarButtonItem *barBtnItem=[[UIBarButtonItem alloc]init];
   
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sortedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellByTab1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    appusers *rs=(appusers *)[sortedArray objectAtIndex:indexPath.row];

    //1=綠 2=黃 3=紅 4=黑 5=問號
    if ([rs.color isEqualToString:@"0"]) {
        cell.textLabel.textColor=[UIColor blueColor];
       // cell.imageView.image=[UIImage imageNamed:@"red.jpg"];
    }
    else if([rs.color isEqualToString:@"1"]){
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
    else if ([rs.color isEqualToString:@"4"]){
        cell.textLabel.textColor=[UIColor blackColor];
    }
    else if ([rs.color isEqualToString:@"5"]){
        cell.textLabel.textColor=[UIColor purpleColor];
    }

    cell.detailTextLabel.text=[NSString stringWithFormat:@"目前距離:%.2f m",rs.dis];
    cell.textLabel.text=rs.name;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
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
    //[detailViewController ]
     
}

#pragma mark - code

-(void) checkAndCreateDatabase{
    databaseName = @"v3.sqlite";
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
	
	// Init the animals Array
	appuser = [[NSMutableArray alloc] init];
	//NSLog(@"start");
	// Open the database from the users filessytem
    
    NSURL *url= [NSURL URLWithString:@"http://140.117.71.78/hospital/login/iphone.php"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error;
    dataFromJSON=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //dicFromJSON =[dataFromJSON objectEnumerator];
    dicFromJSON = [dataFromJSON objectAtIndex:0];
  
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        
        int ret;
		// Setup the SQL Statement and compile it for faster access
        
		const char *sql = "UPDATE appstatus SET color = ?, waitNum = ?, bed = ? WHERE id = ?";
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [[dicFromJSON objectForKey:@"color"]UTF8String],-1,NULL);
            sqlite3_bind_text(stmt, 2, [[dicFromJSON objectForKey:@"waitNum"]UTF8String], -1, NULL);
          //sqlite3_bind_double(<#sqlite3_stmt *#>, <#int#>, <#double#>)
          //double bedTemp = [dicFromJSON objectForKey:@"bed"];
            sqlite3_bind_text(stmt, 3, [[dicFromJSON objectForKey:@"bed"]UTF8String],-1,NULL);
            sqlite3_bind_text(stmt, 4, [[dicFromJSON objectForKey:@"id"]UTF8String], -1, NULL);
			// Loop through the results and add them to the feeds array
            if((ret=sqlite3_step(stmt))!= SQLITE_DONE){
                NSAssert1(0,@"Error updating values [%s]", sqlite3_errmsg(database));
            }
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
         
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
        
		// Setup the SQL Statement and compile it for faster access
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
                
                [self parseRoadDisByJSON:Addr];
         
                appusers *user = [[appusers alloc] initWithPk:Pk name:Name level:Level addr:Addr tel:Tel color:Col wait:Wait bed:bedTemp];
				user.dis=distance;
				[appuser addObject:user];
            }
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        [self sortByDistance];
	}
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }

	sqlite3_close(database);
	
}

-(void)parseRoadDisByJSON:(NSString *)adr{
   // NSLog(@"long:%@ lat:%@",longitude,latitude);
    
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
    distance = distanceString.doubleValue;
   // NSLog(@"%.2f",distance);
}

-(void)sortByDistance{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dis" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedArray = [appuser sortedArrayUsingDescriptors:sortDescriptors];
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
    
    
   // NSLog(@"long:%@ lat:%@",longitude,latitude);
    //NSLog(@"test");
    // retrieve data once then stop
     /*
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] >0) {
            placemark = [placemarks lastObject];
            userAddress = [NSString stringWithFormat:@"%@+%@+%@+%@+%@+%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    NSLog(@"%@",userAddress);
    */
}

@end
