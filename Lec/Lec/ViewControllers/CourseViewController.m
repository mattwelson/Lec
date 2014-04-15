//
//  CourseViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "CourseViewController.h"
#import "LECAnimationService.h"
#import "LectureCell.h"
#import "LECActionBar.h"

@interface CourseViewController (){
    LECCourseViewModel *viewModel;
    Course *currentCourse;
    LECLecturePrepareView *preScreen;
    UIView *editView;
    NSArray *colourNames;
    NSArray *iconNames;
    UITextField *newCourseName;
    UITextField *newDescription;
    NSString *newColor;
    NSString *newIcon;
    UIButton *pastSelectedButton;
    bool iconMaySelect;
    UIView *quickRecordView;
    UILabel *quickRecordLabel;
    BOOL addViewActive;
    
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
        
        contentSection = 1; // the section with table data
        actionSection = -1; // the section with an action bar
        hasFooter = NO; // if there is a footer for the content view
        noSections = 2;
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated
{
    // TODO: Fix it up so the mic gets swapped to a chevron where appropriate
    
    //Hacked this so it moves the tableview slightly, when going to it, this forces it to scroll, hence recalculates the titlebar
    CGPoint point = CGPointMake(0, self.tableView.contentOffset.y-1);
    [self.tableView setContentOffset:point animated:YES];
}

- (void) navigationTopBar
{
    [super navigationTopBar];
    UIImage *plusImg = [UIImage imageNamed:@"nav_settings_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(courseEdit)];
    
    quickRecordView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height, SCREEN_WIDTH, 0)];
    quickRecordView.backgroundColor = [UIColor whiteColor];
//    quickRecordView.backgroundColor = [[LECColourService sharedColourService]baseColourFor:[viewModel colourString]];
    quickRecordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, quickRecordView.frame.size.height/2, SCREEN_WIDTH, 50)];
    quickRecordLabel.textColor = HEADERCOLOR;
    quickRecordLabel.textAlignment = NSTextAlignmentCenter;
    quickRecordLabel.text = @"Pull down to add a recording";
    [quickRecordView addSubview:quickRecordLabel];
    [self.view addSubview:quickRecordView];
}


