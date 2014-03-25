//
//  initialView.h
//  hospital
//
//  Created by Edward on 13/8/24.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import <sqlite3.h>
#import "appusers.h"
#import <sqlite3.h>
#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"
#import "NSDictionary_JSONExtensions.h"

@interface initialView : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *lon,*lat;
    
    NSString *databaseName;
	NSString *databasePath;
    
    NSMutableArray *appuser;
    NSMutableArray *sortedArray;
    
    NSMutableArray *dataFromJSON;
    NSDictionary *dicFromJSON;
    
    double disTest[50];
    double distance;
}
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,strong) NSString *lon;
@property (nonatomic,strong) NSString *lat;

@end
