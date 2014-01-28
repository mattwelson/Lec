//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"
#import "LectureCell.h"

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
        self.viewModel = [LECCourseViewModel courseViewModelWithCourse:course];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self navagationTopBar];
    [self courseTableViewSetup];
}

- (void) navagationTopBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    
    self.navigationItem.title = self.viewModel.navTitle;
    [self.navigationController.navigationBar setTranslucent:NO];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addLecture)];
}

- (void) courseTableViewSetup
{
    self.lectureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.lectureTableView setContentSize:CGSizeMake(320.0f, 2000.0f)];
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
    return [self.viewModel.tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     LectureCell *cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    LECLectureCellViewModel *cellViewModel = [self.viewModel.tableData objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = [cellViewModel titleText];
    cell.courseDescriptionLabel.text = [cellViewModel subText];
    cell.courseDescriptionLabel.textColor = [[LECColourService sharedColourService] highlightColourFor:cellViewModel.colourString];
    cell.courseNameLabel.textColor = [[LECColourService sharedColourService] baseColourFor:cellViewModel.colourString];
    // todo: move this shit
    
    // gist.github.com/calebd/6076663
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [footer setBackgroundColor:[UIColor clearColor]];
    return footer;
}
@end