-(void) courseEdit
{
    iconMaySelect = FALSE;
    newIcon = currentCourse.icon;
    editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[LECColourService sharedColourService] addGradientForColour:[currentCourse colour] toView:editView];
    
    
    newCourseName = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 50)];
    newDescription = [[UITextField alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 50)];
    
    
    UIScrollView *colorView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    [colorView setContentSize:CGSizeMake(680, 100)];
    
    UIScrollView *iconView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 350, 320, 100)];
    [iconView setContentSize:CGSizeMake(1000, 100)];
    
    [colorView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [iconView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    
    colourNames = [[LECColourService sharedColourService] colourKeys];
    iconNames = [[LECIconService sharedIconService] iconKeys];
    NSMutableArray *cButtonArray = [NSMutableArray array];
    UIButton *tmp;
    CGSize size = CGSizeMake(45, 45);
    CGFloat xOffset = 70;
    CGFloat yOffset = 25;
    CGFloat lineSpace = 30;
    
    for (int i = 0; i < colourNames.count; i ++)
    {
        tmp = [UIButton buttonWithType:UIButtonTypeCustom];
        tmp.frame = CGRectMake(
                               i*xOffset+lineSpace,
                               yOffset,
                               size.width,
                               size.height);
        [[LECColourService sharedColourService] addGradientForColour:colourNames[i] toView:tmp];
        tmp.layer.cornerRadius = tmp.frame.size.height/2;
        tmp.layer.masksToBounds = YES;
        tmp.layer.borderWidth = 0;
        [cButtonArray addObject:tmp];
        tmp.tag = i;
        tmp.showsTouchWhenHighlighted = YES;
        [tmp addTarget:self action:@selector(colourSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorView addSubview:tmp];
    }
    
    for (int i = 0; i < iconNames.count; i ++)
    {
        tmp = [UIButton buttonWithType:UIButtonTypeCustom];
        tmp.frame = CGRectMake(
                               i*xOffset+lineSpace-20,
                               yOffset,
                               size.width,
                               size.height);
        UIImageView *tmpImageView = [[UIImageView alloc]init];
        tmpImageView = [[LECIconService sharedIconService] retrieveIcon:iconNames[i] toView:tmpImageView];
        [tmp setImage:tmpImageView.image forState:UIControlStateNormal];
        tmp.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [cButtonArray addObject:tmp];
        tmp.tag = i;
        tmp.showsTouchWhenHighlighted = YES;
        [tmp addTarget:self action:@selector(iconSelected:) forControlEvents:UIControlEventTouchUpInside];
        [iconView addSubview:tmp];
    }
    
    [newCourseName setTextColor:[UIColor whiteColor]];
    newCourseName.textAlignment = NSTextAlignmentCenter;
    [newCourseName setFont:[UIFont fontWithName:DEFAULTFONT size:40]];
    newCourseName.placeholder = @"Course Name";
    newCourseName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [newDescription setTextColor:[UIColor whiteColor]];
    newDescription.textAlignment = NSTextAlignmentCenter;
    [newDescription setFont:[UIFont fontWithName:DEFAULTFONT size:25]];
    newDescription.placeholder = @"Description";
    newDescription.clearButtonMode = UITextFieldViewModeWhileEditing;
    [newCourseName setText:viewModel.navTitle];
    [newDescription setText:viewModel.subTitle];
    
    UIImage *checkImg = [UIImage imageNamed:@"icon_checkmark.png"];
    //    checkImg = [checkImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(SCREEN_WIDTH - 40, 30, 30, 30);
    //    [rightButton setBackgroundImage:checkImg forState:UIControlStateNormal];
    //    [rightButton.imageView setTintColor:[UIColor whiteColor]];
    //    [rightButton addTarget:self action:@selector(saveEdit) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:checkImg style:UIBarButtonItemStylePlain target:self action:@selector(saveEdit)];
    
    UIImage *crossImg = [UIImage imageNamed:@"icon_cancel.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:crossImg style:UIBarButtonItemStylePlain target:self action:@selector(closeEdit)];
    self.navigationItem.title = nil;
    
    [editView addSubview:newCourseName];
    [editView addSubview:newDescription];
    [editView addSubview:colorView];
    [editView addSubview:iconView];
    //[editView addSubview:rightButton];
    [self.view addSubview:editView];
    
    //self.navigationController.navigationBar.hidden = YES;
    
    [[LECAnimationService sharedAnimationService]addAlphaToView:editView withSpeed:0.2 withDelay:0.0];
}

-(void) saveEdit
{
    currentCourse.courseName = newCourseName.text;
    currentCourse.courseDescription = newDescription.text;
    
    if (newColor)currentCourse.colour = newColor;
    if (newIcon) currentCourse.icon = newIcon;
    [[LECDatabaseService sharedDBService] saveChanges];
    [self closeEdit];
}

-(void)closeEdit
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_settings_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(courseEdit)];
    [UIView animateWithDuration:0.2 animations:^{
        editView.alpha = 0.0;
    } completion:^(BOOL finished){
        [editView removeFromSuperview];
    }];
    //[self.navigationController popViewControllerAnimated:YES];
    //self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = NULL;
    //[editView removeFromSuperview];
    viewModel = [[LECCourseViewModel alloc]initWithCourse:currentCourse];
    [self.tableView reloadData];
    self.navigationItem.title = [[self viewModelFromSubclass] navTitle];
    
}

- (IBAction)iconSelected:(id)sender
{
    if (iconMaySelect) {
        pastSelectedButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    iconMaySelect = TRUE;
    NSInteger i = ((UIButton *)sender).tag;
    newIcon = iconNames[i];
    ((UIButton *)sender).tintColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    pastSelectedButton = ((UIButton *)sender);
    
}

- (IBAction)colourSelected:(id)sender
{
    NSInteger i = ((UIButton *)sender).tag;
    NSLog(@"%@",colourNames[i]);
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:
     ^{
         [[LECColourService sharedColourService] changeGradientToColour:colourNames[i] forView:editView];
     }completion:^(BOOL finished){
         nil;
     }];
    newColor = colourNames[i];
    
    
}

- (void) courseTableViewSetup
{
    [super courseTableViewSetup];
    
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_LECTURE_CELL];
    
    //actionBar = [LECActionBar recordBar];
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

-(void) courseScroll:(CGFloat)scrollOffset
{
    if (scrollOffset < 0) {
        [self.view addSubview:quickRecordView];
        quickRecordView.frame = CGRectMake(0, self.headerView.frame.size.height, SCREEN_WIDTH, -scrollOffset);
        quickRecordLabel.font = [UIFont fontWithName:DEFAULTFONT size:10-scrollOffset/16];
        quickRecordLabel.alpha = (-20-scrollOffset)/40;
    }
    else {
        [quickRecordView removeFromSuperview];
    }
}


-(void) quickRecord
{
    //[viewModel addLecture:@"Quick Record" withLectureNumber:viewModel.i];
    //[self confirmChanges:viewModel.i+1 withName:@"(Quick Record)"];
    //    preScreen = [[LECLecturePrepareView alloc]initWithFrame:CGRectMake(0, self.headerView.frame.size.height, SCREEN_WIDTH, 75) withCourseViewModel:viewModel];
    //    preScreen.preRecordDelegate = self;
    //    [self.view addSubview:preScreen];
    [self addLecturePullDown];
}


-(void)addLecturePullDown{
    preScreen = [[LECLecturePrepareView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 75) withCourseViewModel:viewModel];
    preScreen.preRecordDelegate = self;
    //preScreen.alpha = 0.0;
    [self.view addSubview:preScreen];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(confirmChanges:withName:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSaveLecture)];
    [preScreen animateEntry];

    self.tableView.userInteractionEnabled = NO; // disable course clicking
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //preScreen.frame.size.height = 75;
                         //preScreen.alpha = 1.0;
                         preScreen.frame = CGRectMake(0, 150, SCREEN_WIDTH, 125);
                         self.tableView.frame = CGRectMake(0, 64+75, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                     }
                     completion:^(BOOL finished){
                     }];
    addViewActive = TRUE;
    
}

