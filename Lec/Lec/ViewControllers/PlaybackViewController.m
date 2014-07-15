//
//  PlaybackViewController.m
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "PlaybackViewController.h"
#import "LECImportHeader.h"
#import "LECActionBar.h"
#import "TagCell.h"

@interface PlaybackViewController (){
    LECLectureViewModel *viewModel;
    LECLectureEditScreen *preScreen;
}

@end

@implementation PlaybackViewController

- (id)initWithLecture:(Lecture *)lecture
{
    self = [super initWithNibName:@"PlaybackViewController" bundle:nil];
    if (self) {
        viewModel = [LECLectureViewModel viewModelWithLecture:lecture];
        [viewModel setDelegate:self];
        
        [viewModel prepareForPlaybackWithCompletion:^{
            viewModel.canTag = NO;
            [self.tableView reloadData];
        }];
        //[viewModel startAudioPlayback];
        
        contentSection = 1; // the section with table data
        actionSection = -1; // the section with an action bar
        hasFooter = NO;
        isRecordingScreen = NO;
        isPlaybackScreen = YES;
        noSections = 1;
        
        //actionBar = [LECActionBar tagBarWithTarget:self andSelector:@selector(actionBarPressed)];
        
        playbackBar = [[LECPlaybackControls alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50) andWithViewModel:viewModel];
        playbackBar.playbackDelegate = self;
        [self.view addSubview:playbackBar];
        [self setupNavigationBar];
        [viewModel addObserver:actionBar forKeyPath:NSStringFromSelector(@selector(canTag)) options:NSKeyValueObservingOptionNew context:NULL];
        
        [viewModel.tableData enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
            LECTagCellViewModel *current = (LECTagCellViewModel *)obj;
            if (index == [viewModel.tableData count] - 1){
                [current setLengthTo:[[LECAudioService sharedAudioService] getRecordingLength]];
            } else {
                [current setLengthTo:[[(LECTagCellViewModel *)viewModel.tableData[index+1] time] doubleValue]];
            }
        }];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    //Make sure it moves to top, to get rid of the awkward nav bar positioning sometimes
    CGPoint point = CGPointMake(0, 1);
    [self.tableView setContentOffset:point animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [viewModel stopAudioPlayback];
}

-(void)setupNavigationBar
{
    UIImage *plusImg = [UIImage imageNamed:@"nav_settings_btn.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImg style:UIBarButtonItemStylePlain target:self action:@selector(lectureEdit)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)courseTableViewSetup
{
    [super courseTableViewSetup];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, playbackBar.frame.size.height, 0)];
    [self.tableView registerClass:[TagCell class] forCellReuseIdentifier:CELL_ID_TAG_CELL];
}

-(void)createHeaderView
{
    self.headerView = [[LECHeaderView alloc] initWithLecture:viewModel andIsRecording:NO];
    [self.view addSubview:self.headerView];
}

-(void)setTag:(NSInteger)tag toProgress:(CGFloat)progress
{
    
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
    [cell renderProgressBar:cellViewModel.progressPercentage];
    return (UITableViewCell *)cell;
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
    [viewModel goToTag:index];
    [self.tableView reloadData];
}

//Need to refactor
-(void)quickRecord
{
    
}

-(void) courseScroll:(CGFloat)scrollOffset
{
    
}

- (void)tagButtonPressed
{
    NSUInteger newIndex = [viewModel insertTagAtCurrentTime];
    [self.tableView reloadData];
    // scroll to keep new cell at bottom of screen
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newIndex inSection:contentSection];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//-(void) actionBarPressed
//{
//}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(void)reloadCellAtIndex:(NSInteger)index
{
    //[self.tableView reloadData];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:contentSection];
    //NSLog(@"Index path: %ld", (long)path.row);
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)reloadTable
{
    [self.tableView reloadData];
}


@end
