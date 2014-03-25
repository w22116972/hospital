//
//  detailByTab3.h
//  hospital
//
//  Created by Edward on 13/9/3.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVCtab3.h"
#import <sqlite3.h>
#import "appusers.h"


@interface detailByTab3 : UITableViewController{
    NSInteger flag;
    NSString *databaseName;
	NSString *databasePath;
    NSMutableArray *dataIsSelected;
}

@property (nonatomic) NSInteger flag;

-(void) deterHospital;

@end
