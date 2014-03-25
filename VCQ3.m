//
//  VCQ3.m
//  hospital
//
//  Created by Edward on 13/9/9.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "VCQ3.h"
#import "PullRefreshAllHos.h"

@interface VCQ3 ()

@end

@implementation VCQ3{
    NSArray *class;
    NSMutableArray *mulSelect;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UITableView *tbl = [[UITableView alloc]init];
    [super viewDidLoad];
    mulSelect = [[NSMutableArray alloc]init];
 //   [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    class=@[@"  內科",@"  外科",@"  五官科",@"  婦產科",@"  小兒科",@"  牙科"];


    
    if(self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0.0f, 0.0f, 35.0f, 35.0f);
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
  //  [self addSegmentCtrl];
	// Do any additional setup after loading the view.
}

-(IBAction)yesBtn:(id)sender{
    PullRefreshAllHos *detailControllerView = [self.storyboard instantiateViewControllerWithIdentifier:@"PullRefreshAllHos"];
    
    [self presentViewController:detailControllerView animated:YES completion:Nil];
}
    /*
     tabBarCtrlDis *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarCtrlDis"];
     // [self.navigationController m]
     [self presentModalViewController:detailViewController animated:YES];
     */
    // [self performSegueWithIdentifier:@"tabBarCtrlDis" sender:self];
    //[self presentModalViewController:<#(UIViewController *)#> animated:YES];
/*
    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"建議" message:@"請考慮最近距離醫院" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}
*/

-(void) addSegmentCtrl{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"Yes",@"No",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmentedControl.frame = CGRectMake(50.0, 350.0, 200.0, 40.0);
    segmentedControl.momentary = YES;
    // segmentedControl.selectedSegmentIndex = 2;//设置默认选择项索引
    [self.view addSubview:segmentedControl];
    // [self selectSegmentCtrl:segmentedControl];
    [segmentedControl addTarget:self action:@selector(selectSegmentCtrl:) forControlEvents:UIControlEventValueChanged];
}

-(void)selectSegmentCtrl:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    //  detailByTab1 *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailByTab1"];
  //  VCQ3 *vcq3 =[self.storyboard instantiateViewControllerWithIdentifier:@"VCQ3"];
    // TVCtab1 *tvctab1 =[self.storyboard instantiateViewControllerWithIdentifier:@"TVCtab1"];
    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"建議" message:@"請考慮轉往門診處理" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    switch (Index) {
        case 0:
            [alertView show];
            break;
        case 1:
            //[self.navigationController pushViewController:vcq3 animated:YES];
            break;
        default:
            break;
    }
    
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
