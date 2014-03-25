//
//  initUserLoc.h
//  hospital
//
//  Created by Edward on 10/29/13.
//  Copyright (c) 2013 Edward. All rights reserved.
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
#import "initialView.h"

@interface initUserLoc : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    //double lon,lat;
    
    
}
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;


@end
