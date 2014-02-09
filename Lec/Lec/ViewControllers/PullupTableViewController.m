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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    
    [self.tableView registerClass:[LectureCell class] forCellReuseIdentifier:CELL_ID_HEADER];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID_ADD_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView stuff!

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == actionSection) [self actionBarPressed];
    else [self didSelectCellAt:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return noSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == contentSection ? [[self tableData] count] : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LectureCell *cell;
    
    if ([indexPath section] == contentSection) {
        cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_LECTURE_CELL];
        LECLectureCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexPath.row];
        [cell populateFor:cellViewModel];
    } else if (indexPath.section == actionSection) {
        return (UITableViewCell *) actionBar;
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
    if ([indexPath section] == 0)
        return 136;
    else
        return 75;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return hasFooter && section == contentSection ? 75 : 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!(hasFooter && section == contentSection)) return nil;
    
    return (UIView *)actionBar;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteObjectFromViewModel:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self. tableView reloadData];
    }
}

#pragma mark Scrolling Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headerView changeAlpha:self.tableView.contentOffset.y];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:-0.3+(self.tableView.contentOffset.y/100)], NSForegroundColorAttributeName, [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

#pragma mark Abstract methods
-(void) abstractMethod:(NSString *)methodName
{
    @throw [NSException exceptionWithName:@"Abstract method!" reason:
            [NSString stringWithFormat:@"Subclass should override %@",methodName] userInfo:nil];
}

-(void) deleteObjectFromViewModel:(NSInteger)index
{
    [self abstractMethod:@"deleteObjectFromViewModel"];
}

-(id) viewModelFromSubclass
{
    [self abstractMethod:@"viewModelFromSubclass"];
    return nil;
}

-(NSArray *) tableData
{
    [self abstractMethod:@"tableData"];
    return nil;
}

-(void) createHeaderView
{
    [self abstractMethod:@"createHeaderView"];
}

-(void) didSelectCellAt:(NSInteger)index
{
    [self abstractMethod:@"didSelectCellAt"];
}

-(void) actionBarPressed
{
    [self abstractMethod:@"Action bar pressed"];
}
@end
