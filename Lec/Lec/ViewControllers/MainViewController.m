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
    NSArray *colorArray;
    NSString *selectedColor;
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
-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navagationTopBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.title = @"Your Courses";
        
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: HEADERCOLOR,
                                                            NSFontAttributeName: [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE]
                                                            }];
    
    self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
}

- (void) colorViewAppear
{
    [self.view endEditing:YES];
    
    //UIImageView *colorHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(180, 50, 200, 50);
    layout.minimumLineSpacing = 30.0f;
    self.colorView = [[UICollectionView alloc]initWithFrame: [[UIScreen mainScreen] applicationFrame] collectionViewLayout:layout];
    
    [self.colorView setScrollEnabled:NO];
    [self.colorView setDataSource:self];
    [self.colorView setDelegate:self];
    [self.colorView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.colorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    //[colorHolder setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.9]];
    
    //Creates the array based on the plist
    colorArray =  [[LECColourService sharedColourService]colourKeys];
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


// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}
// 2
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
 
    cell.layer.cornerRadius = cell.frame.size.height/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 0;
    
    NSString *cellColor = [colorArray objectAtIndex:indexPath.row];
    [[LECColourService sharedColourService] addGradientForColour:cellColor toView:[cell contentView]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedColor = [colorArray objectAtIndex:indexPath.row];
    [[LECColourService sharedColourService] changeGradientToColour:selectedColor forView:colorPickerButton];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.colorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
                     }
                     completion:^(BOOL finished){
                         [self.colorView removeFromSuperview];
                     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
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
    cell.courseNameLabel.text = [cellViewModel titleText];
    cell.courseDescriptionLabel.text = [cellViewModel subText];
    [[LECIconService sharedIconService] addIcon:[cellViewModel icon] toView:[cell contentView]];
    [[LECColourService sharedColourService] addGradientForColour:[cellViewModel colourString] toView:[cell contentView]];
    
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

//Delete this function when the cells are added to the table view.
- (void) changeCoursePage
{
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil] animated:YES];
}

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
    
    colorButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, -1, 50, 0)];
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
    selectedColor = @"Red";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSaveCourse)];
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
                         colorButtonView.frame = CGRectMake(-1, -1, 50, 52);
                         iconButtonView.frame = CGRectMake(-1, 50, 50, 50);
                         colorPickerButton.frame = CGRectMake(9, 10, 32, 32);
                         [[LECColourService sharedColourService] addGradientForColour:selectedColor toView:colorPickerButton];
                     }
                     completion:^(BOOL finished){
                         [courseNameInput becomeFirstResponder];

                     }];
    [self.view addSubview:addCourseView];
}

-(void)saveCourse{
#warning temp fix to stop no input for the course name. Will add warning box later
    if (courseNameInput.text.length > 0) {
        Course *course = [[LECDatabaseService sharedDBService] newCourseForAdding];
        course.courseName = [courseNameInput text];
        course.courseDescription = [courseDescriptorInput text];
        
        //The random colours to add
//        NSArray *colourKeys = [[LECColourService sharedColourService] colourKeys];
//        course.colour = [colourKeys objectAtIndex:arc4random() % [colourKeys count]];
        
        //Manual add colour to database
        course.colour = selectedColor;
        
        course.icon = @"cs";
        [[LECDatabaseService sharedDBService] saveChanges]; // saves changes made to course scratch pad
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(colorViewAppear)];
        self.navigationItem.leftBarButtonItem = nil;
        
        [self.viewModel.tableData insertObject:[LECCourseCellViewModel courseCellWith:course] atIndex:0];
        [self.courseTableView reloadData]; // refreshes table view

    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
        
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(colorViewAppear)];
        
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         addCourseView.frame = CGRectMake(0, 0, addCourseView.frame.size.width, 0);
                         self.courseTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [addCourseView removeFromSuperview];
                         
                     }];
    }
}


-(void)closeSaveCourse{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(colorViewAppear)];
    self.navigationItem.leftBarButtonItem = nil;

    
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
