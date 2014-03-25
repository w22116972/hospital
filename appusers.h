//
//  appusers.h
//  hospital
//
//  Created by Edward on 13/8/20.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appusers : NSObject{
    NSString *name;
    NSString *level;
    NSString *tel;
    NSString *addr;
    NSString *pk;
    NSString *color;
    NSString *wait;
    double *bed;
    
    double dis;
    
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *level;
@property (nonatomic,retain) NSString *addr;
@property (nonatomic,retain) NSString *tel;
@property (nonatomic,retain) NSString *pk;
@property (nonatomic,retain) NSString *color;
@property (nonatomic,retain) NSString *wait;
@property (nonatomic) double bed;
@property (nonatomic) double dis;


-(id)initWithPk:(NSString *)p name:(NSString *)n level:(NSString *)l addr:(NSString *)a tel:(NSString *)t color:(NSString *)c wait:(NSString *)w bed:(double)b;



@end
