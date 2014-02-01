//
//  MainViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "MainViewController.h"
#import "LECImportHeader.h"

@interface MainViewController (){
    // UI elements only
    NSString *courseNameText;
    NSString *courseDescriptionText;
    NSString *colour;
    UIBarButtonItem *plusItem;
    LECAddCourseView *addCourseView;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setViewModel:[[LECHomeViewModel alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    [self courseTableViewSetup];
    [self navagationTopBar];
}


-(void)viewWillAppear:(BOOL)animated{
    //[self navagationTopBar]; MOVED EVERYTHING TO VIEWDIDAPPEAR
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self navagationTopBar];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];  //sets the status bar to black
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navagationTopBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.title = self.viewModel.navTitle;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEADERCOLOR, NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
    self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
}



- (void) courseTableViewSetup
{
    // height hack, need to write a method that reloads correctly when the viewDidAppear whne we figure out whats causing it.
    self.courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];
    [self.courseTableView setScrollEnabled:YES];
    [self.courseTableView setNeedsDisplay];
    [self.view addSubview:self.courseTableView];
    self.courseTableView.delegate = self;
    self.courseTableView.dataSource = self;
    [[self courseTableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *selectedCourse = [[self.viewModel.tableData objectAtIndex:indexPath.row] course];
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithCourse:selectedCourse] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCell *cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell populateFor:[self.viewModel.tableData objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.viewModel deleteCourseAtIndex:indexPath.row];
        [self.courseTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.tableData count];
}

#warning Should be moved!
#pragma mark Methods for that little add course view

- (void)addCourse
{
    addCourseView = [LECAddCourseView createAddCourseView];
    addCourseView.saveCourseDelegate = self;
    [self.view addSubview:addCourseView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSaveCourse)];
    
    self.courseTableView.userInteractionEnabled = NO; // disable course clicking
    //This is where we will add Courses to the tableView
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [addCourseView animateCourseAddView];
                         self.courseTableView.frame = CGRectMake(0, 100, 320, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void) saveCourse:(NSString *)courseNameString description:(NSString *)courseDescriptionString colour:(NSString *)colourString {
    courseNameText = courseNameString;
    courseDescriptionText = courseDescriptionString;
    colour = colourString;
}


-(void)saveCourse{
#warning temp fix to stop no input for the course name. Will add warning box later (CODIE!)
    //    if (courseNameInput.text.length > 0) {
    
    //Call the delegate to get all the text fields
    [addCourseView retrieveInputs];
    
    Course *course = [[LECDatabaseService sharedDBService] newCourseForAdding];
    course.courseName = courseNameText;
    course.courseDescription = courseDescriptionText;
    course.colour = colour;
    course.icon = @"cs";
    
    [[LECDatabaseService sharedDBService] saveChanges]; // saves changes made to course scratch pad
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.viewModel.tableData insertObject:[LECCourseCellViewModel courseCellWith:course] atIndex:0];
    
    [self.courseTableView reloadData]; // refreshes table view
    [self closeSaveCourse];
    //    }
}


-(void)closeSaveCourse{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.courseTableView.userInteractionEnabled = YES; // re-enables course clicking
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.courseTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                         [addCourseView animateViewRemoved];
                     }
                     completion:^(BOOL finished){
                         [addCourseView removeFromSuperview];
                         
                     }];
    
    
}
@end
