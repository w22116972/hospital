//
//  TVCtab3.h
//  hospital
//
//  Created by Edward on 13/9/2.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "appusers.h"
#import "detailByTab3.h"
//#import "CoreLocation/CoreLocation.

@interface TVCtab3 : UITableViewController{
    NSString *databaseName;
	NSString *databasePath;
    
  //  NSString *flag;
    
}


-(void) checkAndCreateDatabase;

@end
