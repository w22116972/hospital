//
//  VCQ1.h
//  hospital
//
//  Created by Edward on 13/9/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface VCQ1 : UIViewController<UIAlertViewDelegate>{
   // IBOutlet UILabel *question;
    int flag;
}

//@property (nonatomic,retain) IBOutlet UILabel *question;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
//@property (nonatomic) int flag;

-(IBAction)yesBtn:(id)sender;

//@property (nonatomic, strong) NSArray *menuItems;

@end
