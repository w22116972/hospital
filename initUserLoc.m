//
//  initUserLoc.m
//  hospital
//
//  Created by Edward on 10/29/13.
//  Copyright (c) 2013 Edward. All rights reserved.
//

#import "initUserLoc.h"


@interface initUserLoc ()

@end

@implementation initUserLoc

@synthesize currentLocation,locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)locationManager:(CLLocationManager *)manager

-(void)viewWillAppear:(BOOL)animated{
    
    locationManager = [[CLLocationManager alloc] init];
    currentLocation = [[CLLocation alloc]init];
    //CLLocation *clloc = [[CLLocation alloc]init];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    NSString *error;
    if (![CLLocationManager locationServicesEnabled]) {
        error = @"Error message";
        NSLog(@"locServiceNotEnable");
    }
    
    
    [self.locationManager startUpdatingLocation];
   // NSLog(@"willAppear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
  //  [self sendUserLocToNxtView];
	// Do any additional setup after loading the view.
}

-(void) sendUserLocToNxtView{
    initialView *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    NSLog(@"sending");
    detailViewController.lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    detailViewController.lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    NSLog(@"send : %@",detailViewController.lat);
    
   // [self p]
    [self.navigationController pushViewController:detailViewController animated:YES];
    //[self presentViewController:detailViewController animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
 
    currentLocation = [locations lastObject];
    
    [self sendUserLocToNxtView];
    [locationManager stopUpdatingLocation];

}

-(void)viewDidAppear:(BOOL)animated{

    
    
  
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
