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
    UIBarButtonItem *plusItem;
    UIView *addCourseView;
    UITextField *courseNameInput;
    UITextField *courseDescriptorInput;
    UIView *colorButtonView;
    UIView *iconButtonView;
    UIButton *colorPickerButton;
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
    [self addCourseIntoView];
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

- (void) colorViewAppear
{
    [self.view endEditing:YES];
    self.colorView = [LECColorCollectionView colourCollection];
    self.colorView.colourPickerDelegate = self;

    
    //Creates the array based on the plist
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.colorView];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.colorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void)colourPickerDismissed:(NSString *)colourString {
    [[LECColourService sharedColourService] changeGradientToColour:colourString forView:colorPickerButton];
}




- (void) courseTableViewSetup
{
    self.courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
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
-(void)addCourseIntoView{
    addCourseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    addCourseView.backgroundColor = [UIColor whiteColor];
    addCourseView.layer.borderWidth = 1;
    addCourseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    courseNameInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, self.view.frame.size.width-60, 0)];
    courseNameInput.placeholder = @"Course Name";
    [courseNameInput setFont:[UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE]];
    [courseNameInput setTextColor:HEADERCOLOR];
    [courseNameInput setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [addCourseView addSubview:courseNameInput];
    
    courseDescriptorInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 50, self.view.frame.size.width-60,0)];
    courseDescriptorInput.placeholder = @"Course Description";
    [courseDescriptorInput setFont:[UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE]];
    [courseDescriptorInput setTextColor:HEADERCOLOR];
    [courseDescriptorInput setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [addCourseView addSubview:courseDescriptorInput];
    
    colorButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, 50, 0)];
    colorButtonView.backgroundColor = [UIColor clearColor];
    colorButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    colorButtonView.layer.borderWidth = 1.0f;
    [addCourseView addSubview:colorButtonView];
    
    iconButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, 50, 0)];
    iconButtonView.backgroundColor = [UIColor clearColor];
    iconButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    iconButtonView.layer.borderWidth = 1.0f;
    [addCourseView addSubview:iconButtonView];
    
    colorPickerButton = [[UIButton alloc]initWithFrame:CGRectMake(9, 10, 32, 0)];
    colorPickerButton.backgroundColor = [UIColor blackColor];
    colorPickerButton.layer.cornerRadius = colorPickerButton.frame.size.width/2;
    colorPickerButton.layer.masksToBounds = YES;
    colorPickerButton.layer.borderWidth = 0;
    [colorPickerButton addTarget:Nil action:@selector(colorViewAppear) forControlEvents:UIControlEventTouchDown];
    [colorButtonView addSubview:colorPickerButton];

}

- (void)addCourse
{
    //Default colour
    //selectedColor = @"Red";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSaveCourse)];
    
    self.courseTableView.userInteractionEnabled = NO; // disable course clicking
    //This is where we will add Courses to the tableView
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self addCourseIntoView];
                         addCourseView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
                         self.courseTableView.frame = CGRectMake(0, 100, 320, self.view.frame.size.height);
                        courseNameInput.frame = CGRectMake(60, 5, self.view.frame.size.width-60, 50);
                         courseDescriptorInput.frame = CGRectMake(60, 50, self.view.frame.size.width-60,50);
                         colorButtonView.frame = CGRectMake(-1, 0, 50, 52);
                         iconButtonView.frame = CGRectMake(-1, 50, 50, 50);
                         colorPickerButton.frame = CGRectMake(9, 10, 32, 32);
                         //[[LECColourService sharedColourService] addGradientForColour:selectedColor toView:colorPickerButton];
                     }
                     completion:^(BOOL finished){
                         [courseNameInput becomeFirstResponder];

                     }];
    [self.view addSubview:addCourseView];
}

-(void)saveCourse{
#warning temp fix to stop no input for the course name. Will add warning box later (CODIE!)
    if (courseNameInput.text.length > 0) {
        Course *course = [[LECDatabaseService sharedDBService] newCourseForAdding];
        course.courseName = [courseNameInput text];
        course.courseDescription = [courseDescriptorInput text];

        //course.colour = selectedColor;
        
        course.icon = @"cs";
        [[LECDatabaseService sharedDBService] saveChanges]; // saves changes made to course scratch pad
        self.navigationItem.leftBarButtonItem = nil;
        
        [self.viewModel.tableData insertObject:[LECCourseCellViewModel courseCellWith:course] atIndex:0];
        [self.courseTableView reloadData]; // refreshes table view

        [self closeSaveCourse];
    }
}


-(void)closeSaveCourse{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.courseTableView.userInteractionEnabled = YES; // re-enables course clicking

    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         addCourseView.frame = CGRectMake(0, 0, addCourseView.frame.size.width, 0);
                         self.courseTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                         courseNameInput.frame = CGRectMake(60, 5, self.view.frame.size.width-60, 0);
                         courseDescriptorInput.frame = CGRectMake(60, 50, self.view.frame.size.width-60,0);
                         colorButtonView.frame = CGRectMake(-1, -1, 50, 0);
                         iconButtonView.frame = CGRectMake(-1, 0, 50, 0);
                         colorPickerButton.frame = CGRectMake(9, 10, 32, 0);
                     }
                     completion:^(BOOL finished){
                         [addCourseView removeFromSuperview];
                         
                     }];
    
    
}
@end
