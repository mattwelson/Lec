//
//  PullupTableViewController.m
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "PullupTableViewController.h"
#import "LECImportHeader.h"

@interface PullupTableViewController ()

@end

@implementation PullupTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    [self navigationTopBar];
    [self courseTableViewSetup];
}

- (void) navigationTopBar
{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    
    self.navigationItem.title = [[self viewModelFromSubclass] navTitle];
    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:0.0], NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
    navBar.tintColor = [UIColor whiteColor];
    
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; // breaks shit when we go back.
    navBar.shadowImage = [UIImage new];
    [navBar setTranslucent:YES]; // what the fuck, it's not there!
    [navBar setBackgroundColor:[UIColor clearColor]]; // apparently it is!
}

- (void) courseTableViewSetup
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)]; // Codie HATES this bit
    [self.tableView setContentSize:CGSizeMake(320.0f, self.view.frame.size.height-64)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setScrollEnabled:YES];
    [self.tableView setDelegate:self]; // should set this to a seperate class built for this sort of shit
    [self.tableView setDataSource:self];
    [self.tableView setNeedsDisplay];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_LECTURE_CELL];
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_HEADER];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView stuff!

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Lecture *selectedLecture = [[[self tableData] objectAtIndex:indexPath.row] lecture]; // should a nice method
    
    [self.navigationController pushViewController:[[RecordViewController alloc] initWithLecture:selectedLecture] animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return [[self tableData] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LectureCell *cell;
    
    if ([indexPath section] == 1) {
        cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_LECTURE_CELL];
        LECLectureCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexPath.row];
        [cell populateFor:cellViewModel];
    }
    else {
        cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_HEADER];
        cell.backgroundColor = [UIColor clearColor];
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 136;
    }
    else {
        return 75;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteObjectFromViewModel:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark Scrolling Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{ // change to a different method? Not getting called enough
    [self.headerView changeAlpha:self.tableView.contentOffset.y];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:-0.3+(self.tableView.contentOffset.y/100)], NSForegroundColorAttributeName, [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
}

#pragma mark Abstract methods
-(void) deleteObjectFromViewModel:(NSInteger)index
{
    @throw [NSException exceptionWithName:@"Abstract method!" reason:@"Subclass should implement me" userInfo:nil];
}

-(id) viewModelFromSubclass
{
    @throw [NSException exceptionWithName:@"Abstract method!" reason:@"Subclass should implement me" userInfo:nil];
}

-(NSArray *) tableData
{
    @throw [NSException exceptionWithName:@"Abstract method!" reason:@"Subclass should implement me" userInfo:nil];
}

-(void) createHeaderView
{
    @throw [NSException exceptionWithName:@"Abstract method!" reason:@"Subclass should implement me" userInfo:nil];
}

@end
