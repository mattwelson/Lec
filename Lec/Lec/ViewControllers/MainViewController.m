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
    NSMutableArray *modelDummies;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setViewModel:[[LECHomeViewModel alloc] init]];
         modelDummies = [self courseDummies];
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
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(changeCoursePage)];
    
    navItems.title = @"Lec";
    navItems.rightBarButtonItem = cameraItem;
    navBar.items = [NSArray arrayWithObject:navItems];
    [self.view addSubview:navBar];
}

- (void) courseClicked
{
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
    LECDummyCourse *dummies = [modelDummies objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[CourseViewController alloc] initWithCourse:@"CourseViewController" bundle:nil selectedCourse:dummies]animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void) addCourseBut
{
    //This is where we will add Courses to the tableView
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
