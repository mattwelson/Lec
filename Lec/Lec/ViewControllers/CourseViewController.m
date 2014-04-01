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
    NSArray *iconNames;
    UITextField *newCourseName;
    UITextField *newDescription;
    NSString *newColor;
    NSString *newIcon;
    UIButton *pastSelectedButton;
    bool iconMaySelect;
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
    UIImage *plusImg = [UIImage imageNamed:@"nav_settings_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(courseEdit)];
}


-(void) courseEdit
{
    iconMaySelect = FALSE;
    newIcon = currentCourse.icon;
    editView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[LECColourService sharedColourService] addGradientForColour:[currentCourse colour] toView:editView];
    
    
    newCourseName = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 50)];
    newDescription = [[UITextField alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 50)];
    
    
    UIScrollView *colorView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    [colorView setContentSize:CGSizeMake(680, 100)];
    
    UIScrollView *iconView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 350, 320, 100)];
    [iconView setContentSize:CGSizeMake(1000, 100)];
    
    NSLog(@"%f, %f, %f, %f" , colorView.bounds.origin.x, colorView.bounds.origin.y, colorView.bounds.size.width, colorView.bounds.size.height);
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
        NSLog(@"%f, %f, %f, %f" , xOffset * (size.width + lineSpace),
              yOffset * (size.height + lineSpace),
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
        NSLog(@"%f, %f, %f, %f" , xOffset * (size.width + lineSpace),
              yOffset * (size.height + lineSpace),
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:checkImg style:UIBarButtonItemStylePlain target:self action:@selector(saveEdit)];
    self.navigationItem.title = nil;
    
    [editView addSubview:newCourseName];
    [editView addSubview:newDescription];
    [editView addSubview:colorView];
    [editView addSubview:iconView];
    [self.view addSubview:editView];
}

-(void) saveEdit
{
    currentCourse.courseName = newCourseName.text;
    currentCourse.courseDescription = newDescription.text;
    
    if (newColor)currentCourse.colour = newColor;
    if (newIcon) currentCourse.icon = newIcon;
    [[LECDatabaseService sharedDBService] saveChanges];
    [editView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)iconSelected:(id)sender
{
    if (iconMaySelect) {
        pastSelectedButton.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    iconMaySelect = TRUE;
    NSInteger i = ((UIButton *)sender).tag;
    NSLog(@"%@",iconNames[i]);
    newIcon = iconNames[i];
    ((UIButton *)sender).tintColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    pastSelectedButton = ((UIButton *)sender);
    
}

- (IBAction)colourSelected:(id)sender
{
    NSInteger i = ((UIButton *)sender).tag;
    NSLog(@"%@",colourNames[i]);
    [[LECColourService sharedColourService] changeGradientToColour:colourNames[i] forView:editView];
    newColor = colourNames[i];
    
    
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

// Dismissing the Keyboard when touch event is called by touching screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Keyboard is being dismissed");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    return [self.view endEditing:YES];
}

@end
