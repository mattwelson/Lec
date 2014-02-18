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
    newIcon = currentCourse.icon;
    editView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[LECColourService sharedColourService] addGradientForColour:[currentCourse colour] toView:editView];
    
    UILabel *courseName = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 50)];
    UILabel *descriptionName = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
    
    UILabel *colorPicker = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 200, 50)];
    UILabel *iconPicker = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 200, 50)];
    
    newCourseName = [[UITextField alloc] initWithFrame:CGRectMake(130, 50, 200, 50)];
    newDescription = [[UITextField alloc] initWithFrame:CGRectMake(130, 100, 200, 50)];
    
    UIScrollView *colorView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    [colorView setContentSize:CGSizeMake(680, 100)];
    
    UIScrollView *iconView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 350, 320, 100)];
    [iconView setContentSize:CGSizeMake(680, 100)];
    
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
        [tmp addTarget:self action:@selector(colourSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [colorView addSubview:tmp];
    }
    
    for (int i = 0; i < iconNames.count; i ++)
    {
        tmp = [UIButton buttonWithType:UIButtonTypeCustom];
        tmp.frame = CGRectMake(
                               i*xOffset+lineSpace-20,
                               yOffset-25,
                               size.width,
                               size.height);
        NSLog(@"%f, %f, %f, %f" , xOffset * (size.width + lineSpace),
              yOffset * (size.height + lineSpace),
              size.width,
              size.height);
        [[LECIconService sharedIconService] addIcon:iconNames[i] toView:tmp];
        [cButtonArray addObject:tmp];
        tmp.tag = i;
        [tmp addTarget:self action:@selector(iconSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [iconView addSubview:tmp];
    }
    
    
    
    [courseName setTextColor:[UIColor whiteColor]];
    [descriptionName setTextColor:[UIColor whiteColor]];
    [newCourseName setTextColor:[UIColor whiteColor]];
    [newDescription setTextColor:[UIColor whiteColor]];
    [colorPicker setTextColor:[UIColor whiteColor]];
    [iconPicker setTextColor:[UIColor whiteColor]];
    [colorPicker setText:@"Course Colour: "];
    [iconPicker setText:@"Course Icon: "];
    [courseName setText:@"Course: "];
    [descriptionName setText:@"Description: "];
    [newCourseName setText:viewModel.navTitle];
    [newDescription setText:viewModel.subTitle];
    
    UIImage *checkImg = [UIImage imageNamed:@"icon_checkmark.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:checkImg style:UIBarButtonItemStylePlain target:self action:@selector(saveEdit)];
    self.navigationItem.title = nil;
    
    [editView addSubview:iconPicker];
    [editView addSubview:colorPicker];
    [editView addSubview:courseName];
    [editView addSubview:descriptionName];
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
    currentCourse.colour = newColor;
    currentCourse.icon = newIcon;
    [[LECDatabaseService sharedDBService] saveChanges];
    [editView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)iconSelected:(id)sender
{
    NSInteger i = ((UIButton *)sender).tag;
    NSLog(@"%@",iconNames[i]);
    newIcon = iconNames[i];
    
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
