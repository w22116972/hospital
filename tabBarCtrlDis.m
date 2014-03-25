//
//  tabBarCtrlDis.m
//  hospital
//
//  Created by Edward on 13/9/21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "tabBarCtrlDis.h"
#import "KxMenu.h"

@interface tabBarCtrlDis ()

@end

@implementation tabBarCtrlDis{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double disTest[46];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLayoutSubviews {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * 0.05;
        self.view.bounds = viewBounds;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // locationManager = [[CLLocationManager alloc] init];
    //[self checkAndCreateDatabase];
    //[self readDB];
    //[self updateDatabase];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"側拉 2 (2).png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    /*
    UIButton *qaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qaButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [qaButton setImage:[UIImage imageNamed:@"小幫手 3 (1).png"] forState:UIControlStateNormal];
    qaButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
    
    UIBarButtonItem *qaButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qaButton];
    self.navigationItem.rightBarButtonItem = qaButtonItem;
    */

    
    
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"可愛的小幫手"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"：等候人數少"
                     image:[UIImage imageNamed:@"綠燈 (1)"]
                    target:self
                    action:NULL],
      
      [KxMenuItem menuItem:@"：等候人數中"
                     image:[UIImage imageNamed:@"黃燈 (1)"]
                    target:self
                    action:NULL],
      
      [KxMenuItem menuItem:@"：等候人數高"
                     image:[UIImage imageNamed:@"紅燈 (1)"]
                    target:self
                    action:NULL],
      
     /* [KxMenuItem menuItem:@"讀取中..."
                     image:nil
                    target:self
                    action:NULL],
      
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

#pragma mark - Sqlite

-(void) readDB{
    sqlite3 *database;
	
	// Init the animals Array
	appuser = [[NSMutableArray alloc] init];
    
   // NSMutableArray *disTemp = [[NSMutableArray alloc]init];
   // double disTest[46];
    
    /*
    NSURL *url= [NSURL URLWithString:@"http://140.117.71.78/hospital/login/iphone.php"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSError *error;
    dataFromJSON=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    */
    //dicFromJSON =[dataFromJSON objectEnumerator];

    if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        
        const char *sqlStatement = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            int j=0;
			// Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
              //  NSLog(@"%@",[NSString stringWithFormat:Addr]);
               distance=[self parseRoadDisByJSON:Addr];
               // NSLog(@"%f",distance);
              //  disTest[j++] = [self parseRoadDisByJSON:Addr];
               //NSLog(@"%f",[self parseRoadDisByJSON:Addr]);
                disTest[j]=distance;
               // NSLog(@"%f",disTest[j]);
                j++;
                if (j==46) {
                    break;
                }
               // NSLog(@"%f",disTest[j]);
                /*
                NSNumber *num = [NSNumber numberWithFloat:distance];
                [disTemp addObject:num];
                 */
               // disTest[j++]=distance;
                 
            }
        }
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(compiledStatement);
        /*
        const char *sql = "UPDATE appstatus SET color = ?, waitNum = ?, bed = ?, dis = ? WHERE id = ?";
        sqlite3_stmt *stmt;
         
        for (int i=0; i<45; i++) {
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
        }
		sqlite3_finalize(stmt);
         */
    }
    else
        NSLog(@"%s",sqlite3_errmsg(database));
	sqlite3_close(database);
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
        
        const char *sql = "UPDATE appstatus SET color = ?, waitNum = ?, bed = ?, dis = ? WHERE id = ?";
        sqlite3_stmt *stmt;
        
        for (int i=0; i<45; i++) {
            dicFromJSON = [dataFromJSON objectAtIndex:i];
            NSNumber *disNum = [NSNumber numberWithDouble:disTest[i]];
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
		sqlite3_finalize(stmt);
    }
    else
        NSLog(@"%s",sqlite3_errmsg(database));
	sqlite3_close(database);
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
