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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    navBar.shadowImage = [UIImage new];
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                        [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:0.0], NSForegroundColorAttributeName,[UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
                        //self.navigationController.navigationBar.alpha = 0.0;
                          navBar.tintColor = [UIColor whiteColor];
                         [navBar setBackgroundColor:[UIColor clearColor]]; // apparently it is!
                         [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; // breaks shit when we go back.

                     }
                     completion:^(BOOL finished){
                         //self.navigationController.navigationBar.alpha = 1.0;
                     }];
    
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
    [self didSelectCellAt:indexPath.row];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) // the header or our empty state cell
        return 1;
    else
        return [[self tableData] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LectureCell *cell;
    
    if ([indexPath section] == 1) {
        cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_LECTURE_CELL];
        LECLectureCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexPath.row];
        [cell populateFor:cellViewModel];
    } else if (indexPath.section == 2) {
        cell = [[LectureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_ADD_CELL];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        [cell setUserInteractionEnabled:NO];
        if ([[self tableData] count] > 0){
            cell.textLabel.text = @"";
        } else {
            cell.textLabel.text = @"Pull down to add a thing";
        }
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
//    if ([indexPath section] == 2 && [[self tableData] count] > 0)
//        return 0;
    else // either empty state cell or a typical cell
        return 75;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{ // change to a different method? Not getting called enough
    [self.headerView changeAlpha:self.tableView.contentOffset.y];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1.0 alpha:-0.3+(self.tableView.contentOffset.y/100)], NSForegroundColorAttributeName, [UIFont fontWithName:DEFAULTFONT size:HEADERSIZE], NSFontAttributeName, nil]];
    
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

@end
