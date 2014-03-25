//
//  mapVC.h
//  hospital
//
//  Created by Edward on 13/8/22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

@interface mapVC : UIViewController<MKAnnotation>

@property(nonatomic,strong) IBOutlet MKMapView *mapView;



@end
