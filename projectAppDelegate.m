//
//  projectAppDelegate.m
//  hospital
//
//  Created by Edward on 13/8/14.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "projectAppDelegate.h"
#import "CJSONSerializer.h"


@implementation projectAppDelegate

@synthesize currentLocation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    locationManager = [[CLLocationManager alloc] init];
    //CLLocation *clloc = [[CLLocation alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
     */
   // NSLog(@"%f %f",lat,lon);
  //  [self checkAndCreateDatabase];
  //  [self updateDistance];
  //  [self updateDatabase];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    NSLog(@"google: %f ",currentLocation.coordinate.latitude);
    /*
    while (lon == 0.000000 || lat == 0.000000) {
        [locationManager startUpdatingLocation];
      //  NSLog(@"yes");
    }
    */
    NSString *googleURLByUserLoc =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%@&mode=driving&language=fr-FR&sensor=false",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude,adr];
   // NSLog(@"lat:%f/t lon:%f",lat,lon);
    
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
  //  NSLog(@"%f",distanceString.doubleValue);
    return distanceString.doubleValue;
}

-(void)sortByDistance{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dis" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedArray = [appuser sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - CLLocationManagerDelegate

-(void)getCurrentLocation{

   // NSLog(@"test");
}

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
    
  //  clloc = [locations lastObject];
    //float lat,lon;
    //self.lat = currentLocation.coordinate.latitude;
  //  NSLog(@"update: %f",currentLocation.coordinate.latitude);
    //self.lon = currentLocation.coordinate.longitude;
    //NSLog(@"%f %f",lat,lon);
   // latitude = [NSString stringWithFormat:@"%f",lat];
    //longitude = [NSString stringWithFormat:@"%f",lon];
   // NSLog(@"did");
   [locationManager stopUpdatingLocation];
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
