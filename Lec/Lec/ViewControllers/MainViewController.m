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
    UIBarButtonItem *plusItem;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setViewModel:[[LECHomeViewModel alloc] init]];
        NSMutableArray *modelDummies = [self courseDummies];
        [self setDataArray:[NSMutableArray array]];
        for (LECDummyCourse *c in modelDummies)
        {
            [[self dataArray] addObject:[LECCourseCellViewModel courseCellWithDummy:c andColourService:[self.viewModel colourService]]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    [self navagationTopBar];
    [self courseTableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) navagationTopBar
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *navItems = [[UINavigationItem alloc] init];
    
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    plusItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
    
    navItems.title = @"Lec";
    navItems.rightBarButtonItem = plusItem;
    navBar.items = [NSArray arrayWithObject:navItems];
    [self.view addSubview:navBar];
}

- (void) courseTableView
{
    self.courseView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height-64)];
    [self.courseView setScrollEnabled:YES];
    [self.courseView setNeedsDisplayInRect:CGRectMake(0, 0, 320, 2000)];
    [self.view addSubview:self.courseView];
    self.courseView.delegate = self;
    self.courseView.dataSource = self;
    [[self courseView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCell *cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    LECCourseCellViewModel *cellViewModel = [[self dataArray] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellViewModel titleText];
    cell.detailTextLabel.text = [cellViewModel subText];
    [[cellViewModel colourService] addGradientForColour:[cellViewModel colourString] toView:[cell contentView]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

//Delete this function when the cells are added to the table view.
- (void) changeCoursePage
{
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithNibName:@"CourseViewController" bundle:nil] animated:YES];
}

- (void)addCourse
{
    //This is where we will add Courses to the tableView
    UIView *addCourseView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 0)];
    addCourseView.backgroundColor = [UIColor whiteColor];
    

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         addCourseView.frame = CGRectMake(0, 60, self.view.frame.size.width, 100);
                         self.courseView.frame = CGRectMake(0, 165, 320, self.view.frame.size.height-64);
                     }
                     completion:^(BOOL finished){
                         UITextField *courseNameInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, addCourseView.frame.size.width-60, addCourseView.frame.size.height/2)];
                         courseNameInput.placeholder = @"Course Name";
                         [courseNameInput setFont:[UIFont fontWithName:@"Avenir" size:30]];
                         [addCourseView addSubview:courseNameInput];
                         
                         UITextField *courseDescriptorInput = [[UITextField alloc]initWithFrame:CGRectMake(60, addCourseView.frame.size.height/2, addCourseView.frame.size.width-60, addCourseView.frame.size.height/2)];
                         courseDescriptorInput.placeholder = @"Course Description";
                         [courseDescriptorInput setFont:[UIFont fontWithName:@"Avenir" size:15]];
                         [addCourseView addSubview:courseDescriptorInput];
                         
                         UIImage *tickImg = [UIImage imageNamed:@"nav_add_btn.png"];
                         plusItem = [[UIBarButtonItem alloc] initWithImage:tickImg style:UIBarButtonItemStylePlain target:self action:@selector(saveCourse)];
                     }];
    [self.view addSubview:addCourseView];
}

-(void)saveCourse{
    UIImage *plusImg = [UIImage imageNamed:@"nav_add_btn.png"];
    plusItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(addCourse)];
}

#pragma mark - DUMMY TESTS
-(NSMutableArray *)courseDummies
{
    NSMutableArray *dataModels = [NSMutableArray arrayWithObjects:
                                  [LECDummyCourse dummyCourse:@"Hello"],
                                  [LECDummyCourse dummyCourse:@"Julin"],
                                  [LECDummyCourse dummyCourse:@"Cosc345"],
                                  [LECDummyCourse dummyCourse:@"Fond Memories"],
                                  [LECDummyCourse dummyCourse:@"Testy"],
                                  [LECDummyCourse dummyCourse:@"Test"],
                                  [LECDummyCourse dummyCourse:@"Willowbank me!"],
                                  nil];
    return dataModels;
}

@end
