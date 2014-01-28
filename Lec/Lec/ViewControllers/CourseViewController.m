//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCourse:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedCourse:(Course *)course
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewModel = [LECCourseViewModel courseViewModelWithCourse:course];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    for(LECLectureCellViewModel *leccell in viewModel.tableData)
    {
        NSLog(@"%@ - %@", leccell.titleText, leccell.subText);
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self navagationTopBar];
    [self courseTableViewSetup];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    //[self.navigationController.navigationBar setBackgroundImage:[[LECColourService sharedColourService] originalHeaderImage] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 68);
//    [self.navigationController.navigationBar setBackgroundImage:Nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTranslucent:NO];
//}



- (void) navagationTopBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    
    self.navigationItem.title = viewModel.navTitle;
    //[self.navigationController.navigationBar setBarTintColor:[viewModel tintColour]];
//    [[LECColourService sharedColourService] setOriginalHeaderImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]];
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-50.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[[LECColourService sharedColourService] navGradientForColour:[[viewModel course] colour]] forBarMetrics:UIBarMetricsDefault];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:];
    

    [self.navigationController.navigationBar setTranslucent:NO];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addLecture)];
}

- (void) courseTableViewSetup
{
    self.courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.courseTableView setContentSize:CGSizeMake(320.0f, 2000.0f)];
    [self.courseTableView setScrollEnabled:YES];
    [self.courseTableView setNeedsDisplay];
    [self.view addSubview:self.courseTableView];
}


- (void) addLecture
{

}


- (void) backButtPressed
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
