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
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(savedPressed)];
}

- (void) courseTableViewSetup
{
    [super courseTableViewSetup];
    
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_LECTURE_CELL];
}

-(void)createHeaderView {
    self.headerView = [[LECHeaderView alloc]initWithCourse:viewModel];
    [self.view addSubview:self.headerView];
}

- (void) addLectureView
{
    
}

- (void) savedPressed
{
    [viewModel addLecture:@"Testing!@#$"];
    [self.tableView reloadData];
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
    Lecture *selectedLecture = [[viewModel.tableData objectAtIndex:index] lecture];
    [self.navigationController pushViewController:[[RecordViewController alloc] initWithLecture:selectedLecture] animated:YES];
}

@end
