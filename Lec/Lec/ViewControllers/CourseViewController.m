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
        self.viewModel = [LECCourseViewModel courseViewModelWithCourse:course];
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
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];

    
    self.navigationItem.title = self.viewModel.navTitle;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:0.0], NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addLecture)];
}

- (void) courseTableViewSetup
{
    self.lectureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height)];
    [self.lectureTableView setContentSize:CGSizeMake(320.0f, 2000.0f)];
    [self.lectureTableView setBackgroundColor:[UIColor clearColor]];
    [self.lectureTableView setShowsVerticalScrollIndicator:NO];
    [self.lectureTableView setScrollEnabled:YES];
    [self.lectureTableView setDelegate:self];
    [self.lectureTableView setDataSource:self];
    [self.lectureTableView setNeedsDisplay];
    [self.view addSubview:self.lectureTableView];
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

#pragma mark TableView stuff!
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.tableData count] + 1; // fucking terrible. Could use sections?
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     LectureCell *cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if (indexPath.row != 0) {
        LECLectureCellViewModel *cellViewModel = [self.viewModel.tableData objectAtIndex:indexPath.row-1]; // this is fucking terrible.
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
    if (indexPath.row == 0) {
        return 136;
    }
    else {
        return 75;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [footer setBackgroundColor:[UIColor clearColor]];
    return footer;
}

#pragma mark Scrolling Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [headerView changeAlpha:self.lectureTableView.contentOffset.y];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:self.lectureTableView.contentOffset.y/100], NSForegroundColorAttributeName, [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
}
@end
