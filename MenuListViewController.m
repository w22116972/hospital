//
//  MenuListViewController.m
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

#import "MenuListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuUtil.h"


#define kSidebarCellTextKey	@"CellText"
#define kSidebarCellImageKey	@"CellImage"

@interface MenuListViewController () {
	NSArray *_headers;	//!< 节头文本.
	NSArray *_cellInfos;	//!< 单元格信息.
	NSArray *_controllers;	//!< 导航控制器集.
}

@end

@implementation MenuListViewController


@synthesize revealController;

/// 构造函数.
- (id)init {
	// [UIStoryboard instantiateViewControllerWithIdentifier] 获取vc时, 似乎不会被调用构造函数.
	//NSLog(@"init. By %@", self);
	self = [self initWithNibName:nil bundle:nil];
	return self;
}

/// 构造函数: 根据Nib名.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	// [UIStoryboard instantiateViewControllerWithIdentifier] 获取vc时, 似乎不会被调用构造函数.
	//NSLog(@"initWithNibName: %@, %@ . By %@", nibNameOrNil, nibBundleOrNil, self);
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
		self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;	// 淡入淡出.
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//NSLog(@"viewDidLoad. By %@", self);
	//NSLog(@"revealController: %@. By %@", revealController, self);
	
	// 设置自身窗口尺寸
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	// 绑定主页为内容视图（已废弃，仅用于调试）.
	if (YES) {
		UINavigationController* homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
		//NSLog(@"instantiateViewControllerWithIdentifier: %@", homeNC);
		[SideMenuUtil addNavigationGesture:homeNC revealController:revealController];
		//homeNC.revealController = revealController;
		[SideMenuUtil setRevealControllerProperty:homeNC revealController:revealController];
		revealController.contentViewController = homeNC;
	}
	//return;
	
	// 初始化表格.
//	_headers = @[
//		[NSNull null],
//		NSLocalizedString(@"Favorites", @""),
//		[NSNull null],
//	];
	_headers = @[
		[NSNull null],
		@"",
		@"",
	 ];
	_cellInfos = @[
		@[
			@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"緊急醫療雲", @"")},
		],
		@[
			@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"我需要急診嗎", @"")},
			@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"尋找最近醫院", @"")},
			@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"尋找最閒醫院", @"")},
			@{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"特別科目醫院", @"")},
		],
		
	];
	_controllers = @[
		@[
			[self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"],
		],
		@[
			[self.storyboard instantiateViewControllerWithIdentifier:@"MessageNavigationController"],
			[self.storyboard instantiateViewControllerWithIdentifier:@"SettingNavigationController"],
			[self.storyboard instantiateViewControllerWithIdentifier:@"HelpNavigationController"],
			[self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackNavigationController"]
		],
		
	];
	
	// 添加手势.
	for (id obj1 in _controllers) {
		if (nil==obj1) continue;
		for (id obj2 in (NSArray *)obj1) {
			if (nil==obj2) continue;
			[SideMenuUtil setRevealControllerProperty:obj2 revealController:revealController];
			if ([obj2 isKindOfClass:UINavigationController.class]) {
				[SideMenuUtil addNavigationGesture:(UINavigationController*)obj2 revealController:revealController];
			}
		}
	}
	
	//revealController.contentViewController = _controllers[0][0];
	
	// ui.
	UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.view.backgroundColor = bgColor;
	self.menuTableView.delegate = self;
	self.menuTableView.dataSource = self;
	self.menuTableView.backgroundColor = [UIColor clearColor];
	[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	
}

- (void)viewDidUnload {
	[self setMenuTableView:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	// 设置自身窗口尺寸
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
}


#pragma mark - property


#pragma mark - method

// 处理菜单项点击事件.
- (BOOL)onSelectRowAtIndexPath:(NSIndexPath *)indexPath hideSidebar:(BOOL)hideSidebar {
	BOOL rt = NO;
	do {
		if (nil==indexPath) break;
		
		// 获得当前项目.
		id controller = _controllers[indexPath.section][indexPath.row];
		if (nil!=controller) {
			// 页面跳转.
			if ([controller isKindOfClass:UIViewController.class]) {
				rt = YES;
				revealController.contentViewController = controller;
				if (hideSidebar) {
					[revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
				}
			}
		}
	} while (0);
	return rt;
}

/// 选择某个菜单项.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
	[self onSelectRowAtIndexPath:indexPath hideSidebar:NO];
	//NSLog(@"selectRowAtIndexPath: %@", revealController.contentViewController);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_cellInfos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"MenuListCell";
	MenuListCell *cell = (MenuListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[MenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[kSidebarCellTextKey];
	cell.imageView.image = info[kSidebarCellImageKey];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 21.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
					  (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
	   (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
	   ];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self onSelectRowAtIndexPath:indexPath hideSidebar:YES];
	//NSLog(@"didSelectRowAtIndexPath: %@", revealController.contentViewController);
}


#pragma mark - events

/// 取消按钮:点击.

- (IBAction)cancelButton_selector:(id)sender {
	if (nil!=revealController) {
		[revealController dismissModalViewControllerAnimated:YES];
	}
	else {
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
