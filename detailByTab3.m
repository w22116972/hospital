//
//  detailByTab3.m
//  hospital
//
//  Created by Edward on 13/9/3.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "detailByTab3.h"
#import "detailByTab1.h"

@interface detailByTab3 ()

@end

@implementation detailByTab3

@synthesize flag;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkAndCreateDatabase];
    [self deterHospital];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataIsSelected count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailByTab3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    appusers *data=(appusers*)[dataIsSelected objectAtIndex:indexPath.row];
    cell.textLabel.text=data.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"等候人數:%@",data.wait];
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailByTab1 *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailByTab1"];
    appusers *rs=(appusers *)[dataIsSelected objectAtIndex:indexPath.row];
    detailViewController.title=rs.name;
    detailViewController.addr=rs.addr;
    detailViewController.tel=rs.tel;
    detailViewController.wait=rs.wait;
    detailViewController.color=rs.color;
    detailViewController.bed=rs.bed;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
/*
-(const char) selectData:(NSInteger)num{
    char *sql;
    switch (num) {
        case 0:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 1";
            break;
        case 1:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 2";
            break;
        case 2:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 3";
            break;
        default:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id";
            break;
    }
    return *sql;
}
 */


-(void) deterHospital{
    const char *sql;
    switch (flag) {
        case 0:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 3";
            break;
        case 1:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 2";
            break;
        case 2:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id and appusers.hospital_level = 1";
            break;
        default:
            sql = "select * from appusers natural join appstatus where appusers.hospital_PK=appstatus.id";
            break;
    }
    
   // const char *sqlTemp= &sql;
    sqlite3 *database;
	dataIsSelected = [[NSMutableArray alloc] init];
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		sqlite3_stmt *compiledStatement;

		if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
            // NSLog(@"prepare ok");
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
                int pkTemp = sqlite3_column_int(compiledStatement, 0);
                NSString *Pk=[[NSString alloc]initWithFormat:@"%d",pkTemp];
                
				NSString *Name = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 1) encoding:NSUTF8StringEncoding];
                
                int levelTemp = sqlite3_column_int(compiledStatement, 2);
                NSString *Level=[[NSString alloc]initWithFormat:@"%d",levelTemp];
                
                NSString *Addr = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, 4) encoding:NSUTF8StringEncoding];
                NSString *Tel =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,3) encoding:NSUTF8StringEncoding];
                NSString *Col =[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,6) encoding:NSUTF8StringEncoding];
                NSString *Wait=[NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement,7) encoding:NSUTF8StringEncoding];
                double bedTemp = sqlite3_column_double(compiledStatement, 8);
                
                appusers *user = [[appusers alloc] initWithPk:Pk name:Name level:Level addr:Addr tel:Tel color:Col wait:Wait bed:bedTemp];
               // NSLog(@"%@",user.name);
                [dataIsSelected addObject:user];
                
			}
		}
        else{
            NSLog(@"%s",sqlite3_errmsg(database));
        }
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
    else{
        NSLog(@"%s",sqlite3_errmsg(database));
    }
	sqlite3_close(database);
}

-(void) checkAndCreateDatabase{
    databaseName = @"v3.sqlite";
	
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



@end
