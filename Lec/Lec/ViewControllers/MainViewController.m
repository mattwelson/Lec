//
//  MainViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "MainViewController.h"
#import "LECPullDownReminder.h"
#import "LECHeaderView.h"
#import "LECAnimationService.h"

@interface MainViewController (){
    // UI elements only
    NSString *courseNameText;
    NSString *courseDescriptionText;
    NSString *colour;
    NSString *icon;
    UIBarButtonItem *plusItem;
    LECAddCourseView *addCourseView;
    BOOL addViewActive;
    UILabel *pullDownAddBar;
    LECPullDownReminder *reminderView;
    NSArray *visibleCells;
    int loadedCells;
    NSIndexPath *deleteIndexPath;
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
    [self navagationTopBar];

    [self courseTableViewSetup];
    [self pullDownReminderSetup];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    addViewActive = FALSE;
    [super viewDidAppear:animated];
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
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:NULL forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HEADERCOLOR, NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    self.navigationController.navigationBar.alpha = 0.0;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.navigationController.navigationBar.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void) pullDownReminderSetup{
    pullDownAddBar = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    [pullDownAddBar setTextAlignment:NSTextAlignmentCenter];
    [pullDownAddBar setFont:[UIFont fontWithName:DEFAULTFONT size:15]];
    [pullDownAddBar setTextColor:[UIColor grayColor]];
    [pullDownAddBar setText:@"Pull Down to Add Course"];
    [self.view addSubview:pullDownAddBar];
}

- (void) courseTableViewSetup
{
    // height hack, need to write a method that reloads correctly when the viewDidAppear whne we figure out whats causing it.
    self.courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.courseTableView setScrollEnabled:YES];
    [self.courseTableView setNeedsDisplay];
    [self.view addSubview:self.courseTableView];
    self.courseTableView.delegate = self;
    self.courseTableView.dataSource = self;
    self.courseTableView.backgroundColor = [UIColor clearColor];
    [[self courseTableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Course *selectedCourse = [[self.viewModel.tableData objectAtIndex:indexPath.row] course];
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithCourse:selectedCourse] animated:YES];
    [self.courseTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCell *cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell populateFor:[self.viewModel.tableData objectAtIndex:indexPath.row]];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(setEditingMode:)];
    longPress.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:longPress];
    return cell;
}

#pragma mark AlertView methods for deletion of course

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    deleteIndexPath = indexPath;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *deleteTitle = [@"Delete " stringByAppendingString:[[[self.viewModel.tableData objectAtIndex:indexPath.row] course]courseName]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:deleteTitle
                                                        message:@"Are you sure you want to delete this course and all the lectures inside?"
                                                       delegate:self
                                              cancelButtonTitle:@"Delete"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.viewModel deleteCourseAtIndex:deleteIndexPath.row];
        [self.courseTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [self.courseTableView setEditing:NO];
        [alertView removeFromSuperview];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ANIMATIONS_ON) {
        if (visibleCells == NULL) {
            visibleCells = [self.courseTableView indexPathsForVisibleRows];
        }
        if ([visibleCells containsObject:indexPath] && loadedCells < visibleCells.count){
            double delay = 0.5+(loadedCells*0.1);
            [[LECAnimationService sharedAnimationService] addAlphaToView:cell.backgroundView withSpeed:0.35 withDelay:delay];
            [[LECAnimationService sharedAnimationService] addSpringAnimationToView:cell.contentView withSpeed:1.0 withDelay:delay withDamping:0.6 withVelocity:0.1 withDirectionFromLeft:YES];
           //delay 0.6+(loadedCells*0.1)
            loadedCells++;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewModel.tableData.count == 0) {
        reminderView = [LECPullDownReminder createReminderViewMainScreen];
        [self.courseTableView addSubview:reminderView];
        [self.courseTableView sendSubviewToBack:reminderView];
    }
    else {
        [reminderView removeFromSuperview];
    }
    return [self.viewModel.tableData count];
}

#pragma mark Editing cells

-(void)setEditingMode:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (self.courseTableView.isEditing == NO) {
        [self.courseTableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(disableEditingMode)];
    }
}

-(void)disableEditingMode{
    [self.courseTableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//TODO: Update logic to save the row reordering
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Course *course = [self.viewModel.tableData objectAtIndex:sourceIndexPath.row];
    
    [self.viewModel.tableData removeObjectAtIndex:sourceIndexPath.row];
    [self.viewModel.tableData insertObject:course atIndex:destinationIndexPath.row];
    
    [self.viewModel updateCourseIndexes];
    
}


#warning Should be moved!
#pragma mark Methods for that little add course view

- (void)addCourse
{
    if (self.courseTableView.isEditing == NO) {

    [self.courseTableView scrollToRowAtIndexPath:0 atScrollPosition:0 animated:YES];
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
                         self.courseTableView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT);
                         reminderView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                     }];
    }
}

-(void) saveCourse:(NSString *)courseNameString description:(NSString *)courseDescriptionString colour:(NSString *)colourString icon:(NSString *)iconString{
    courseNameText = courseNameString;
    courseDescriptionText = courseDescriptionString;
    colour = colourString;
    icon = iconString;
}

-(void)addCoursePullDown{
    if (self.courseTableView.isEditing == NO) {
        addCourseView = [LECAddCourseView createAddCourseView];
        addCourseView.saveCourseDelegate = self;
        addCourseView.alpha = 0.0;
        [self.view addSubview:addCourseView];
        
        [addCourseView animateCourseAddView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSaveCourse)];
        
        self.courseTableView.userInteractionEnabled = NO; // disable course clicking
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             addCourseView.alpha = 1.0;
                             self.courseTableView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT);
                             reminderView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
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
    course.icon = icon;
    course.courseIndex = [NSNumber numberWithInt:[self.viewModel.tableData count]];
    
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
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.courseTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
                         [addCourseView animateViewRemoved];
                         reminderView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [addCourseView removeFromSuperview];
                         
                     }];
    addViewActive = FALSE;
    
    
}

//As subclass of tableview will get called when tableview starts scrolling.
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.courseTableView.isEditing == NO) {
        if (self.courseTableView.contentOffset.y < -65) {
            pullDownAddBar.alpha = 1.0;
        }
        else {
            pullDownAddBar.alpha = 0.0;
        }
        pullDownAddBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, -scrollView.contentOffset.y - 64);
    }
    if (scrollView.contentOffset.y < -135) {
        scrollView.contentOffset = CGPointMake(0, -135);
        [pullDownAddBar setText:@"Release to Add Course"];
    }
    else {
        [pullDownAddBar setText:@"Pull Down to Add Course"];
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.courseTableView.isEditing == NO) {
        if (scrollView.contentOffset.y <= -135 && !addViewActive) {
            pullDownAddBar.alpha = 0.0;
            addViewActive = TRUE;
            [self addCoursePullDown];
        }
    }
}
@end