-(void)closeSaveLecture{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_settings_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(courseEdit)];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.tableView.userInteractionEnabled = YES; // re-enables course clicking
    
    [preScreen dismissScreen];

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         preScreen.frame = CGRectMake(0, 200, SCREEN_WIDTH, 75);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2 animations:^{
                            self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                         } completion:^(BOOL finished) {
                             [preScreen removeFromSuperview];
                         }];
                     }];
    addViewActive = FALSE;
    
    
}

-(void) actionBarPressed
{
    //    preScreen = [[LECLectureEditScreen alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) withCourseViewModel:viewModel];
    //    preScreen.preRecordDelegate = self;
    //    [self.view addSubview:preScreen];
    //    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //    CGRect finalFrame = preScreen.frame;
    //    preScreen.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    //
    //    [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.15 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //        preScreen.frame = finalFrame;
    //    }completion:^(BOOL completion){
    //
    //    }];
}

#pragma mark Delegate from the pre recording screen to head into recording
-(void) preRecordCancelled
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void) confirmChanges:(NSInteger)lectureNumber withName:(NSString *)lectureName
{
    [self closeSaveLecture];
    [viewModel addLecture:lectureName withLectureNumber:lectureNumber];
    [self.tableView reloadData];
    LECLectureCellViewModel *lectureCellViewModel = [viewModel.tableData objectAtIndex:0];
    [self.navigationController pushViewController:[[RecordViewController alloc] initWithLecture:lectureCellViewModel.lecture] animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

-(NSInteger) numberOfSections
{
    return 3;
}

// Dismissing the Keyboard when touch event is called by touching screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [self.view endEditing:YES];
}


@end
