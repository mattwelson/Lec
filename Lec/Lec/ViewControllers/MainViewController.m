//
//  MainViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    [self navagationTopBar];
    [self courseTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navagationTopBar
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *navItems = [[UINavigationItem alloc] init];
    
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(changeCoursePage)];
    
    navItems.title = @"Lec";
    navItems.rightBarButtonItem = cameraItem;
    navBar.items = [NSArray arrayWithObject:navItems];
    [self.view addSubview:navBar];
}

- (void) courseTableView
{
    UITableView *courseView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height-64)];
    [courseView setScrollEnabled:YES];
    [courseView setNeedsDisplayInRect:CGRectMake(0, 0, 320, 2000)];
    [self.view addSubview:courseView];
}


- (void) changeCoursePage
{
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil] animated:YES];
}

- (void) addCourseBut
{
    //This is where we will add Courses to the tableView
}

@end
