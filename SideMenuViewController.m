//
//  SideMenuViewController.m
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MenuListViewController.h"
#import "GHRevealViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 获取菜单页面.
	

	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated{
    MenuListViewController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
	//if (nil==menuVc) return;
	
	// 模态弹出侧开菜单控制器.
    
    UIColor *bgColor = [UIColor whiteColor];
    GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
    revealController.view.backgroundColor = bgColor;
    
    // 绑定.
    menuVc.revealController = revealController;
    revealController.sidebarViewController = menuVc;
    
    // show.
    revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;	// 淡入淡出.
    [self presentModalViewController:revealController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - property



#pragma mark - method


#pragma mark - events

@end
