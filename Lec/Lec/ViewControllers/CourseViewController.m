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
}

@end

@implementation CourseViewController

- (id)initWithCourse:(Course *)course
{
    self = [super initWithNibName:@"CourseViewController" bundle:nil];
    if (self) {
        viewModel = [[LECCourseViewModel alloc]initWithCourse:course];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //sets the status bar to white
        
        contentSection = 2; // the section with table data
        actionSection = 1; // the section with an action bar
        hasFooter = NO; // if there is a footer for the content view
        noSections = 3;
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    // TODO: Fix it up so the mic gets swapped to a chevron where appropriate
}

- (void) navigationTopBar
{
    [super navigationTopBar];
    // customise top bar add buttons etc
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
-(UITableViewCell *) cellForIndexRow:(NSInteger)indexRow
{
    LectureCell *cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_LECTURE_CELL];
    LECLectureCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexRow];
    [cell populateFor:cellViewModel];
    return (UITableViewCell *)cell;
}

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
