//
//  appambuClass.h
//  newProject
//
//  Created by Edward on 13/10/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appambuClass : NSObject{
    NSString *name;
    NSString *color;
    double dis;
   // NSString *level;
    NSString *tel;
    NSString *addr;
    NSString *pk;
    NSString *wait;
    double *bed;
    
}

@property (nonatomic,retain) NSString *name;
//@property (nonatomic,retain) NSString *level;
@property (nonatomic,retain) NSString *addr;
@property (nonatomic,retain) NSString *tel;
@property (nonatomic,retain) NSString *pk;
@property (nonatomic,retain) NSString *color;
@property (nonatomic,retain) NSString *wait;
@property (nonatomic) double bed;
@property (nonatomic) double dis;


-(id)initWithPk:(NSString *)p name:(NSString *)n addr:(NSString *)a tel:(NSString *)t color:(NSString *)c wait:(NSString *)w bed:(double)b dis:(double)d;

@end
