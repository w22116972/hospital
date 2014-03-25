//
//  appambuClass.m
//  newProject
//
//  Created by Edward on 13/10/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "appambuClass.h"

@implementation appambuClass

@synthesize name,addr,tel,pk,color,wait,dis;

-(id)initWithPk:(NSString *)p name:(NSString *)n addr:(NSString *)a tel:(NSString *)t color:(NSString *)c wait:(NSString *)w bed:(double)b dis:(double)d{
    self.pk=p;
    self.name=n;
    //self.level=l;
    self.addr=a;
    self.tel=t;
    self.wait=w;
    self.color=c;
    self.bed=b;
    self.dis=d;
    return self;
}


@end
