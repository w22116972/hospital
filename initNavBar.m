//
//  initNavBar.m
//  hospital
//
//  Created by Edward on 13/9/28.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "initNavBar.h"

@implementation initNavBar

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"bar V5.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
