//
//  initialView.m
//  hospital
//
//  Created by Edward on 13/8/24.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "initialView.h"


@interface initialView ()

@end

@implementation initialView

@synthesize lat,lon,locationManager,currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    locationManager = [[CLLocationManager alloc] init];
    currentLocation = [[CLLocation alloc]init];
    //CLLocation *clloc = [[CLLocation alloc]init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    NSString *error;
    if (![CLLocationManager locationServicesEnabled]) {
        error = @"Error message";
        NSLog(@"locServiceNotEnable");
    }
    
    
    [self.locationManager startUpdatingLocation];
    // NSLog(@"willAppear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
    locationManager = [[CLLocationManager alloc] init];
    //CLLocation *clloc = [[CLLocation alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
     */
 //   NSLog(@"initView %@",lon);
  //  [self checkAndCreateDatabase];
  //  [self updateDistance];
  //  [self updateDatabase];
    
   // NSLog(@"%f %f",lat,lon);
    self.view.backgroundColor=[UIColor blackColor];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(initViewCtrl:) userInfo:nil repeats:false];
	// Do any additional setup after loading the view.
}

-(void) initViewCtrl:(NSTimer *)timer{
    
    [self performSegueWithIdentifier:@"initViewCtrl" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    lon = [[NSString alloc]init];
    lat = [[NSString alloc]init];
    
    lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
  //  NSLog(@"%@",lon);
    [self checkAndCreateDatabase];
    [self updateDistance];
    [self updateDatabase];
    
    
    [locationManager stopUpdatingLocation];

    
    //  clloc = [locations lastObject];
    //float lat,lon;
    //self.lat = currentLocation.coordinate.latitude;
  //  NSLog(@"initial view update: %f",currentLocation.coordinate.latitude);
    //self.lon = currentLocation.coordinate.longitude;
    //NSLog(@"%f %f",lat,lon);
    // latitude = [NSString stringWithFormat:@"%f",lat];
    //longitude = [NSString stringWithFormat:@"%f",lon];
    // NSLog(@"did");
    
    
    //  NSLog(@"stop");
    // NSLog(@"%f %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
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

-(void)updateDatabase{
    sqlite3 *database;
	// Init the animals Array
	appuser = [[NSMutableArray alloc] init];
    
    //NSMutableArray *disTemp = [[NSMutableArray alloc]init];
    // double disTest[46];
    
    NSURL *url= [NSURL URLWithString:@"http://140.117.71.78/hospital/login/iphone.php"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error;
    dataFromJSON=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //dicFromJSON =[dataFromJSON objectEnumerator];
    
    
    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        
   //     const char *sql = "UPDATE appstatus SET color = ?, waitNum = ?, bed = ?, dis = ? WHERE id = ?";
        sqlite3_stmt *stmt;
     //   NSLog(@"open");
        for (int i=0; i<45; i++) {
            
          // NSLog(@"213131313123");
            dicFromJSON = [dataFromJSON objectAtIndex:i];
     //       NSNumber *disNum = [NSNumber numberWithDouble:disTest[i]];
            NSString *sqlStr = [NSString stringWithFormat:@"UPDATE appstatus SET color = '%@',waitNum = '%@', bed = '%@', dis = '%.1f' WHERE id = '%@'",[dicFromJSON objectForKey:@"color"],[dicFromJSON objectForKey:@"waitNum"],[dicFromJSON objectForKey:@"bed"],disTest[i],[dicFromJSON objectForKey:@"id"]];
            const char *sqlNew=[sqlStr UTF8String];
            if (sqlite3_prepare_v2(database, sqlNew, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"%s",sqlite3_errmsg(database));
            }
            else{
                if (sqlite3_step(stmt)!=SQLITE_DONE) {
                    NSLog(@"%s",sqlite3_errmsg(database));
                }
            }
            
            //2
            /*
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
             dicFromJSON = [dataFromJSON objectAtIndex:i];
             if (sqlite3_bind_text(stmt, 1, [[dicFromJSON objectForKey:@"color"]UTF8String],-1,NULL)==SQLITE_OK) {
             NSLog(@"1st bind ok");
             if(sqlite3_step(stmt)!=SQLITE_DONE)
             NSLog(@"%s",sqlite3_errmsg(database));
             }
             }
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
             if (sqlite3_bind_text(stmt, 1, [[dicFromJSON objectForKey:@"color"]UTF8String],-1,NULL)==SQLITE_OK)
             NSLog(@"2nd bind ok");
             }
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK)
             sqlite3_bind_text(stmt, 2, [[dicFromJSON objectForKey:@"waitNum"]UTF8String], -1, NULL);
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK)
             sqlite3_bind_text(stmt, 3, [[dicFromJSON objectForKey:@"bed"]UTF8String],-1,NULL);
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
             NSNumber *disNum = [NSNumber numberWithDouble:disTest[i]];
             if (sqlite3_bind_text(stmt, 4, [[disNum stringValue]UTF8String], -1, NULL)==SQLITE_OK) {
             NSLog(@"dis bind ok");
             if (sqlite3_step(stmt)!=SQLITE_DONE)
             NSLog(@"%s",sqlite3_errmsg(database));
             }
             else
             NSLog(@"%s",sqlite3_errmsg(database));
             }
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK)
             sqlite3_bind_text(stmt, 5, [[dicFromJSON objectForKey:@"id"]UTF8String],-1,NULL);
             */
            
            //3
            /*
             if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
             dicFromJSON = [dataFromJSON objectAtIndex:i];
             if (sqlite3_bind_text(stmt, 1, [[dicFromJSON objectForKey:@"color"]UTF8String],-1,NULL)==SQLITE_OK) {
             NSLog(@"1st bind ok");
             if(sqlite3_step(stmt)!=SQLITE_DONE)
             NSLog(@"%s",sqlite3_errmsg(database));
             }
             else
             NSLog(@"bind 1 %s",sqlite3_errmsg(database));
             
             if (sqlite3_bind_text(stmt, 1, [[dicFromJSON objectForKey:@"color"]UTF8String],-1,NULL)==SQLITE_OK)
             NSLog(@"2nd bind ok");
             else
             NSLog(@"bind 2 %s",sqlite3_errmsg(database));
             sqlite3_bind_text(stmt, 2, [[dicFromJSON objectForKey:@"waitNum"]UTF8String], -1, NULL);
             sqlite3_bind_text(stmt, 3, [[dicFromJSON objectForKey:@"bed"]UTF8String],-1,NULL);
             NSNumber *disNum = [NSNumber numberWithDouble:disTest[i]];
             if (sqlite3_bind_text(stmt, 4, [[disNum stringValue]UTF8String], -1, NULL)==SQLITE_OK) {
             NSLog(@"dis bind ok");
             if (sqlite3_step(stmt)!=SQLITE_DONE)
             NSLog(@"%s",sqlite3_errmsg(database));
             }
             else
             NSLog(@"bind 4 %s",sqlite3_errmsg(database));
             sqlite3_bind_text(stmt, 5, [[dicFromJSON objectForKey:@"id"]UTF8String],-1,NULL);
             }
             */
        }
     //   NSLog(@"final");
		sqlite3_finalize(stmt);
    }
    else
        NSLog(@"%s",sqlite3_errmsg(database));
	sqlite3_close(database);
}

-(void) checkAndCreateDatabase{
    databaseName = @"v9.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSLog(@"%@",[documentPaths objectAtIndex:0]);

    NSString *documentsDir = [documentPaths objectAtIndex:0];
	// Get the path to the documents directory and append the databaseName
	
   // NSLog(@"%@",[documentPaths objectAtIndex:0]);
	
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    //databasePath = [documentPaths stringByAppendingPathComponent:databaseName];
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

-(double)parseRoadDisByJSON:(NSString *)adr{
   // NSLog(@"initialView google lat: %f ",currentLocation.coordinate.latitude);
    /*
     while (lon == 0.000000 || lat == 0.000000) {
     [locationManager startUpdatingLocation];
     //  NSLog(@"yes");
     }
     */
    NSString *googleURLByUserLoc =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@,%@&destinations=%@&mode=driving&language=fr-FR&sensor=false",lat,lon,adr];
    // NSLog(@"lat:%f/t lon:%f",lat,lon);
    
    NSString *googleURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=22.630292,120.262821&destinations=%@&mode=driving&language=fr-FR&sensor=false",adr];
    
    NSURL *url = [NSURL URLWithString:[googleURLByUserLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = NULL;
    NSString *theJSONString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    // Parse with TouchJSON
    NSDictionary *replyDict = [NSDictionary dictionaryWithJSONString:theJSONString error:&error];
    NSString *distanceString = [[[[[[replyDict objectForKey:@"rows"] objectAtIndex:0]
                                   objectForKey:@"elements"]
                                  objectAtIndex:0]
                                 objectForKey:@"distance"]
                                objectForKey:@"value"];
    //  NSLog(@"%f",distanceString.doubleValue);
    return distanceString.doubleValue;
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
                //NSLog(@"%@",Addr);
                distance=[self parseRoadDisByJSON:Addr];
           //     NSLog(@"initialView google %f",distance);
                disTest[j]=distance;
                j++;

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
