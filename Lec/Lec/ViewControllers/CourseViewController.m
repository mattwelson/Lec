//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"
#import "LectureCell.h"
#import "LECActionBar.h"

@interface CourseViewController (){
    LECCourseViewModel *viewModel;
    Course *currentCourse;
    UIView *editView;
    NSArray *colourNames;
}

@end

@implementation CourseViewController

- (id)initWithCourse:(Course *)course
{
    self = [super initWithNibName:@"CourseViewController" bundle:nil];
    if (self) {
        currentCourse = course;
        viewModel = [[LECCourseViewModel alloc]initWithCourse:course];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //sets the status bar to white
        
        contentSection = 2; // the section with table data
        actionSection = 1; // the section with an action bar
        hasFooter = NO; // if there is a footer for the content view
        noSections = 3;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    // TODO: Fix it up so the mic gets swapped to a chevron where appropriate
}

- (void) navigationTopBar
{
    [super navigationTopBar];
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(courseEdit)];
}


-(void) courseEdit
{
    editView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[LECColourService sharedColourService] addGradientForColour:[currentCourse colour] toView:editView];
    //[[LECColourService sharedColourService] changeGradientToColour:@"Pink" forView:editView];
    
    UILabel *courseName = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 50)];
    UILabel *descriptionName = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
    UITextField *newCourseName = [[UITextField alloc] initWithFrame:CGRectMake(130, 50, 200, 50)];
    UITextField *newDescription = [[UITextField alloc] initWithFrame:CGRectMake(130, 100, 200, 50)];
    
    UIPageControl *colorPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 400, 320, 100)];
    colorPage.numberOfPages = 3;
    NSLog(@"%f, %f, %f, %f" , colorPage.bounds.origin.x, colorPage.bounds.origin.y, colorPage.bounds.size.width, colorPage.bounds.size.height);
    [colorPage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    
    colourNames = [[LECColourService sharedColourService] colourKeys];
    NSMutableArray *cButtonArray = [NSMutableArray array];
    UIButton *tmp;
    CGSize size = CGSizeMake(45, 45);
    CGFloat xOffset = 60;
    CGFloat yOffset = 150;
    CGFloat lineSpace = 30;
    
    for (int i = 0; i < colourNames.count; i ++)
    {
        tmp = [UIButton buttonWithType:UIButtonTypeCustom];
        tmp.frame = CGRectMake(
                               xOffset + ((i % 3) * (size.width + lineSpace)),
                               yOffset + ((i / 3) * (size.height + lineSpace)),
                               size.width,
                               size.height);
        [[LECColourService sharedColourService] addGradientForColour:colourNames[i] toView:tmp];
        tmp.layer.cornerRadius = tmp.frame.size.height/2;
        tmp.layer.masksToBounds = YES;
        tmp.layer.borderWidth = 0;
        [cButtonArray addObject:tmp];
        tmp.tag = i;
        [tmp addTarget:self action:@selector(colourSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [editView addSubview:tmp];
    }
    
    [courseName setTextColor:[UIColor whiteColor]];
    [descriptionName setTextColor:[UIColor whiteColor]];
    [newCourseName setTextColor:[UIColor whiteColor]];
    [newDescription setTextColor:[UIColor whiteColor]];
    [courseName setText:@"Course: "];
    [descriptionName setText:@"Description: "];
    [newCourseName setText:viewModel.navTitle];
    [newDescription setText:viewModel.subTitle];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = nil;
    
    [editView addSubview:courseName];
    [editView addSubview:descriptionName];
    [editView addSubview:newCourseName];
    [editView addSubview:newDescription];
    [editView addSubview:colorPage];
    [self.view addSubview:editView];
}

- (IBAction)colourSelected:(id)sender
{
    NSInteger i = ((UIButton *)sender).tag;
    NSLog(@"%@",colourNames[i]);
    [[LECColourService sharedColourService] changeGradientToColour:colourNames[i] forView:editView];
    
}

- (void) courseTableViewSetup
{
    [super courseTableViewSetup];
    
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_LECTURE_CELL];
    
    actionBar = [LECActionBar recordBar];
}

-(void)createHeaderView {
    self.headerView = [[LECHeaderView alloc]initWithCourse:viewModel];
    [self.view addSubview:self.headerView];
}

- (void) addLectureView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

#pragma mark Abstract methods implemented
-(void)deleteObjectFromViewModel:(NSInteger)index
{
    [viewModel deleteLectureAtIndex:index];
}

-(id) viewModelFromSubclass
{
    return viewModel;
}

-(NSArray *) tableData
{
    return viewModel.tableData;
}

-(void) didSelectCellAt:(NSInteger)index
{
    LECLectureCellViewModel *lectureCellViewModel = [viewModel.tableData objectAtIndex:index];
    
    [self.navigationController pushViewController:[[PlaybackViewController alloc] initWithLecture:lectureCellViewModel.lecture] animated:YES];
    
}

-(void) actionBarPressed
{
    [viewModel addLecture:@"An intro to Lec"];
    [self.tableView reloadData];
    LECLectureCellViewModel *lectureCellViewModel = [viewModel.tableData objectAtIndex:0];
    [self.navigationController pushViewController:[[RecordViewController alloc] initWithLecture:lectureCellViewModel.lecture] animated:YES];
}

-(NSInteger) numberOfSections
{
    return 3;
}

@end
