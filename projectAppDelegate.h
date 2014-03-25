//
//  projectAppDelegate.h
//  hospital
//
//  Created by Edward on 13/8/14.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "appusers.h"
#import <sqlite3.h>
#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"
#import "NSDictionary_JSONExtensions.h"

@interface projectAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
    NSString *databaseName;
	NSString *databasePath;
    
    NSMutableArray *appuser;
    NSMutableArray *sortedArray;
    
    NSMutableArray *dataFromJSON;
    NSDictionary *dicFromJSON;
    
    double distance;
    
    NSString *latitude,*longitude;
    NSString *userAddress;
    CLLocation *loc;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double disTest[46];
    
   // NSNumber lon,lat;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) NSString *userAddress;
@property (nonatomic,retain) CLLocation *loc;
@property (nonatomic,retain) CLLocation *currentLocation;
//@property (nonatomic,retain) NSNumber lon,lat;

-(void) readDB;
-(void) checkAndCreateDatabase;
-(void) loadDataByParse;
-(void) updateDataToDB;



@end
