//
//  TVCtab2.h
//  hospital
//
//  Created by Edward on 13/8/20.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"
#import "NSDictionary_JSONExtensions.h"
#import "detailByTab1.h"
#import <QuartzCore/QuartzCore.h>



@interface TVCtab2 : UITableViewController<CLLocationManagerDelegate>{
    NSString *databaseName;
	NSString *databasePath;
    
    NSMutableArray *appuser;
    
    NSMutableArray *sec1Data;
    NSMutableArray *sec2Data;
    NSMutableArray *sec3Data;
    
    NSMutableArray *sortedSec1;
    NSMutableArray *sortedSec2;
    NSMutableArray *sortedSec3;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    double disTest[46];
    double distance;
    
    NSString *latitude,*longitude;
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

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *currentLocation;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

-(void) updateDatabase;
-(void) checkAndCreateDatabase;

-(void) getDataFromLevel1;
-(void) getDataFromLevel2;
-(void) getDataFromLevel3;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end
