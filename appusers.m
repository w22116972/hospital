//
//  appusers.m
//  hospital
//
//  Created by Edward on 13/8/20.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "appusers.h"

@implementation appusers

@synthesize name,addr,tel,level,pk,color,wait,dis;

-(id)initWithPk:(NSString *)p name:(NSString *)n level:(NSString *)l addr:(NSString *)a tel:(NSString *)t color:(NSString *)c wait:(NSString *)w bed:(double)b{
    self.pk=p;
    self.name=n;
    self.level=l;
    self.addr=a;
    self.tel=t;
    self.wait=w;
    self.color=c;
    self.bed=b;
    return self;
}

@end
