//
//  RecordViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECAnimationService.h"
#import "RecordViewController.h"
#import "LECImportHeader.h"
#import "LECActionBar.h"
#import "LECLectureEditScreen.h"
#import "LECDefines.h"
#import "TagCell.h"

@interface RecordViewController (){
    LECLectureViewModel *viewModel;
    LECLectureEditScreen *preScreen;
}

@end

@implementation RecordViewController

- (id)initWithLecture:(Lecture *)lecture
{
    self = [super initWithNibName:@"RecordViewController" bundle:nil];
    if (self) {
        NSLog(@"Recording View Controller!");
        viewModel = [LECLectureViewModel viewModelWithLecture:lecture];
        [viewModel prepareForRecordingAudio];
        [viewModel startRecordingAudio];
        
        contentSection = 1; // the section with table data
        actionSection = 2; // the section with an action bar
        hasFooter = YES;
        noSections = 2;
        isRecordingScreen = YES;
        
        actionBar = [LECActionBar tagBarWithTarget:self andSelector:@selector(actionBarPressed)];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"icon_cancel.png"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"icon_cancel.png"];
    [[LECAnimationService sharedAnimationService]addAlphaToView:self.navigationController.navigationBar withSpeed:0.2 withDelay:0.0];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setupNavigationBar];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [viewModel stopRecordingAudio];
    self.navigationController.navigationBar.backIndicatorImage = NULL;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = NULL;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupNavigationBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_settings_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(lectureEdit)];
}

-(void)courseTableViewSetup
{
    [super courseTableViewSetup];
    [self.tableView registerClass:[TagCell class] forCellReuseIdentifier:CELL_ID_TAG_CELL];
}

-(void)createHeaderView
{
    self.headerView = [[LECHeaderView alloc] initWithLecture:viewModel andIsRecording:YES];
    [self.view addSubview:self.headerView];
}

-(void)lectureEdit
{
    preScreen = [[LECLectureEditScreen alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) withLectureViewModel:viewModel];
    preScreen.lectureEditDelegate = self;
    [self.view addSubview:preScreen];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    CGRect finalFrame = preScreen.frame;
    preScreen.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    
    [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        preScreen.frame = finalFrame;
    }completion:^(BOOL completion){
        
    }];
}

#pragma mark Delegate from the pre recording screen to head into recording
-(void) preRecordCancelled
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void) confirmChanges:(NSInteger)lectureNumber withName:(NSString *)lectureName
{
    viewModel.lecture.lectureName = lectureName;
    viewModel.lecture.lectureNumber = [NSNumber numberWithInteger:lectureNumber];
    [[LECDatabaseService sharedDBService]saveChanges];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationItem.title = [[self viewModelFromSubclass] navTitle];
}

#pragma mark Abstract methods implemented
-(UITableViewCell *) cellForIndexRow:(NSInteger)indexRow
{
    TagCell *cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID_TAG_CELL];
    LECTagCellViewModel *cellViewModel = [[self tableData] objectAtIndex:indexRow];
    [cell populateFor:cellViewModel];
    return (UITableViewCell *)cell;
}

-(void)deleteObjectFromViewModel:(NSInteger)index
{
    // delete tag!
}

-(id) viewModelFromSubclass
{
    return viewModel;
}

//Need to refactor
-(void)quickRecord
{
    
}

-(void) courseScroll:(CGFloat)scrollOffset
{
}

-(NSArray *) tableData
{
    return viewModel.tableData;
}

-(void) didSelectCellAt:(NSInteger)index
{
    // play tag?
}

-(void) actionBarPressed
{
    [viewModel addTagToCurrentTime];
    [self.tableView reloadData];
    // scroll to keep new cell at bottom of screen
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[viewModel.tableData count]-1 inSection:contentSection];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
