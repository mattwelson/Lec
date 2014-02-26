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

@interface PlaybackViewController (){
    LECLectureViewModel *viewModel;
}

@end

@implementation PlaybackViewController

- (id)initWithLecture:(Lecture *)lecture
{
    self = [super initWithNibName:@"PlaybackViewController" bundle:nil];
    if (self) {
        NSLog(@"Playback View Controller!");
        viewModel = [LECLectureViewModel viewModelWithLecture:lecture];
        [viewModel prepareForPlayback];
        [viewModel startAudioPlayback];
        
        contentSection = 1; // the section with table data
        actionSection = 2; // the section with an action bar
        hasFooter = YES;
        noSections = 2;
        
        actionBar = [LECActionBar tagBarWithTarget:self andSelector:@selector(actionBarPressed)];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [viewModel stopAudioPlayback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)courseTableViewSetup
{
    [super courseTableViewSetup];
    // register tag cell for resuse
}

-(void)createHeaderView
{
    self.headerView = [[LECHeaderView alloc] initWithLecture:viewModel];
    [self.view addSubview:self.headerView];
}

#pragma mark Abstract methods implemented
-(void)deleteObjectFromViewModel:(NSInteger)index
{
    // delete tag!
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
}

-(void) actionBarPressed
{
    [viewModel insertTagAtCurrentTime];
    [self.tableView reloadData];
    // scroll to keep new cell at bottom of screen
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[viewModel.tableData count]-1 inSection:contentSection];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
