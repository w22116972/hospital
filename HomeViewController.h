//
//  HomeViewController.h
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

/**
 * @file	HomeViewController.h
 * @brief	主页页面.
 * @author	[zyl910](http://www.cnblogs.com/zyl910/)
 * @version	1.0
 * @date	2013-06-14
 *
 * ## Change history (变更日志)
 *
 * [2013-06-14] <zyl910> v1.0
 *
 * + v1.0版发布.
 *
 */

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"

/// 主页页面.
@interface HomeViewController : UIViewController <IRevealControllerProperty>

#pragma mark - property



#pragma mark - method


#pragma mark - outlets


#pragma mark - events

- (IBAction)sideLeftButton_selector:(id)sender;

@end
