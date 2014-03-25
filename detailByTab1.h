//
//  detailByTab1.h
//  hospital
//
//  Created by Edward on 13/8/21.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailByTab1 : UIViewController{
    NSString *name;
    NSString *level;
    NSString *tel;
    NSString *addr;
    NSString *pk;
    NSString *color;
    NSString *wait;
    double bed;
    NSString *str;
    
    
  //  IBOutlet UITextView *text;
    IBOutlet UILabel *address;
    IBOutlet UILabel *telphone;
    IBOutlet UILabel *waitNum;
    IBOutlet UILabel *colorLamp;
    IBOutlet UILabel *bedRate;
    IBOutlet UILabel *hosName;
    IBOutlet UIImageView *smile;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *level;
@property (nonatomic,retain) NSString *addr;
@property (nonatomic,retain) NSString *tel;
@property (nonatomic,retain) NSString *pk;
@property (nonatomic,retain) NSString *color;
@property (nonatomic,retain) NSString *wait;
@property (nonatomic) double bed;

@property (nonatomic,retain) NSString *str;

//@property (nonatomic,retain) IBOutlet UITextView *text;
@property (nonatomic,retain) IBOutlet UILabel *address;
@property (nonatomic,retain) IBOutlet UILabel *telphone;
@property (nonatomic,retain) IBOutlet UILabel *waitNum;
@property (nonatomic,retain) IBOutlet UILabel *colorLamp;
@property (nonatomic,retain) IBOutlet UILabel *bedRate;
@property (nonatomic,retain) IBOutlet UILabel *hosName;
@property (nonatomic,retain) IBOutlet UIImageView *smile;

-(IBAction)call119;

-(IBAction)googleMap;

-(IBAction)callTel;


@end
