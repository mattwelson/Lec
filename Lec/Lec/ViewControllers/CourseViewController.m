//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"
#import "LectureCell.h"

@interface CourseViewController (){
    LECCourseHeaderView *headerView;
    Course *currentCourse;
    LECDatabaseService *dbService;
    Lecture *newLecture;
}

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
        currentCourse = course;
        self.viewModel = [LECCourseViewModel courseViewModelWithCourse:currentCourse];
        dbService = [LECDatabaseService sharedDBService];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //sets the status bar to white
    }
    return self;
}

-(void)viewDidLoad {
    [self createHeaderView];
    [self navagationTopBar];
    [self courseTableViewSetup];
}

-(void)viewDidAppear:(BOOL)animated
{
}


-(void)createHeaderView {
    headerView = [[LECCourseHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) course:self.viewModel];
    [self.view addSubview:headerView];
}

- (void) navagationTopBar
{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];

    
    self.navigationItem.title = self.viewModel.navTitle;
    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:0.0], NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
    navBar.tintColor = [UIColor whiteColor];

    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; // breaks shit when we go back.
    navBar.shadowImage = [UIImage new];
    [navBar setTranslucent:YES]; // what the fuck, it's not there!
    [navBar setBackgroundColor:[UIColor clearColor]]; // apparently it is!
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(savedPressed)];
}

- (void) courseTableViewSetup
{
    self.lectureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)]; // Codie HATES this bit
    [self.lectureTableView setContentSize:CGSizeMake(320.0f, self.view.frame.size.height-64)];
    [self.lectureTableView setBackgroundColor:[UIColor clearColor]];
    [self.lectureTableView setShowsVerticalScrollIndicator:NO];
    [self.lectureTableView setScrollEnabled:YES];
    [self.lectureTableView setDelegate:self]; // should set this to a seperate class built for this sort of shit
    [self.lectureTableView setDataSource:self];
    [self.lectureTableView setNeedsDisplay];
    [self.view addSubview:self.lectureTableView];
}


- (void) addLectureView
{
    
}

//will work more on it when im awake
//saves lecture to current course lectures do not increment
- (void) savedPressed
{
    newLecture = [dbService newLectureForCourse:currentCourse];
    newLecture.lectureName = @"The first lecture ever";
    newLecture.lectureNumber = [NSNumber numberWithInt:1];
    [[LECDatabaseService sharedDBService] saveChanges];
    [self.viewModel.tableData insertObject:[LECLectureCellViewModel lectureCellVMWithLecture:newLecture] atIndex:0];
    [self.lectureTableView reloadData];
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

#pragma mark TableView stuff!
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return [self.viewModel.tableData count];    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     LectureCell *cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if ([indexPath section] == 1) {
        // Should be a populate method or similar
        LECLectureCellViewModel *cellViewModel = [self.viewModel.tableData objectAtIndex:indexPath.row];
        cell.courseNameLabel.text = [cellViewModel titleText];
        cell.courseDescriptionLabel.text = [cellViewModel subText];
        cell.courseDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:cellViewModel.colourString];
        cell.courseNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:cellViewModel.colourString];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor clearColor];
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 116;
    }
    else {
        return 75;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.viewModel deleteLectureAtIndex:indexPath.row];
        [self.lectureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark Scrolling Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{ // change to a different method? Not getting called enough
    [headerView changeAlpha:self.lectureTableView.contentOffset.y];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:-0.3+(self.lectureTableView.contentOffset.y/100)], NSForegroundColorAttributeName, [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
}

@end
