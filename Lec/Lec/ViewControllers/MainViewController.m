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
    [self addCourseIntoView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navagationTopBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
//    plusItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    self.navigationItem.title = @"Lec";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
}

- (void) courseClicked
{
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
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithCourse:@"CourseViewController" bundle:nil selectedCourse:selectedCourse] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCell *cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    LECCourseCellViewModel *cellViewModel = [self.viewModel.tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellViewModel titleText];
    cell.detailTextLabel.text = [cellViewModel subText];
    [[LECColourService sharedColourService] addGradientForColour:[cellViewModel colourString] toView:[cell contentView]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.tableData count];
}

//Delete this function when the cells are added to the table view.
- (void) changeCoursePage
{
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil] animated:YES];
}

-(void)addCourseIntoView{
    addCourseView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 0)];
    addCourseView.backgroundColor = [UIColor whiteColor];
    
    courseNameInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, self.view.frame.size.width-60, 50)];
    courseNameInput.placeholder = @"Course Name";
    [courseNameInput setFont:[UIFont fontWithName:@"Avenir" size:30]];
    [addCourseView addSubview:courseNameInput];
    
    courseDescriptorInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 50, self.view.frame.size.width-60,50)];
    courseDescriptorInput.placeholder = @"Course Description";
    [courseDescriptorInput setFont:[UIFont fontWithName:DEFAUILTFONT size:15]];
    [addCourseView addSubview:courseDescriptorInput];
}

- (void)addCourse
{
    //This is where we will add Courses to the tableView
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self addCourseIntoView];
                         addCourseView.frame = CGRectMake(0, 60, self.view.frame.size.width, 100);
                         self.courseTableView.frame = CGRectMake(0, 100, 320, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [courseNameInput becomeFirstResponder];

                         
                         UIImage *tickImg = [UIImage imageNamed:@"icon_checkmark.png"];
                             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:tickImg style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
                     }];
    [self.view addSubview:addCourseView];
}

-(void)saveCourse{
    [[LECDatabaseService sharedDBService] saveChanges]; // saves changes made to course scratch pad
    [self.courseTableView reloadData]; // refreshes table view

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         addCourseView.frame = CGRectMake(0, 0, addCourseView.frame.size.width, 0);
                         self.courseTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [addCourseView removeFromSuperview];
                         UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
                         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
                         
                     }];
}
@end
