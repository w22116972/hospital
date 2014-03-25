//
//  disTab2.h
//  hospital
//
//  Created by Edward on 13/9/24.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "appusers.h"
#import "CoreLocation/CoreLocation.h"
#import "SWRevealViewController.h"
#import "detailByTab1.h"

@interface disTab2 : UITableViewController{
    NSString *databaseName;
	NSString *databasePath;
    NSMutableArray *appuser;
    NSMutableArray *sortedArray;
    

}
@end
