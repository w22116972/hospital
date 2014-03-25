//
//  TVCtab1.h
//  hospital
//
//  Created by Edward on 13/8/19.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"

@interface TVCtab1 : UITableViewController <CLLocationManagerDelegate>{
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
    
}

@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) NSString *userAddress;
@property (nonatomic,retain) CLLocation *loc;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

//-(void)findDocPath;
-(void) readDB;
-(void) checkAndCreateDatabase;
-(void) parseRoadDisByJSON:(NSString *)adr;
-(void) sortByDistance;
-(void) getCurrentLocation;



@end
