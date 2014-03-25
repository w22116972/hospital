//
//  detailClassTVC.h
//  newProject
//
//  Created by Edward on 13/10/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
//#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "NSDictionary_JSONExtensions.h"
#import "appambuClass.h"
#import "KxMenu.h"

@interface detailClassTVC : UITableViewController<CLLocationManagerDelegate>{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
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
    double disTest[50];
    
    //int flag;
    int CLASS;
    //int SYM;
    
    NSArray *strClass;
    //NSMutableArray *whatData;
    
    NSString *sqlClass;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) NSString *userAddress;
@property (nonatomic,retain) CLLocation *loc;

@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;


//@property (nonatomic) int flag;
@property (nonatomic) int CLASS;
//@property (nonatomic) int SYM;
//@property (nonatomic)double disTest[];
@property (nonatomic,retain) NSArray *strClass;

@property (nonatomic,strong) NSString *sqlClass;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;


@end
